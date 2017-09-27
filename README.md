# Rook as an alternative to EBS in AWS

To evaluate storage options we’ll setup a [Kubernetes][1] cluster in AWS with a rook cluster deployed along with tools for debugging and metrics collection. Then we’ll deploy a pod with 4 different volumes to compare [Rook][2] block storage (backed by instance store), EBS gp2, EBS io1 (SSD) and EBS st1 (HDD) (re: [EBS volume types][3]). Finally, Rook Object Store is provisioned to compare to s3.

## 1. Kubernetes cluster setup

[Kubernetes kops][4] was used to generate an initial [Terraform][5] project and modified for our test case to bypass kops limitations. Terraform provisions AWS resources to host Kubernetes cluster, including VPC, network topology, policies, security groups and ASGs for nodes and master. `Nodeup` from Kops is used to bootstrap Kubernetes cluster.

For this test Kubernetes nodes are a mid range `i3.2xlarge`, with instance storage (1900 GiB NVMe SSD) and Up to 10 Gigabit networking performance. Kubernetes is installed on Ubuntu 16.04 LTS with 3 nodes plus the master.

Once the terraform run is complete, we should have a fully functioning Kubernetes cluster. To manage the cluster ssh to the master, or copy the config from there.

```bash
$ terraform apply
...
$ kubectl get nodes
NAME                                          STATUS    AGE       VERSION
ip-172-20-42-159.us-west-2.compute.internal   Ready     1m        v1.7.0
ip-172-20-42-37.us-west-2.compute.internal    Ready     2m        v1.7.0
ip-172-20-53-26.us-west-2.compute.internal    Ready     1m        v1.7.0
ip-172-20-55-209.us-west-2.compute.internal   Ready     1m        v1.7.0
```

## 2. Rook cluster deployment

Rook is easy to get running, we’ll run the latest release, 0.5 currently. It’ll manage [Ceph][6] cluster configured to our spec. First, _rook-operator_ needs to be deployed:

```bash
$ kubectl create -f k8s/rook-operator.yaml
clusterrole "rook-operator" created
serviceaccount "rook-operator" created
clusterrolebinding "rook-operator" created
deployment "rook-operator" created
```

&nbsp; :warning: &nbsp; Note, all nodes used by Rook cluster required to have Ceph tools installed, this requirement will be removed with the beta rook release, v.0.6. In this case, ceph tools were installed during terraform deployment by installing `ceph-fs-common` and `ceph-common` _Ubuntu_ packages through [instance user-data][7].

The Rook cluster is configured to deliver block storage using local disks (instance store) attached directly to hosts running our instances. The disk devices are selected by `deviceFilter`, instance store is `/dev/nvme0n1`

Once the rook cluster is created, you will notice that rook-operator created several pods in the rook namespace to manage ceph components:

```bash
$ kubectl create -f k8s/rook-cluster.yaml
namespace "rook" created
cluster "rook-eval" created
$ kubectl get pods --namespace rook
NAME                              READY     STATUS    RESTARTS   AGE
rook-api-3588729152-s0dxw         1/1       Running   0          46s
rook-ceph-mgr0-1957545771-bsg7h   1/1       Running   0          46s
rook-ceph-mon0-t1m3z              1/1       Running   0          1m
rook-ceph-mon1-mkdl4              1/1       Running   0          1m
rook-ceph-mon2-bv1qk              1/1       Running   0          1m
rook-ceph-osd-0027l               1/1       Running   0          46s
rook-ceph-osd-2p90r               1/1       Running   0          46s
rook-ceph-osd-d8j0j               1/1       Running   0          46s
```

Rook storage Pool and StorageClass have to be defined next. Note, that we are creating 2 replicas to provide resiliency on par with EBS:

```bash
$ kubectl create -f k8s/rook-storageclass.yaml
pool "replicapool" created
storageclass "rook-block" created
```

I also installed rook toolbox to provide better visibility into the Rook cluster and to create Rook object store with `rookctl` CLI.

```bash
$ kubectl create -f k8s/rook-tools.yaml
pod "rook-tools" created
$ kubectl -n rook exec -it rook-tools -- rookctl status
OVERALL STATUS: OK

USAGE:
TOTAL      USED       DATA      AVAILABLE
5.18 TiB   6.00 GiB   0 B       5.18 TiB

MONITORS:
NAME             ADDRESS                 IN QUORUM   STATUS
rook-ceph-mon0   100.66.63.114:6790/0    true        OK
rook-ceph-mon1   100.66.113.38:6790/0    true        OK
rook-ceph-mon2   100.68.185.191:6790/0   true        OK

MGRs:
NAME             STATUS
rook-ceph-mgr0   Active

OSDs:
TOTAL     UP        IN        FULL      NEAR FULL
3         3         3         false     false

PLACEMENT GROUPS (100 total):
STATE          COUNT
active+clean   100
```

At this point we have Kubernetes with Rook cluster up and running in AWS, we’ll be provisioning storage in the next steps.

## 3. Evaluation pod setup

Let’s create Persistent Volume Claim (PVC) using Rook block device attached to our testing pod along with different types of EBS devices. Before we proceed, EBS volumes have to be created, note _volume IDs_ outputted by each command to be used in our manifest later:

```bash
$ aws ec2 create-volume --availability-zone=us-west-2b --size=120 --volume-type=gp2
...
$ aws ec2 create-volume --availability-zone=us-west-2b --size=120 --volume-type=io1 --iops=6000
...
```

Let’s create a pod with 3 volumes to run our FIO tests against:

1. Rook volume mounted to `/eval`. 120 GiB, `ext4`.
1. EBS gp2 (General purpose) volume mounted to `/eval-gp2`. 120 GiB, `ext4`.
1. EBS io1 (Provisioned IOPS = 6K) volume mounted to `/eval-io1`. 120 GiB `ext4`.

```bash
$ kubectl create -f k8s/test-deployment.yaml
deployment "rookeval" created
$ kubectl get pods
NAME                             READY     STATUS    RESTARTS   AGE
rook-operator-3796250946-wwh3g   1/1       Running   0          10m
rookeval-1632283128-2c08m        1/1       Running   0          31s
$ kubectl exec -it rookeval-1632283128-2c08m -- df -Th --exclude-type=tmpfs
Filesystem     Type     Size  Used Avail Use% Mounted on
overlay        overlay  7.7G  2.8G  5.0G  36% /
/dev/xvdbe     ext4     118G   60M  112G   1% /eval-io1
/dev/rbd0      ext4     118G   60M  112G   1% /eval
/dev/xvdbi     ext4     118G   60M  112G   1% /eval-gp2
/dev/xvda1     ext4     7.7G  2.8G  5.0G  36% /etc/hosts
```

All looks good, ready to finally proceed with [FIO][8] tests. Our test pod currently has 3 different storage types to compare. It would be interesting to add rook clusters backed by EBSs of different types, and try different instance types as they provide different controllers and drives. Next time perhaps.

## 4. Rook Object store

[1]: https://kubernetes.io
[2]: https://rook.io
[3]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html
[4]: https://github.com/kubernetes/kops
[5]: https://www.terraform.io
[6]: http://ceph.com
[7]: https://github.com/paha/rook-aws/blob/master/terraform/data/aws_launch_configuration_nodes.rookeval.storos.io_user_data#L148
[8]: https://github.com/axboe/fio

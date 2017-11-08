See below for the sequence of events when starting the new EBS test pod.

The exact timestamps for the events can be found in the [event details](kubernetes-events.yaml).

```
$ kubectl describe pod ebs-only-client-7b49876fb5-b7n4d
Name:           ebs-only-client-7b49876fb5-b7n4d
Namespace:      default
Node:           ip-172-20-51-182.us-west-2.compute.internal/172.20.51.182
Start Time:     Wed, 08 Nov 2017 09:01:13 -0800
Labels:         app=eval
                pod-template-hash=3605432961
Annotations:    kubernetes.io/created-by={"kind":"SerializedReference","apiVersion":"v1","reference":{"kind":"ReplicaSet","namespace":"default","name":"ebs-only-client-7b49876fb5","uid":"aacf116e-c4a4-11e7-b096-0a570...
                kubernetes.io/limit-ranger=LimitRanger plugin set: cpu request for container rookeval
Status:         Running
IP:             100.96.1.10
Created By:     ReplicaSet/ebs-only-client-7b49876fb5
Controlled By:  ReplicaSet/ebs-only-client-7b49876fb5
Containers:
  rookeval:
    Container ID:  docker://9e1350fe22891668bd1255fce930d00fd1e2ecea8bd8753b4255e4af20d67a75
    Image:         ubuntu
    Image ID:      docker-pullable://ubuntu@sha256:6eb24585b1b2e7402600450d289ea0fd195cfb76893032bbbb3943e041ec8a65
    Port:          <none>
    Command:
      /bin/bash
      -c
      --
    Args:
      while true; do sleep 1; done;
    State:          Running
      Started:      Wed, 08 Nov 2017 09:05:26 -0800
    Ready:          True
    Restart Count:  0
    Requests:
      cpu:        100m
    Environment:  <none>
    Mounts:
      /eval-io1 from eval-ebs-io1 (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-thxk7 (ro)
Conditions:
  Type           Status
  Initialized    True 
  Ready          True 
  PodScheduled   True 
Volumes:
  eval-ebs-io1:
    Type:       AWSElasticBlockStore (a Persistent Disk resource in AWS)
    VolumeID:   vol-037b665e14ab0d110
    FSType:     ext4
    Partition:  0
    ReadOnly:   false
  default-token-thxk7:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-thxk7
    Optional:    false
QoS Class:       Burstable
Node-Selectors:  <none>
Tolerations:     node.alpha.kubernetes.io/notReady:NoExecute for 300s
                 node.alpha.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason                 Age   From                                                  Message
  ----     ------                 ----  ----                                                  -------
  Normal   Scheduled              5m    default-scheduler                                     Successfully assigned ebs-only-client-7b49876fb5-b7n4d to ip-172-20-51-182.us-west-2.compute.internal
  Normal   SuccessfulMountVolume  5m    kubelet, ip-172-20-51-182.us-west-2.compute.internal  MountVolume.SetUp succeeded for volume "default-token-thxk7"
  Warning  FailedMount            5m    attachdetach                                          AttachVolume.Attach failed for volume "eval-ebs-io1" : Error attaching EBS volume "vol-037b665e14ab0d110" to instance "i-0d5acd04e0ccb548f": "VolumeInUse: vol-037b665e14ab0d110 is already attached to an instance\n\tstatus code: 400, request id: 1be9b37c-0c14-47e9-acaf-fc0cda98092b". The volume is currently attached to instance "i-0e8ac361246ae85cf"
  Warning  FailedMount            5m    attachdetach                                          AttachVolume.Attach failed for volume "eval-ebs-io1" : Error attaching EBS volume "vol-037b665e14ab0d110" to instance "i-0d5acd04e0ccb548f": "VolumeInUse: vol-037b665e14ab0d110 is already attached to an instance\n\tstatus code: 400, request id: 76d74f5c-3255-498d-ac57-39f987e6c66a". The volume is currently attached to instance "i-0e8ac361246ae85cf"
  Warning  FailedMount            4m    attachdetach                                          AttachVolume.Attach failed for volume "eval-ebs-io1" : Error attaching EBS volume "vol-037b665e14ab0d110" to instance "i-0d5acd04e0ccb548f": "VolumeInUse: vol-037b665e14ab0d110 is already attached to an instance\n\tstatus code: 400, request id: 574e388c-93c6-4bb3-bdad-9cdd680a846a". The volume is currently attached to instance "i-0e8ac361246ae85cf"
  Warning  FailedMount            3m    kubelet, ip-172-20-51-182.us-west-2.compute.internal  Unable to mount volumes for pod "ebs-only-client-7b49876fb5-b7n4d_default(6d27f0b6-c4a6-11e7-b096-0a570863b3d2)": timeout expired waiting for volumes to attach/mount for pod "default"/"ebs-only-client-7b49876fb5-b7n4d". list of unattached/unmounted volumes=[eval-ebs-io1]
  Warning  FailedSync             3m    kubelet, ip-172-20-51-182.us-west-2.compute.internal  Error syncing pod
  Normal   SuccessfulMountVolume  1m    kubelet, ip-172-20-51-182.us-west-2.compute.internal  MountVolume.SetUp succeeded for volume "eval-ebs-io1"
  Normal   Pulling                1m    kubelet, ip-172-20-51-182.us-west-2.compute.internal  pulling image "ubuntu"
  Normal   Pulled                 1m    kubelet, ip-172-20-51-182.us-west-2.compute.internal  Successfully pulled image "ubuntu"
  Normal   Created                1m    kubelet, ip-172-20-51-182.us-west-2.compute.internal  Created container
  Normal   Started                1m    kubelet, ip-172-20-51-182.us-west-2.compute.internal  Started container
```
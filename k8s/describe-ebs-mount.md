In the description below notice that the EBS volume takes 16 seconds between the previous action and the mounting.
```
  26s		26s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal					Normal		SuccessfulMountVolume	MountVolume.SetUp succeeded for volume "default-token-thxk7" 
  10s		10s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal					Normal		SuccessfulMountVolume	MountVolume.SetUp succeeded for volume "eval-ebs-io1" 
```

Here is the full description of the pod.
```
$ kubectl describe pod ebs-only-client-5457ff745d-7744r
Name:		ebs-only-client-5457ff745d-7744r
Namespace:	default
Node:		ip-172-20-36-119.us-west-2.compute.internal/172.20.36.119
Start Time:	Tue, 07 Nov 2017 13:39:58 -0800
Labels:		app=eval
		pod-template-hash=1013993018
Annotations:	kubernetes.io/created-by={"kind":"SerializedReference","apiVersion":"v1","reference":{"kind":"ReplicaSet","namespace":"default","name":"ebs-only-client-5457ff745d","uid":"33f29c46-c404-11e7-b096-0a570...
		kubernetes.io/limit-ranger=LimitRanger plugin set: cpu request for container rookeval
Status:		Running
IP:		100.96.3.11
Created By:	ReplicaSet/ebs-only-client-5457ff745d
Controlled By:	ReplicaSet/ebs-only-client-5457ff745d
Containers:
  rookeval:
    Container ID:	docker://fd3b2a46cc1c4a27de2124da7802365cfcdcbbab664bd26cd99efa69c8bde234
    Image:		ubuntu
    Image ID:		docker-pullable://ubuntu@sha256:6eb24585b1b2e7402600450d289ea0fd195cfb76893032bbbb3943e041ec8a65
    Port:		<none>
    Command:
      /bin/bash
      -c
      --
    Args:
      while true; do sleep 1; done;
    State:		Running
      Started:		Tue, 07 Nov 2017 13:40:18 -0800
    Ready:		True
    Restart Count:	0
    Requests:
      cpu:		100m
    Environment:	<none>
    Mounts:
      /eval-io1 from eval-ebs-io1 (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-thxk7 (ro)
Conditions:
  Type		Status
  Initialized 	True 
  Ready 	True 
  PodScheduled 	True 
Volumes:
  eval-ebs-io1:
    Type:	AWSElasticBlockStore (a Persistent Disk resource in AWS)
    VolumeID:	vol-037b665e14ab0d110
    FSType:	ext4
    Partition:	0
    ReadOnly:	false
  default-token-thxk7:
    Type:	Secret (a volume populated by a Secret)
    SecretName:	default-token-thxk7
    Optional:	false
QoS Class:	Burstable
Node-Selectors:	eval=test
Tolerations:	node.alpha.kubernetes.io/notReady:NoExecute for 300s
		node.alpha.kubernetes.io/unreachable:NoExecute for 300s
Events:
  FirstSeen	LastSeen	Count	From							SubObjectPath			Type		Reason			Message
  ---------	--------	-----	----							-------------			--------	------			-------
  27s		27s		1	default-scheduler									Normal		Scheduled		Successfully assigned ebs-only-client-5457ff745d-7744r to ip-172-20-36-119.us-west-2.compute.internal
  26s		26s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal					Normal		SuccessfulMountVolume	MountVolume.SetUp succeeded for volume "default-token-thxk7" 
  10s		10s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal					Normal		SuccessfulMountVolume	MountVolume.SetUp succeeded for volume "eval-ebs-io1" 
  9s		9s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal	spec.containers{rookeval}	Normal		Pulling			pulling image "ubuntu"
  8s		8s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal	spec.containers{rookeval}	Normal		Pulled			Successfully pulled image "ubuntu"
  7s		7s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal	spec.containers{rookeval}	Normal		Created			Created container
  7s		7s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal	spec.containers{rookeval}	Normal		Started			Started container
  ```
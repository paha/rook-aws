In the description below notice that the Rook volume takes no time between the previous action and the mounting.
```
  16s		16s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal					Normal		SuccessfulMountVolume	MountVolume.SetUp succeeded for volume "default-token-thxk7" 
  16s		16s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal					Normal		SuccessfulMountVolume	MountVolume.SetUp succeeded for volume "pvc-60384409-c0e4-11e7-b096-0a570863b3d2" 
```

Here is the full description of the pod.
```
$ kubectl describe pod rook-only-client-649477c48f-prqvn 
Name:		rook-only-client-649477c48f-prqvn
Namespace:	default
Node:		ip-172-20-36-119.us-west-2.compute.internal/172.20.36.119
Start Time:	Tue, 07 Nov 2017 13:40:01 -0800
Labels:		app=eval
		pod-template-hash=2050337049
Annotations:	kubernetes.io/created-by={"kind":"SerializedReference","apiVersion":"v1","reference":{"kind":"ReplicaSet","namespace":"default","name":"rook-only-client-649477c48f","uid":"359d61c7-c404-11e7-b096-0a57...
		kubernetes.io/limit-ranger=LimitRanger plugin set: cpu request for container rookeval
Status:		Running
IP:		100.96.3.10
Created By:	ReplicaSet/rook-only-client-649477c48f
Controlled By:	ReplicaSet/rook-only-client-649477c48f
Containers:
  rookeval:
    Container ID:	docker://f4cdbe8ddab7393970ae302a4557853ff9bb91e7a637130aadae9138be776e3a
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
      Started:		Tue, 07 Nov 2017 13:40:04 -0800
    Ready:		True
    Restart Count:	0
    Requests:
      cpu:		100m
    Environment:	<none>
    Mounts:
      /eval from eval-block-storage (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-thxk7 (ro)
Conditions:
  Type		Status
  Initialized 	True 
  Ready 	True 
  PodScheduled 	True 
Volumes:
  eval-block-storage:
    Type:	PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:	rookeval-claim
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
  17s		17s		1	default-scheduler									Normal		Scheduled		Successfully assigned rook-only-client-649477c48f-prqvn to ip-172-20-36-119.us-west-2.compute.internal
  16s		16s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal					Normal		SuccessfulMountVolume	MountVolume.SetUp succeeded for volume "default-token-thxk7" 
  16s		16s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal					Normal		SuccessfulMountVolume	MountVolume.SetUp succeeded for volume "pvc-60384409-c0e4-11e7-b096-0a570863b3d2" 
  16s		16s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal	spec.containers{rookeval}	Normal		Pulling			pulling image "ubuntu"
  15s		15s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal	spec.containers{rookeval}	Normal		Pulled			Successfully pulled image "ubuntu"
  15s		15s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal	spec.containers{rookeval}	Normal		Created			Created container
  14s		14s		1	kubelet, ip-172-20-36-119.us-west-2.compute.internal	spec.containers{rookeval}	Normal		Started			Started container
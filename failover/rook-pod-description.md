See below for the sequence of events when starting the new Rook test pod.

The exact timestamps for the events can be found in the [event details](kubernetes-events.yaml).

```
$ kubectl describe pod rook-only-client-667d7dfd44-dgszt
Name:           rook-only-client-667d7dfd44-dgszt
Namespace:      default
Node:           ip-172-20-37-153.us-west-2.compute.internal/172.20.37.153
Start Time:     Wed, 08 Nov 2017 09:01:13 -0800
Labels:         app=eval
                pod-template-hash=2238389800
Annotations:    kubernetes.io/created-by={"kind":"SerializedReference","apiVersion":"v1","reference":{"kind":"ReplicaSet","namespace":"default","name":"rook-only-client-667d7dfd44","uid":"ad074caf-c4a4-11e7-b096-0a57...
                kubernetes.io/limit-ranger=LimitRanger plugin set: cpu request for container rookeval
Status:         Running
IP:             100.96.2.12
Created By:     ReplicaSet/rook-only-client-667d7dfd44
Controlled By:  ReplicaSet/rook-only-client-667d7dfd44
Containers:
  rookeval:
    Container ID:  docker://90aba46bfea7950617e2c43b7a71fb409ce36e7f5120ba6b81e9048bf1221c06
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
      Started:      Wed, 08 Nov 2017 09:01:15 -0800
    Ready:          True
    Restart Count:  0
    Requests:
      cpu:        100m
    Environment:  <none>
    Mounts:
      /eval from eval-block-storage (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-thxk7 (ro)
Conditions:
  Type           Status
  Initialized    True 
  Ready          True 
  PodScheduled   True 
Volumes:
  eval-block-storage:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  rookeval-claim
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
  Type    Reason                 Age   From                                                  Message
  ----    ------                 ----  ----                                                  -------
  Normal  Scheduled              50m   default-scheduler                                     Successfully assigned rook-only-client-667d7dfd44-dgszt to ip-172-20-37-153.us-west-2.compute.internal
  Normal  SuccessfulMountVolume  50m   kubelet, ip-172-20-37-153.us-west-2.compute.internal  MountVolume.SetUp succeeded for volume "default-token-thxk7"
  Normal  SuccessfulMountVolume  50m   kubelet, ip-172-20-37-153.us-west-2.compute.internal  MountVolume.SetUp succeeded for volume "pvc-60384409-c0e4-11e7-b096-0a570863b3d2"
  Normal  Pulling                50m   kubelet, ip-172-20-37-153.us-west-2.compute.internal  pulling image "ubuntu"
  Normal  Pulled                 50m   kubelet, ip-172-20-37-153.us-west-2.compute.internal  Successfully pulled image "ubuntu"
  Normal  Created                50m   kubelet, ip-172-20-37-153.us-west-2.compute.internal  Created container
  Normal  Started                50m   kubelet, ip-172-20-37-153.us-west-2.compute.internal  Started container
  ```
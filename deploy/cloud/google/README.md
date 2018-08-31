# Setting up in Google Cloud Kubernetes Engine
## Prerequesites
- gcloud SDK locally installed (https://cloud.google.com/sdk/downloads)
- kubectl installed (https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl)

## Set up
### Create cluster
```
gcloud beta container --project "nn-cloud-201314" clusters create "cluster-1" --zone "us-central1-a" --username "admin" --cluster-version "1.8.8-gke.0" --machine-type "n1-standard-1" --image-type "COS" --disk-size "100" --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "2" --network "default" --enable-cloud-logging --enable-cloud-monitoring --subnetwork "default" --addons HorizontalPodAutoscaling,HttpLoadBalancing,KubernetesDashboard
```

### Setup Services

$CONTEXT is you Google Container Context. For example: gke_nn-cloud-201314_us-central1-a_cluster-1

```
kubectl --context $CONTEXT apply -f mongo_small.yaml
kubectl --context $CONTEXT apply -f vinnsl-service.yaml
kubectl --context $CONTEXT apply -f vinnsl-nn-ui.yaml
kubectl --context $CONTEXT apply -f mongo-storage-service.yaml
kubectl --context $CONTEXT apply -f vinnsl-storage-service.yaml
kubectl --context $CONTEXT apply -f vinnsl-nn-worker.yaml
```

### Enable Service Discovery with Ingress
```
kubectl --context $CONTEXT apply -f ingress.yaml
```

## Usage

After a few minutes you can open the cluster ingress load balancer ip address to view the Vinnsl-NN-UI
You can get the address by executing
```
kubectl --context $CONTEXT get ingress cluster-ingress 
```

After successful setup should be able to open the following endpoints in your browser:

https://<ip-address>/#/ + endpoint

| endpoint        | Service                           |
| --------------- | --------------------------------- |
| /#/             | Vinnsl NN UI                      |
| /vinnsl         | Vinnsl Service                    |
| /status         | Vinnsl NN Status                  |
| /worker/queue   | Worker Queue                      |
| /storage        | Storage Service                   |
| /train/overview | DL4J Training UI (while training) |


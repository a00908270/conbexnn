# Setting up in Google Cloud Kubernetes Engine
## Prerequisites
- gcloud SDK locally installed (https://cloud.google.com/sdk/downloads)
- kubectl installed (https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl)

## Set up
### Create cluster

Replace `nn-cloud-201314` with your Google Cloud Platform Project

```
gcloud beta container --project "nn-cloud-201314" clusters create "cluster-2" --zone "us-central1-a" --username "admin" --cluster-version "1.9.7-gke.6" --machine-type "n1-standard-1" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --enable-cloud-logging --enable-cloud-monitoring --network "projects/nn-cloud-201314/global/networks/default" --subnetwork "projects/nn-cloud-201314/regions/us-central1/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing,KubernetesDashboard --no-enable-autoupgrade --enable-autorepair
```

### Setup Services

Configure kubectl to use the Google Cluster Context, or use the `--context` option. 

For example: gke_nn-cloud-201314_us-central1-a_cluster-1

```
kubectl apply -f mongo_small.yaml
kubectl apply -f vinnsl-service.yaml
kubectl apply -f vinnsl-nn-ui.yaml
kubectl apply -f mongo-storage-service.yaml
kubectl apply -f vinnsl-storage-service.yaml
kubectl apply -f vinnsl-nn-worker.yaml
```

### Enable Service Discovery with Ingress

#### a) Google Load Balancer

Google Load Balancer doesn't support all features. Endpoint `/train` and basic auth is not supported

```
kubectl apply -f ingress_gke.yaml
```

#### b) Nginx

In Cloud Console connect to you cluster and run the following commands

##### Install helm

```
curl -o get_helm.sh https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get
chmod +x get_helm.sh
./get_helm.sh
```

##### Install tiller

```
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'     
```

##### Init helm

```
helm init --service-account tiller --upgrade
```

##### Install nginx-ingress

```
helm install --name nginx-ingress stable/nginx-ingress --set rbac.create=true
```

##### Import Ingress Config

In your local kubectl context run

```
kubectl apply -f ingress.yaml
```

## Usage

After a few minutes you can open the cluster ingress load balancer ip address to view the Vinnsl-NN-UI
You can get the address by executing
```
kubectl get ingress cluster-ingress 
```

After successful setup should be able to open the following endpoints in your browser:

https://ip-address/#/ + endpoint

| endpoint        | Service                           |
| --------------- | --------------------------------- |
| /#/             | Vinnsl NN UI                      |
| /vinnsl         | Vinnsl Service                    |
| /status         | Vinnsl NN Status                  |
| /worker/queue   | Worker Queue                      |
| /storage        | Storage Service                   |
| /train/overview | DL4J Training UI (while training) |


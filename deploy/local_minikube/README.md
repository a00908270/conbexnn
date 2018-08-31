# Setting up on local machine with minikube
## Prerequesites

- minikube installed (https://github.com/kubernetes/minikube/releases)
- kubectl installed (https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl)

## Set up

### Start Cluster

```
minikube start
```

### Setup Services

cd into folder /deploy/local_minikube/

```bash
kubectl apply -f mongo_small.yaml
kubectl apply -f vinnsl-service.yaml
kubectl apply -f vinnsl-nn-ui.yaml
kubectl apply -f mongo-storage-service.yaml
kubectl apply -f vinnsl-storage-service.yaml
kubectl apply -f vinnsl-nn-worker.yaml
```

### Enable Service Discovery with Ingress

```
kubectl apply -f ingress.yaml
```

## Usage

After a few minutes you can open the cluster ingress ip address to view the Vinnsl-NN-UI
You can get the address by executing

```
kubectl get ingress cluster-ingress 
```
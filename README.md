# Container Based Execution Stack for Neural Networks (ConbexNN)
This a project features web services to train and evaluate neural networks in the cloud using the Kubernetes container orchestration and a Java based microservice architecture. 

## Demo VM
See the project in Action by running a virtual machine. It comes preconfigured with Kubernetes running all necessary ConbexNN services and a neural network training set for testing.

![VM Screenshot](deploy/vm/img/vm_small.jpg)

You can try out the RESTful API and GUI.

* See [instructions here](/deploy/vm/)

## Setup 

### Local

#### Setup on local machine with Docker Edge

Preferred if you have a Docker hypervisor compatible machine

You can setup and run this project with Docker Edge and Kubernetes enabled
See [instructions here](/deploy/local_dockerce/)

#### Setup on local machine with Minikube

You can setup and run this project with the Minikube VM
See [instructions here](/deploy/local_minikube/)

### Cloud

#### Setup in Google Cloud Kubernetes Engine

You can setup and run this project in Google Kubernetes Engine.
See [instructions here](/deploy/cloud/google/)

#### Setup in Microsoft Azure Kubernetes Service

You can setup and run this project in Microsoft Azure Kubernetes Service.
See [instructions here](/deploy/cloud/azure/)

#### Setup in Amazon EKS

You can setup and run this project in Microsoft EKS
This could not be tested, as billing must be enabled and EKS is not included in the AWS student program. Read the [amazon Documentation](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html) on how to deploy Kubernetes Clusters.
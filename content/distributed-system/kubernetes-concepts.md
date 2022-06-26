---
title: "kubernetes concepts"
date: "2022-06-26"
tags: [distributed system, kubernetes]
draft: true
---

# Overview

## What is Kubernetes?

Kubernetes is a portable, extensible, open source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation.
It has a large, lapidly growing ecosystem.
Kubernetes services, support, and tools are widely available.

The name Kubernetes originates from Greek, meaning helmsman or pilot.
K8s as an abbreviation results from counting the eight letters between the "K" and the "S".
Google open-sourced the Kubernetes project in 2014.
Kubernetes combines over 15 years of Google's experience running production workloads at scale with best-of breed ideas and practices from the community.

### Why you need Kubernetes and what it can do

Containers are a good way to bundle and run your applications.
In a production environment, you need to manage the containers that run the applications and ensure that there is no downtime.
For example, if a container goes down, another container needs to start. Wouldn't it be easier if this behavior was handled by a system?

That's how Kubernetes comes to the rescue! Kubernetes provides you with a frameowrk to rund distributed systems resiliently.
It takes care of scaling and failover for your application, provvides deployment patterns, and more.
For example, Kubernetes can easily manage a canary deployment for your system.

Kubernetes provides you with:

- Service discovery and load balancing: Kubernetes can expose a container using the DNS name or using their own IP address.
If traffic to a container is high, Kubernates is able to load balance and distribute the network traffic so that the deployment is stable.
- Storage orchestration: Kubernetes allows you to automatically mount a storage system of your choice, such as local storages, public cloud providers, and more.
- Automated rollouts and rollbacks: You can describe the desired state for your deployed containers using Kubernets, and it can change the actual state to the desired state at a controlled rate.
For example, you can automate Kubernetes to create new containers for your deployment, remove existing containers and adopt all their resources to the new container.
- Automatic bin packing: You provide Kubernetes with a cluster of nodes that it can use to run containerized tasks.
You tell Kubernetes how much CPU and memory (RAM) each container needs.
Kubernetes can fit containers onto your nodes to make the best of your reosurces.
- Self-healing: Kubernetes restars containers that fail, replaces containers, kills containers that don't respond to your user-defined health check, and doesn't advertise them to clients until they are ready to serve.
- Secret and configuration management: Kubernetes lets you store and manage sensitive information, such as passwords, OAuth tokens, and SSH keys.
You can deploy and update secrets and application configuration without rebuilding your container images, and without exposing secrets in your stack configuraition.

### What Kubernetes is not

Kubernetes is not a traditional, all-inclusive PaaS (Platform as a Service) system.
Since Kubernetes operates at the container level rather than at the hardware level, it provides some generally applicable features common to PaaS offerings, such as deployment, monitoring, load balancing, and lets uses integrate their logging, monitoring, and alerting solutions.
However, Kubernetes is not monolithic, and these default solutions are optional and pluggable.
Kubernetes provides the building blocks for building developer platforms, but preserves user choice and flexibility where it is importants.

Kubernetes:

- Does not limit the types of applications supported. Kubernetes aims to support an extremely diverse variety of workloads, including stateless, statefull, and data-processing workloads.
If an application can run in a container, it should run great on Kubernetes.
- Does not deploy source code and does not build your application. Continuous Integration, Delivery, and Deployment (CI/CI) workflows are determined by organization culutres and preferences as well as technical requirementes.
- Does not provide application-level services, such as middleware (for example, message buses), data-processing frameworks (for example, Spark), databases (for example, MySQL), caches, nor cluster storage systems (for example, Ceph) as built-in services.
Such components can run on Kubernetes, and/or can be accessed by applications running on Kubernetes through protable mechanisms, such as the Open Service Broker.
- Does not dictate logging, monitoring, or alerting solutions. It provides some integrations as proof of concept, and mechanisms to collect and export metrics.
- Does not provide nor mandate a configuration language/system (for example, Jsonnet).
It provies a declararive API that may be targeted by arbitary forms of declarative specifications.
- Does not provide nor adopt any comprehensive machine configuration, maintenance, management, or self-healing systems.
- Additionally, Kubernetes is not a mere orchestration system.
In fact, it elimintates the need for orchestration.
The technical definition of orchestration is execution of a defined workflow: first do A, then B, then C. In contrast, Kubernetes comprises a set of independent, composable control process that continuously drive the current state towards the provided desired state.
It shouldn't matter how you get from A to C. Centralized control is also not required. This results in a system that is easier to use an more powerful, robust, resilient, and extensible.

## Kubernetes Components

When you deploy Kubernetes, you get a cluster

A Kubernetes cluster consists of a set of worker machines, called nodes, that run containerized applications.
Every cluster has at least one worker node.

The worker node(s) host the Pods that are the components of the application workload.
The control plane manages the worker nodes and the Pods in the cluster.
In production environments, the control plane usually runs across multiple computers and a cluster usually runs multiple nodes, providing fault-tolerance and high availability.

This document outlines the various components you need to have for a complete and working Kubernetes cluster.

### Control Plane Components

The control plane's components make global decisions about the cluster (for example, scheduling), as well as detecting and responding to cluster events (for example, starting up a new pod when a deployment's `replicas` field is unsatistied).

Control plane components can be run on any machine in the cluster.
However, for simplicity, set up scripts typically start all control plane components on the same machine, and do not run user containers on this machine.
See Creating Highly Available clusters with kubeadm for an example control plane setup that runs across multiple machines.

#### kube-apiserver

The API server is a component of the Kubernetes control plane that exposes the Kubernetes API. The API server is the front end for the Kubernetes control plane.

The main implementation of a Kubernetes API server is kube-apiserver. kube-apiserver is designed to scale horizontally-that is, it scales by deploying more instances. You can run several instances of kube-apiserver and balance traffic between those instances.

#### etcd

Consistent and highly-available key value store used as Kubernetes' backing store for all cluster data.

If your Kubernetes cluster uses etcd as its backing store, make sure you have a back up plan for those data.

You can find in-depth information about etcd in th official documentation.

#### kube-scheduler

Control plane component that watches for newly created Pods with no assigned node, and selects a node for them to run on.

Factors taken into account for scheduling decisions include: individual and collective resource requirements, hardware/software/policy constraints, affinity and anti-affinity specifications, data locality, inter-workload interference, and deadlines.

#### kube-controller-manager

Control plane component that runs controller processes.

Logically, each controller is separate process, but to reduce complexity, they are all compiled into a single binary and run in a single process.

Some types of these controllers are:

- Node controller: Responsible for noticing and responding when nodes go down.
- Job controller: Watches for job objects that represent one-off tasks, then creates Pods to run those tasks to completion.
- Endpoints controller: Populates the Endpoints object (that is, joins Services & Pods).
- Service Account & Token controllers: Create default accounts and API access tokens for new namespaces.

#### cloud-controller-manager

A Kubernetes control plane component that embeds cloud-specific control logic.
The cloud controller manager lets you link your cluster into your cloud provider's API, and seperates out the components that interact with that cloud platform from components that only interact with your cluster.

The cloud-controller-manager only runs controllers that are specific to your cloud provider.
If you are running Kubernetes on your own premises, or in a learning environment inside your own PC, the cluster does not have a cloud controller manager.

As with the kube-controller-manager, the cloud-controller-manager combines several logically independent control loops into a single binary that you run as a single process.
You can scale horizontally (run more than one copy) to improve performance or to help tolerate failures.

The following controllers can have cloud provider dependencies:

- Node controller: For checking the cloud provider to determine if a node has been deleted in the cloud after it stops responding
- Route controller: For setting up routes in the underlying cloud infrastructure
- Service controller: For creating, updating and deleting cloud provider load balancers

### Node Components

Node components run on every node, maintaining running pods and providing the Kubernetes runtime environment.

#### kubelet

An agent that runs on each node in the cluster. It makes sure that containers are running in a Pod.

The kubelet takes a set of PodSpecs that are provided through various mechanisms and ensures that the containers described in those PodSpecs are running and healthy.
The kubelet doesn't manage containers which were not created by Kubernetes.

#### kube-proxy

kube-proxy is a network proxy that runs on each node in your cluster, implementing part of the Kubernetes Service concept.

kube-proxy maintains network rules on nodes. These network rules allow network communication to your Pods from network sessions inside or outsied of your cluster.

kube-proxy uses the operating system packet filtering layer if there is one and it's available.
Otherwise, kube-proxy forwards the traffic itself.

#### Container runtime

The container runtime is the software that is responsible for running containers.

Kubernetes supports container runtimes such as containerd, CRI-O, and any other implementation of the Kubernetes CRI (Container Runtime Interface).

### Addons

Addons use Kubernetes resources (DaemonSet, Deployment, etc) to implement cluster features.
Because these are providing cluster-level features, namespaced resources for addons belong within the `kube-system` namespace.

Selected addons are described below; for an extended list of available addons, please see Addons.

#### DNS

While the other addons are not strictly required, all Kubernetes clusters should have cluster DNS, as many examples rely on it.

Cluster DNS is a DNS server, in addition to the other DNS server(s) in your environment, which serves DNS records for Kubernetes services.

Containers started by Kubernetes automatically include this DNS server in their DNS searches.

#### Web UI (Dashboard)

Dashboard is a general purpose, web-based UI for Kubernetes clusters.
It allows users to manage and troubleshoot applications running in the cluster, as well as the cluster itself.

#### Container Resource Monitoring

Container Resource Monitoring records generic time-series metrics about containers in a central database, and provides a UI for browsing that data.

#### Cluster-level Logging

A cluster-level loggin mechanism is responsible for saving container logs to a central log store with search/browsing interface.

## The Kubernetes API

The core of Kubernetes' control plane is the API server.
The API server exposes an HTTP API that lets end users, different parts of your cluster, and external components communicate with one another.

Ther Kubernetes API lets you query and manipulate the state of API objects in Kubernetes (for example: Pods, Namespaces, ConfigMaps, and Events).

Most operations can be performed though the kubectl command-line interface or other command-line tools, such as kubeadm, which in turn use the API.
However, you can also access the API directly using REST calls.

Consider using one of the client libraries if you are writing an application using the Kubernetes API.

## Working with Kubernets Objects

Kubernetes objects are persistent entities in the Kubernetes system.
Kubernetes uses these entities to represent the stat of your cluster.
Learn about the Kubernetes object model and how to work with these objects.

### Understanding Kubernetes Objects

Kubernetes objects are persistent entities in the Kubernetes system.
Kubernetes uses these entities to represent the stat of your cluster.
Specifically, they can describe:

- What containerized applications are running (and on which nodes)
- The resources available to those applications
- The policies around how those applications behave, such as restart policies, upgrades, and fault-tolerance

A Kubernetes object is a "record of intent"--once you create the object, the Kubernetes system will constantly work to ensure that object exists.
By creating an object, your're effectively telling the Kubernetes system what you want your cluster's workload to look like; this is your cluster's desired state.

To work with Kubernetes objects--whether to create, modify, or delete them--you'll need to use the Kubernetes API. When you use the `kubectl` command-line interface, for example, the CLI makes the necessary Kubernetes API calls for you.
You can also use the Kubernetes API directly in your own programs using one of the Client Libraries.

#### Object Spec and Status

Almost every Kubernetes object includes two nested object fields hat govern the object's configuration: the object `spec` and the object `status`.
For objects that have a `spec`, you have to set this when you create the object, providing a description of the characteristics you want the resource to have: its desired state.

The `status` describes the current state of the object, supplied and updated by the Kubernetes system and its components.
The Kubernetes control plane continually and actively manages every object's actual state to match the desired state you supplied.

For example: in Kubernetes, a Deployment is an object that can represent an application running on your cluster.
Wher you create the Deployment, you might set the Deployment `spec` to specify that you want three replicas of the application to be running.
The Kubernetes system reads the Deployment `spec` and starts three instances of your desired application--updating the status to match your spec.
If any of those instances should fail (a status change), the Kubernetes system responds to the difference between `spec` and `status` by makeing a correction--in this case, starting a replacement instance.

#### Describing a Kubernetes object

Wher you create an object in Kubernetes, you must provide the object spec that describes its desired state, as well as some basic information about the object (such as a name).
When you use the Kubernetes API to create the object (either directly or via `kubectl`), that API request must include that information as JSON in the request body.
Most often, you provide the information to `kubectl` in a .yaml file.
`kubectl` converts the information to JSON when making the API request.

Here's an example `.yaml` file that shoes the required fields and object spec for a Kubernetes Deployment:

application/deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

One way to create a Deployment using a `.yaml` file like the one above is to use the `kubectl apply` command in the `kubectl` command-line interface, passing the `.yaml` file as an argument. Here's an example:

```bash
kubectl apply -f https://k8s.io/examples/application/deployment.yaml
```

The output is similar to this:

```
deployment.apps/nginx-deployment created
```

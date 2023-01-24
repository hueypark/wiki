---
title: "Using Helm"
date: "2023-01-24"
tags: ["helm", "infra", "kubernetes"]
---

This page based on [Using Helm](https://helm.sh/docs/intro/using_helm/) for personal notes. If you want to learn more, please visit the official website.

---

# Theree Big Concepts

A `Chart` is a Helm package. It contains all of the resource definitions necessary to run an application, tool, or service inside of a Kubernetes cluster. Think of it like the Kubernetes equivalent of a Homebrew formula, an Apt dpkg, or a Yum RPM file.

A `Repository` is the place where charts can be collected and shared. It's like Perl's CPAN archive or the Fedora Package Database, but for Kubernetes packages.

A `Release` is an instance of a chart running in a Kubernetes cluster. Onc chart can often be installed many times into the same cluster. And each time it is installed, a new release is created. Consider a MySQL chart. If you want two databases running in your cluster, you can install that chart twice. Each one will have its own release, which will in turn have its own release name.

With these concepts in mind, we can now explain Helm like this:

Helm installs charts into Kubernetes, creating a new release for each installation. And to find new charts, you can search Helm chart repositories.

# `helm search`: Finding Charts

Helm comes with a powerful search command. It can be used to search two different types of source:

- `helm search hub` searchs the Aritifact Hub, which lists helm charts from dozens of different repositories.
- `helm search repo` searches the repositories that you have added to your local helm client(with `helm repo add`). This search is done over local data, and no public network connection is needed.

# `helm install`: Installing a Package

To install a new package, use the `helm install` command. At its simplest, it takes two arguments: A release name that you pick, and the name of the chart you want to install.

# `helm upgrade`: and `helm rollback`: Upgrading a Release, and Recovering on Failure

When a new version of a chart is released, or when you want to change the configuration of your release, you can use the `helm upgrade` command.

An upgrade takes an existing release and upgrades it according to the information you provide. Because Kubernetes charts can be large and complex, Helm tries to perform the least invasive upgrade. It will only update things that have changed since the last release.

The `helm get` command is a useful tool for looking at a release in the cluster. And as we can see above, it shows that our new values from `panda.yaml` were deployed to the cluster.

Now, if something does not go as planned during a release, it is easy to roll back to a previous release using `helm rollback [RELEASE] [REVISION]`.

# `helm uninstall`: Uninstalling a Release

When it is time to uninstall a release from the cluster, use the `helm uninstall` command:

This will remove the release from the cluster. You can see all of your currently deployed releases with the `helm list` command.

# `helm repo`: Working with Repositories

Helm 3 no longer ships with a default chart repository. The `helm repo` command group provides commands to add, list, and remove repositories.

You can see which repositories are configured using `helm repo list`.

And new repositories can be added with `helm repo add`.

Because chart repositories change frequently, at any point you can make sure your Helm client is up to date by running `helm repo update`.

Repositories can be removed with `helm repo remove`.

# Creating Your Own Charts

The [Chart Development Guide](https://helm.sh/docs/topics/charts/) explains how to develop your own charts. But you can get started quickly by using the `helm create` command.

When it's time to package the chart up for distribution, you can run the `helm package` command.

And that chart can now easily be installed by `helm install`.

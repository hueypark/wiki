---
title: "Helm Charts"
date: "2023-01-24"
tags: ["helm", "infra", "kubernetes"]
---

This page based on [Charts](https://helm.sh/docs/topics/charts/) for personal notes. If you want to learn more, please visit the official website.

---

# Charts

Helm uses a packaging format called charts. A chart is a collection of files that describe a related set of Kubernetes resources. A single chart might be used to deploy something simple, like a memcached pod, or something complex, like a full web app stack with HTTP servers, databases, caches, and so on.

Charts are created as files laid out in a particular directory tree. They can be packaged into versioned archives to be deployed.

If you want to download and look at the files for a published chart, without installing it, you can do so with `helm pull chartrepo/chartname`.

This document explains the chart format, and provides basic guidance for building charts with Helm.

## The Chart File Structure

A chart is organized as a collection of files inside of a directory. The directory name is the namr of the chart(withour versioning information). Thus, a chart describing WordPress would be stored in a `wordpress/` directory.

```
Chart.yaml          # A YAML file containing information about the chart
  LICENSE             # OPTIONAL: A plain text file containing the license for the chart
  README.md           # OPTIONAL: A human-readable README file
  values.yaml         # The default configuration values for this chart
  values.schema.json  # OPTIONAL: A JSON Schema for imposing a structure on the values.yaml file
  charts/             # A directory containing any charts upon which this chart depends.
  crds/               # Custom Resource Definitions
  templates/          # A directory of templates that, when combined with values,
                      # will generate valid Kubernetes manifest files.
  templates/NOTES.txt # OPTIONAL: A plain text file containing short usage notes
```

## The Chart.yaml file

The `Chart.yaml` file is required for a chart. It contains the following fields:

```yaml
apiVersion: The chart API version (required)
name: The name of the chart (required)
version: A SemVer 2 version (required)
kubeVersion: A SemVer range of compatible Kubernetes versions (optional)
description: A single-sentence description of this project (optional)
type: The type of the chart (optional)
keywords:
  - A list of keywords about this project (optional)
home: The URL of this projects home page (optional)
sources:
  - A list of URLs to source code for this project (optional)
dependencies: # A list of the chart requirements (optional)
  - name: The name of the chart (nginx)
    version: The version of the chart ("1.2.3")
    repository: (optional) The repository URL ("https://example.com/charts") or alias ("@repo-name")
    condition: (optional) A yaml path that resolves to a boolean, used for enabling/disabling charts (e.g. subchart1.enabled )
    tags: # (optional)
      - Tags can be used to group charts for enabling/disabling together
    import-values: # (optional)
      - ImportValues holds the mapping of source values to parent key to be imported. Each item can be a string or pair of child/parent sublist items.
    alias: (optional) Alias to be used for the chart. Useful when you have to add the same chart multiple times
maintainers: # (optional)
  - name: The maintainers name (required for each maintainer)
    email: The maintainers email (optional for each maintainer)
    url: A URL for the maintainer (optional for each maintainer)
icon: A URL to an SVG or PNG image to be used as an icon (optional).
appVersion: The version of the app that this contains (optional). Needn't be SemVer. Quotes recommended.
deprecated: Whether this chart is deprecated (optional, boolean)
annotations:
  example: A list of annotations keyed by name (optional).
```

### Charts and Versioning

Every chart must have a version number. A version must follow the `SemVer2` standard. Unlike Helm Classic, Helm v2 and later uses version numbers as release markers. Packages in repositories are identified by name plus version.

For example, an `nginx` chart whose version field is set to `version: 1.2.3` will be named:

```
nginx-1.2.3.tgz
```

More complex SemVer 2 names are also supported, such as `version: 1.2.3-alpha.1+ef365`. But non-SemVer names are explicitly disallowed by the system.

The `version` field inside of the `Chart.yaml` is used by many of the Helm tools, including the CLI. When generating a package, the `helm package` coomand will use the version that it finds in the `Chart.yaml` as a token in the package name. The system assumes that the version number in the chart package name matches the version number in the `Chart.yaml`. Failure to meet this asuumption will cause an error.

### The `apiVersion` Field

The `apiVersion` field should be `v2` for Helm charts that require at least Helm 3. Charts supporting previous Helm versions have an `apiVersion` set to `v1` and are still installable by Helm 3.

### The `appVersion` Field

Note that the `appVersion` field is not related to the `version` field. It is a way of specifying the version of th application. For example, the `drupal` chart may have an `appVersion: "8.2.1"`, indicating that the version of Drupal included in the chart (by default) is `8.2.1`. This field is informational, and has no impact on chart version calculations. Wrapping the version in quotes is highly recommended. It forces the YAML parser to treat the version number as a string. Leaving it unquoted can lead to parsing issues in some cases. For example, YAML interprets `1.0` as a floating point value, and a git commit SHA like `1234e10` as scientific notation.

### The `kubeVersion` Field

The optional `kubeVersion` field can define semver constraints on supported Kubernetes versions. Helm will validate the version constraints when installing the chart and fail if the cluster runs an unsupported Kubernetes version.

Version constraints may comprise space separated `AND` comparisons such as

```
>= 1.13.0 < 1.15.0
```

which themselves can be combined with the `OR` `||` operator like in the following example

```
>= 1.13.0 < 1.14.0 || >= 1.14.1 < 1.15.0
```

In this example the version `1.14.0` is excluded, which can make sense if a bug in certain versions is known to prevent the chart from running properly.

### Deprecating Charts

When managing charts in a Chart Repository, it is sometimes necessary to deprecate a chart. The optional `deprecated` field in `Chart.yaml` can be used to mark a chart as deprecated. If the lates version of a chart in the repository is marked as deprecated, then the chart as a whole is considered to be deprecated. The chart name can be later reused by publishing a newer version that is not marked as deprecated. The workflow for deprecating charts is:

1. Update chart's `Chart.yaml` to mark the chart as deprecated, bumping the version
2. Release the new chart version in the Chart Repository
3. Remove the chart from the source repository (e.g. git)

### Chart Types

The `type` field defines the type of chart. There are two types: `application` and `library`. Application is the default type and it is the standard chart which can be operated on fully. The `library chart` provides utilities or functions for the chart builder. A library chart differs from an application chart because it is not installable and usually doesn't contain any resource objects.

## Chart Dependencies

In Helm, one chart may depend on any number of other charts. These dependencies can be dynamically linked using the `dependencies` field in `Chart.yaml` or brought in to the `charts/` directory and managed manually.

### Managing Dependencies with the `dependencies` field

The charts required by the current chart are defined as a list in the `dependencies` field.

```yaml
dependencies:
  - name: apache
    version: 1.2.3
    repository: https://example.com/charts
  - name: mysql
    version: 3.2.1
    repository: https://another.example.com/charts
```

- The `name` field is the name of the chart you want.
- The `version` field is the version of the chart you want.
- The `repository` field is the full URL to the chart repository. Note that you must also use `helm repo add` to add that repo locally.
- You might use the name of the repos instead of URL

Once you have defined dependencies, you can run `helm dependency update` and it will use your dependency file to download all the specidied charts into your `charts/` directory for you.

When `helm dependency update` retrieves charts, it will store them as chart archives in the `charts/` directory. So for the example above, one would expect to see the following files in the charts directory:

```
charts/
  apache-1.2.3.tgz
  mysql-3.2.1.tgz
```

### Alias field in dependencies

In addition to the other fields above, each requirements entry may contain the optional field `alias`.

Adding an alias for a dependency chart would put a chart in dependencies using alias as name of new dependency.

One can use `alias` in cases where they need to access a chart with other name(s).

```yaml
# parentchart/Chart.yaml

dependencies:
  - name: subchart
    repository: http://localhost:10191
    version: 0.1.0
    alias: new-subchart-1
  - name: subchart
    repository: http://localhost:10191
    version: 0.1.0
    alias: new-subchart-2
  - name: subchart
    repository: http://localhost:10191
    version: 0.1.0
```

In the above example we will get 3 dependencies in all for `parentchart`:

```
subchart
new-subchart-1
new-subchart-2
```

The manual way of achieving this is by copy/pasting the same chart in the `charts/` directory multiple times with different names.

### Tags and Condition fields in dependencies

In addition to the other fields above, each requirements entry may contain the optional fields `tags` and `condition`.

All charts are loaded by default. If `tags` or `condition` fields are present, they will be evaluated and used to control loading for the chart(s) they are applied to.

Condition - The condition field holds one ore more YAML paths (delimited by commas). If this path exists in the top parent's values and resolves to a boolean value, the chart will be enabled or disabled based on that boolean value. Only the first valid path found in th list is evaluated and if no paths exist then the condition has no effect.

Tags - The tags field is a YAML list of labels to associate with this chart. In the top parent's values, all charts with tags can be enabled or disabled by specifying the tag and boolean value.

```yaml
# parentchart/Chart.yaml

dependencies:
  - name: subchart1
    repository: http://localhost:10191
    version: 0.1.0
    condition: subchart1.enabled,global.subchart1.enabled
    tags:
      - front-end
      - subchart1
  - name: subchart2
    repository: http://localhost:10191
    version: 0.1.0
    condition: subchart2.enabled,global.subchart2.enabled
    tags:
      - back-end
      - subchart2
```

```yaml
# parentchart/values.yaml

subchart1:
  enabled: true
tags:
  front-end: false
  back-end: true
```

In the above example all charts with the tag `front-end` would be disabled but since the `subchart1.enabled` path evaluates to 'true' in the parent's values, the condition will override the `front-end` tag and `subchart1` will be enabled.

Since `subchart2` is tagged with `back-end` and that tag evaluates to `true`, `subchart2` will be enabled. Also note that althought `subchart2` has a condition specified, there is no corresponding path and value in the parent's values so that condition has no effect.

### Managing Dependencies manually via the `charts/` directory

If more control over dependencies is desired, these dependencies can be expressed explictly by copying the dependency charts into the `charts/` directory.

A dependency should be an unpacked chart directory but its name cannot start with `_` or `.`. Such files are ignored by the chart loader.

For example, if the WordPress chart depends on the Apache chart, the Apache chart (of the correct version) is supplied in the WordPress chart's `charts/` directory:

```yaml
wordpress:
  Chart.yaml
  # ...
  charts/
    apache/
      Chart.yaml
      # ...
    mysql/
      Chart.yaml
      # ...
```

The example above shows how the WordPress chart expresses its dependency on Apache and MySQL by including those charts inside of its `charts/` directory.

TIP: To drop a dependency into your `charts/` directory, use the `helm pull` command

## Templates and Values

Helm Chart templates are written in the Go temlate language, with the addition of 50 or so add-on template functions from the Spring library and a few other specialized functions.

All template files are stored in a chart's `templates/` folder. When Helm renders the charts' it will pass every file in that directory through the template engine.

Values for the templates are supplied two ways:

- Chart developers may supply a file called `values.yaml` inside of a chart. This file can contain default values.
- Chart users may supply a YAML file that contains values. This can be provided on the command line with `helm install`.

When a user supplies custom values, these values will override the values in the chart's `values.yaml` file.

### Template Files

Template files follow the standard conventions for writing Go templates (see the text/template Go package documentation for details). An example template file might look something like this:

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: deis-database
  namespace: deis
  labels:
    app.kubernetes.io/managed-by: deis
spec:
  replicas: 1
  selector:
    app.kubernetes.io/name: deis-database
  template:
    metadata:
      labels:
        app.kubernetes.io/name: deis-database
    spec:
      serviceAccount: deis-database
      containers:
        - name: deis-database
          image: {{ .Values.imageRegistry }}/postgres:{{ .Values.dockerTag }}
          imagePullPolicy: {{ .Values.pullPolicy }}
          ports:
            - containerPort: 5432
          env:
            - name: DATABASE_STORAGE
              value: {{ default "minio" .Values.storage }}
```

The above example, based loosely on `https://github.com/deis/charts`, is a template for a Kubernetes replication controller. It can use the following four template values (usually defined in a balues.yaml file):

- imageRegistry: The source registry for the Docker image.
- dockerTag: The tag for the docker image.
- pullPolicy: The Kubernetes pull policy.
- storage: The storage backend, whose default is set to "minio"

All of these values are defined by the template authour. Helm does not require or dictate parameters.

To see many working charts, check out the CNCF Aritifact Hub.

### Prefefined Values

Values that are supplied via a `values.yaml` file (or via the `--set` flag) are accessible from the `.Values` object in a template. But there are other pre-defined pieces of data you can access in your templates.

The following values are pre-defined, are available to every template, and cannot be overridden, As with all values, the names are case sensitive.

- Release.Name: The name of the release (not the chart)
- Release.Namespace: The namespace the chart was released to.
- Release.Service: The service that conducted the release.
- Release.IsUpgrade: This is set to true if the current operation is an upgrade or rollback.
- Release.IsInstall: This is set to true if the current operation is and install.
- Chart: The contents of the `Chart.yaml`. Thus, the chart version is obtainable as `Chart.Version` and the maintainers are in `Chart.Maintainers`.
- Files: A map-like object containing all non-special files in the chart. This will not give you access to templates, but will give you access to additional files that are present (unless they are excluded using `.helmignore`). Files can be accessed using `{{ index .Files "file.name" }}` or using `{{.Files.Get name}}` function. You can alos access the contents of the files as `[]byte` using `{{ .Files.GetBytes }}`
- Capabilities: A map-like object that contains information about the version of Kubernetes(`{{ .Capabilities.KubeVersion}}`) and the supported Kubernetes API versions (`{{ .Capabilities.APIVersions.Has "batch/v1" }}`)

NOTE: Any unknown `Chart.yaml` fields will be dropped. They will not be accessible inside of the `Chart` object. Thus, `Chart.yaml` cannot be used to pass arbitrarily structured data into the template. The values file can be used for that, though.

### Values files

Considering the template in the previous section, a `values.yaml` file that supplies the necessary values would look like this:

```yaml
imageRegistry: "quay.io/deis"
dockerTag: "latest"
pullPolicy: "Always"
storage: "s3"
```

A values file is formatted in YAML. A chart may include a default `values.yaml` file. The Helm install command allows a user to override values by supplying additional YAML values:

```
$ helm install --generate-name --values=myvals.yaml wordpress
```

## Using Helm to Manage Charts

The `helm` tool has several commands for working with charts.

It can create a new chart for you:

```
$ helm create mychart
Created mychart/
```

Once you have edited a chart, `helm` can package it into a chart archive for you:

```
$ helm package mychart
Archived mychart-0.1.-.tgz
```

You can also use `helm` to help you find issues with your chart's formatting or information:

```
$ helm lint mychart
No issues found
```

## Chart Repositories

A chart repository is an HTTP server that houses one ore more packaged charts. While `helm` can be used to manage local chart directories, when it comes to sharing charts, the preferred mechanism is a chart repository.

Any HTTP server that can serve YAML files and tar files and can answer GET requests can be used as a repository server. The Helm team has tested some servers, including Google Cloud Storage with website mode enabled, and S3 with website mode enabled.

A repository is characterized primarily by the presence of a special file called `index.yaml` that has a list of all of the packages supplied by the repository, together with metadata that allows retrieving and verifying those packages.

On the client side, repositories are managed with the `helm repo` commands. However, Helm does not provide tools for uploading charts to remote repository servers. This is because doing so would add substantial requirements to an implementing server, and thus raise the barrire for setting up a repository.

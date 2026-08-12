# helm-charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/dependencytrack)](https://artifacthub.io/packages/search?repo=dependencytrack)

## Usage

Charts are published as OCI artifacts to GitHub Container Registry.
This is the preferred way to consume them:

```shell
helm install dt oci://ghcr.io/dependencytrack/helm-charts/dependency-track
```

> [!NOTE]
> OCI is only available for `dependency-track` chart version 2.1.0 and later.

Alternatively, the charts remain available from the classic Helm repository:

```shell
helm repo add dependencytrack https://dependencytrack.github.io/helm-charts

helm search repo dependencytrack
```

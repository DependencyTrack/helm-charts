# helm-charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/dependencytrack)](https://artifacthub.io/packages/search?repo=dependencytrack)

For deployment instructions, see the [Kubernetes deployment guide](https://dependencytrack.github.io/docs/next/guides/administration/deploying-to-kubernetes/).

> [!NOTE]
> The `dependency-track` chart v1 does not support Dependency-Track v5.
> A v5-compatible release is coming as `dependency-track` chart v2.
>
> The `hyades` chart will be discontinued when `dependency-track` chart v2 is released.
> New users should wait for v2, or be ready to migrate when v2 is released.

## Usage

Add Dependency-Track's repository:

```shell
helm repo add dependency-track https://dependencytrack.github.io/helm-charts
```

View available charts:

```shell
helm search repo dependency-track
```

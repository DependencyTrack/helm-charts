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

## Verifying charts

Charts are signed with GPG. Signatures are published as `.prov` files alongside
the chart, in both the OCI registry and the Helm repository.
Refer to [Helm Provenance and Integrity](https://helm.sh/docs/topics/provenance/) for details.

> [!NOTE]
> Only `dependency-track` chart version 2.1.0 and later are signed.

Import the signing key and export it to a keyring Helm can read.

```shell
curl -fsSL https://raw.githubusercontent.com/DependencyTrack/helm-charts/main/KEYS | gpg --import

gpg --export dependencytrack+helm@owasp.org > /tmp/dependencytrack-keyring.gpg
```

> [!TIP]
> The export step is necessary because Helm only reads the legacy `pubring.gpg` format,
> which GnuPG stopped maintaining with version 2.1 (see [helm/helm#31836](https://github.com/helm/helm/issues/31836),
> [helm/helm#32281](https://github.com/helm/helm/pull/32281))

Verify at pull time:

```shell
helm pull oci://ghcr.io/dependencytrack/helm-charts/dependency-track \
  --prov --verify --keyring /tmp/dependencytrack-keyring.gpg
```

`--verify` works with `helm install` and `helm upgrade` as well.

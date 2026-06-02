# Upgrading

## From chart 1.x (Dependency-Track 4.x) to 2.0 (Dependency-Track 5.x)

Chart 2.0 targets Dependency-Track 5, a major application release with breaking schema and runtime
changes. The chart was rewritten alongside it. Resource names, values keys, the secrets model, and the
file-storage model all changed. **You cannot run `helm upgrade` from 1.x to 2.0.** Plan a maintenance
window, take backups, and reinstall.

> [!TIP]
> Before translating your config, install the chart with [`values-quickstart.yaml`](values-quickstart.yaml)
> into a scratch namespace or test cluster to get a feeling for the new values layout.
> It bundles an inline Postgres and a fixture KEK, so it's standalone with no Secrets to provision
> (see the [Quickstart section in `README.md`](README.md#quickstart) for the command).
> Use it to try out `apiServer.topology`, autoscaling, probes, and Ingress wiring.
> It does NOT exercise your real database, KEK, or S3 Secrets, so validate those separately.

### 1. Read the release notes first

- The official Dependency-Track [Migrating from v4][migrate-v4] guide.
  It covers the application-level changes you need to handle before you point the new chart at your database.
- This `UPGRADING.md`, which covers the chart-level changes.

### 2. Back up the database

Run `pg_dump` against the Dependency-Track database and store the dump somewhere safe.

> [!NOTE]
> **You do not need to migrate the v1 `/data` volume.** Nothing on it is read by chart 2.0 or
> Dependency-Track v5. The new file storage (PVC or S3 bucket) starts empty.
> If you ran v1 with `apiServer.persistentVolume.enabled: true`, delete the old PVC after cutover.

### 3. Migrate the database to Dependency-Track 5

Follow the [Migrating from v4][migrate-v4] guide against your database.
The database must be on a v5-compatible baseline before you install the new chart.
Chart 2.0 then runs any remaining [init tasks][init-tasks-ref] (database migrations,
default-object seeding, partition maintenance) on first startup, either in the api-server
pods or in a dedicated initializer Job (see [step 6](#6-translate-your-valuesyaml)).

### 4. Provision the Secrets the new chart expects

Chart v2 does not generate these. Create them with your usual secret tooling
(External Secrets Operator, Vault, SealedSecrets, or plain `kubectl`):

- **Database Secret.** Keys `username` and `password` by default, overridable with
  `database.existingSecret.usernameKey` and `passwordKey`. Reference it from `database.existingSecret.name`.
  Remove the v1 `ALPINE_DATABASE_*` entries from `apiServer.extraEnv`. The chart now wires `DT_DATASOURCE_*`
  from this Secret for you, and the JDBC URL moves to `database.jdbcUrl`.
  See the [datasources reference][datasources-ref].
- **KEK Secret.** Required when `secretManagement.provider` is `database` (the default).
  One of two things:
  - A base64-encoded 32-byte AES key (`mode: config`). Default Secret key `kek`.
    Easy to provision (`openssl rand -base64 32`) but cannot be rotated in place.
  - A [Tink AES-GCM JSON keyset][tink-keyset] (`mode: keyset`). Default Secret key `kek-keyset.json`.
    Supports rotation. Recommended for long-running production.

  Reference it from `secretManagement.database.kek.existingSecret.name` and override the key name with
  `secretManagement.database.kek.existingSecret.key`. The chart mounts it under `/etc/dt/secrets/sm/database/kek/`.
  See the [secret management reference][secret-mgmt-ref].
- **S3 credentials Secret.** Only needed when `fileStorage.provider: s3`. Keys `accessKeyId` and
  `secretAccessKey` by default (override via
  `fileStorage.s3.credentials.existingSecret.accessKeyIdKey` and `secretAccessKeyKey`), mounted under
  `/etc/dt/secrets/s3/`. Skip it on EKS, GKE, or AKS if you attach a workload identity to the chart's
  ServiceAccount instead. See the [file storage reference][file-storage-ref].

The v4 `secret.key` (`common.secretKey.*`) is **gone**. Dependency-Track 5 keeps secrets in Postgres,
encrypted with the KEK. There is nothing to copy over from the old file.

### 5. Pick a file-storage backend

Chart 2.0 introduces a top-level `fileStorage` block. There is no v1 data to carry over, so pick what
fits the new deployment:

- **Local PVC, single replica.** `provider: local` (the default). The chart provisions a fresh PVC
  with the `helm.sh/resource-policy: keep` annotation.
- **S3.** `provider: s3`. Required if you plan to scale `apiServer.web.replicaCount` above 1 on
  cloud-default RWO block storage.
- **RWX volume.** `provider: local` plus `accessModes: [ReadWriteMany]` and a StorageClass that
  supports RWX (such as EFS, Azure Files, or CephFS).

See the [file storage reference][file-storage-ref].

### 6. Translate your `values.yaml`

The 1.x keys below moved, were renamed, or were removed in 2.0.

The `common.*` namespace is gone. Every key that lived under `common` now sits at the root:

- `common.nameOverride` becomes `nameOverride`.
- `common.fullnameOverride` becomes `fullnameOverride`.
- `common.image.{registry,pullSecrets}` becomes `image.{registry,pullSecrets}`.
- `common.serviceAccount.{create,annotations,name}` becomes `serviceAccount.{create,annotations,name}`.
- `common.enableServiceLinks` becomes `enableServiceLinks`. The default also flipped from `true` to
  `false`.
- `common.serviceAccount.automount` is removed. The chart always sets
  `automountServiceAccountToken: false`. For a projected service-account token, add it via
  `additionalVolumes`.
- `common.secretKey.createSecret` and `common.secretKey.existingSecretName` are removed. Use the new
  top-level `secretManagement.*` block. See the [secret management reference][secret-mgmt-ref].

Other renames and removals:

- `apiServer.deploymentType` is removed. The chart always renders a `Deployment`, no `StatefulSet`.
- `apiServer.metrics.enabled` is removed. Metrics are always on. Scrape via the new `ServiceMonitor`
  on the `management` port (default `9000`). The `prometheus.io/scrape` pod annotations 1.x emitted
  automatically are also gone (see [step 8](#8-verify) if you scrape via annotations).
- `apiServer.persistentVolume.{enabled,className,size}` is replaced by the new top-level `fileStorage`
  block: `fileStorage.provider: local` plus `fileStorage.local.{storage,storageClassName,accessModes,existingClaim,mountPath}`.
- `apiServer.annotations` and `frontend.annotations` now annotate the `Deployment` object, not the
  pod template. Move pod-template annotations to the new `apiServer.podAnnotations` and `frontend.podAnnotations`.
- `apiServer.resources`, `apiServer.tolerations`, and `apiServer.nodeSelector` move to
  `apiServer.web.{resources,tolerations,nodeSelector}`. If you switch to `apiServer.topology: split`,
  also set the matching `apiServer.worker.*` keys. New per-role values sit alongside them: `affinity`,
  `topologySpreadConstraints`, `terminationGracePeriodSeconds`, `revisionHistoryLimit`, `priorityClassName`.
- `apiServer.probes.{startup,liveness,readiness}.path` is removed. Probes always target
  `/health/{started,live,ready}` on the `management` port. Only the timing fields (`failureThreshold`,
  `periodSeconds`, and so on) remain configurable.
- `apiServer.extraPodLabels` is renamed to `apiServer.podLabels`.
- `apiServer.extraEnv` entries that set `ALPINE_DATABASE_*` must be removed.
  Use the new top-level `database.*` block. See the [datasources reference][datasources-ref].
- `frontend.extraPodLabels` is renamed to `frontend.podLabels`.
- `frontend.replicaCount` is still supported. An HPA is also available via `frontend.autoscaling.*`.
- Frontend liveness and readiness probes now target `/static/config.json` instead of `/`.
  If you health check the frontend from an upstream Ingress or Gateway, update the external check path to match.
- The chart Ingress now routes only `/api` to the api-server and `/` to the frontend.
  The v1 `/health` and `/mirror` routes are gone.

New values worth investigating before you upgrade:

- `apiServer.initializer.enabled: true` runs the init tasks (migrations, seeding, partition maintenance)
  as a single `pre-install`/`pre-upgrade` Job instead of in every starting pod.
  See the [corresponding `README.md` section](README.md#initializer) for details.
- `apiServer.topology: split` runs separate web and worker Deployments, keeping API traffic isolated
  from background work.
- Per-role `autoscaling`, `pdb`, `topologySpreadConstraints`, and `terminationGracePeriodSeconds`.
- `frontend.enabled: false` for API-only deployments.
- `secretManagement.provider: env` resolves DT-side secrets from `DT_SECRET_*` env vars instead of the
  DB-encrypted store. Useful if you already deliver secrets via ESO or Vault and do not want to manage
  a KEK.
- The new `management` port (default `9000`) carries `/health` and `/metrics` and is exposed only inside
  the pod (no Service port). When using a `NetworkPolicy`, allow your `ServiceMonitor` source to reach it.

For the full list of Dependency-Track properties the chart maps to environment variables, see the
[configuration properties reference][properties-ref].

### 7. Cut over

v1 resource names are prefixed with the release fullname, usually `<release>-dependency-track`
(just `<release>` when the release name already contains `dependency-track`). Confirm the exact names first:

```sh
kubectl get statefulset,deployment,svc,pvc,secret \
  -n <namespace> -l app.kubernetes.io/instance=<release>
```

Then cut over, substituting the names you found.
The examples below assume the common `<release>-dependency-track` prefix:

```sh
# 1. Scale the old release to zero so nothing writes to the database.
kubectl scale --replicas=0 statefulset/<release>-dependency-track-api-server -n <namespace>
kubectl scale --replicas=0 deployment/<release>-dependency-track-frontend -n <namespace>

# 2. Uninstall v1.
helm uninstall <release> -n <namespace>

# 3. Delete leftovers. The legacy secret.key Secret carries `helm.sh/resource-policy: keep`,
#    and `StatefulSet` data PVCs are never removed by `helm uninstall`.
#    v2 uses neither, so delete them manually.
kubectl delete secret <release>-dependency-track-secret-key -n <namespace> --ignore-not-found
kubectl delete pvc data-<release>-dependency-track-api-server-0 -n <namespace> --ignore-not-found

# 4. Install v2 with your new values file.
helm install <release> oci://ghcr.io/dependencytrack/charts/dependency-track \
  -n <namespace> \
  -f values-v2.yaml
```

### 8. Verify

- Run `kubectl get pods -n <namespace>`. The api-server pods should reach `Ready`.
  The startup probe budget covers init tasks. If init tasks take longer than 30 minutes,
  raise `apiServer.probes.startup.failureThreshold` and pass `helm install --timeout` accordingly.
  If you enabled the initializer Job, watch the Job instead. The pods start only after it completes.
- Open the UI and sign in.
- Confirm Prometheus is scraping the new headless `<release>-dependency-track-api-server-metrics`
  Service on the `management` port. If you do not use prometheus-operator and relied on the v1
  `prometheus.io/scrape` pod annotations, the chart no longer emits them. Either turn on the
  `ServiceMonitor` (`apiServer.serviceMonitor.enabled: true`) or re-create the annotations yourself:
  ```yaml
  apiServer:
    podAnnotations:
      prometheus.io/scrape: "true"
      prometheus.io/port: "9000" # apiServer.service.managementPort
      prometheus.io/path: "/metrics"
  ```

### 9. Rollback plan

If startup fails before you take live traffic:

1. Run `helm uninstall <release>`.
2. Restore the database from your `pg_dump` to its pre-v5 state.
3. Reinstall chart 1.x.

Once Dependency-Track v5 has written to the database, rollback always needs the database backup.
Chart 1.x cannot read a v5-migrated schema.

## From the `hyades` chart to `dependency-track` v2

The `hyades` chart was the preview chart for Dependency-Track v5. It is discontinued in favor of this
chart. Both target Dependency-Track v5, so unlike the 1.x path this is **not** a database migration.
Your schema and data carry over untouched. What changed is the chart alone: Resource names, the entire values
layout, the secrets model, and the file-storage model are different. **You cannot `helm upgrade` from
`hyades` to `dependency-track`**, because the chart name and resource ownership differ. Reinstall into
the same namespace, pointing at the same database.

> [!TIP]
> The same [`values-quickstart.yaml`](values-quickstart.yaml) advice from the 1.x guide applies here.
> Install it into a scratch namespace or test cluster first to get a feeling for the new values layout
> before translating your `hyades` config.

### 1. Back up the database

Both charts run Dependency-Track v5, so there is no schema migration to perform.
Still run `pg_dump` before you cut over, in case you need to roll back.

### 2. Provision the Secrets the new chart expects

`hyades` injected the database credentials straight into the pod as env vars and did not manage a KEK.
The new chart mounts credentials as files and, by default, expects a KEK Secret you provision out of band.
Follow [step 4 of the 1.x guide](#4-provision-the-secrets-the-new-chart-expects) to create the Database, KEK,
and (if you use S3) credentials Secrets.

> [!NOTE]
> If your `hyades` instance stored secrets in the database (integration credentials, for example),
> those were encrypted with the key Dependency-Track used at the time. Make sure the KEK you provision
> matches, or you may be unable to decrypt them. A fresh instance has nothing to carry over.

### 3. Pick a file-storage backend

`hyades` used `apiServer.persistentVolume`, which defaulted to an ephemeral `emptyDir`.
The new chart introduces the top-level `fileStorage` block and provisions a PVC by default.
Follow [step 5 of the 1.x guide](#5-pick-a-file-storage-backend), then map your old keys per the table below.

### 4. Translate your `values.yaml`

The `common.*` namespace is gone. Every key that lived under `common` now sits at the root:

- `common.nameOverride` becomes `nameOverride`.
- `common.fullnameOverride` becomes `fullnameOverride`.
- `common.image.{registry,pullSecrets}` becomes `image.{registry,pullSecrets}`.
  The default registry also flipped from `ghcr.io` to `docker.io`.
- `common.database.{jdbcUrl,username,password}` becomes `database.{jdbcUrl,username,password}`
  (see [step 2](#2-provision-the-secrets-the-new-chart-expects)).
- `common.serviceAccount.{create,annotations,name}` becomes `serviceAccount.{create,annotations,name}`.
- `common.serviceAccount.automount` is removed. The chart always sets `automountServiceAccountToken: false`.
  For a projected service-account token, add it via `additionalVolumes`.

The api-server config now has a role dimension. Every flat `apiServer.*` value moved under `apiServer.web.*`
(the role that runs in the default `monolith` topology):

- `apiServer.enabled` is removed. The api-server is always rendered.
  (`frontend.enabled: false` still exists for API-only deployments.)
- `apiServer.autoScaling` becomes `apiServer.web.autoscaling` (note the lower-case `s`).
  Rendering fails on the old key, so the rename will not pass silently.
- `apiServer.replicaCount` becomes `apiServer.web.replicaCount`.
- `apiServer.{resources,tolerations,nodeSelector,terminationGracePeriodSeconds}` become `apiServer.web.*`.
  New per-role keys exist alongside them: `affinity`, `topologySpreadConstraints`, `revisionHistoryLimit`,
  `priorityClassName`, and `pdb`. Switch to `apiServer.topology: split` to also configure `apiServer.worker.*`.
- `apiServer.extraLabels` is renamed to `apiServer.podLabels`.
- `apiServer.annotations` now annotates the `Deployment` object, not the pod template.
  Move pod-template annotations to the new `apiServer.podAnnotations`.
- `apiServer.image.pullPolicy` default changed from `Always` to `IfNotPresent`.
- `apiServer.serviceMonitor` is unchanged in shape, but the default `scrapeInterval` changed from `15s`
  to `60s` and `scrapeTimeout` from `10s` to `30s`.

Storage:

- `apiServer.persistentVolume.{enabled,existingClaim,className,size,accessModes}` is replaced by the new
  top-level `fileStorage` block: `enabled` becomes `fileStorage.provider: local`, `className` becomes
  `fileStorage.local.storageClassName`, and `size`, `existingClaim` and `accessModes` keep their names
  under `fileStorage.local.*`.
- The chart now always provisions a PVC for `provider: local` (the old `emptyDir` default is gone),
  and the automatic `ReadWriteMany`-on-scale behavior is gone. Set `accessModes: [ReadWriteMany]`
  yourself when scaling above one replica on `local`, or use `fileStorage.provider: s3`.

Initializer (the block moved and was redesigned):

- Top-level `initializer.*` becomes `apiServer.initializer.*`, exposing only `enabled`, `backoffLimit`,
  `resources`, and `podAnnotations`. It inherits `apiServer.{securityContext,initContainers,extraEnv,extraEnvFrom}`.
- `initializer.noHelmHook` and `initializer.waiter.{image,createRole}` are removed. The new initializer is
  a `pre-install` / `pre-upgrade` Helm hook only. There is no `post-install` Job, no `bitnami/kubectl`
  waiter init-container, and no Rol / RoleBinding. App pods block on Helm hook ordering instead.
- The dedicated `initializer.{image,command,args,securityContext,extraEnv,extraEnvFrom,tolerations,nodeSelector}`
  keys are removed in favor of the inherited `apiServer.*` values above.
- New requirement: `apiServer.initializer.enabled` needs `database.existingSecret.name`.
  The hook runs before chart-managed Secrets exist, so the DB credentials must be provisioned separately.

Frontend:

- `frontend.autoScaling` becomes `frontend.autoscaling` (lower-case `s`).
- `frontend.extraLabels` is renamed to `frontend.podLabels`.
- `frontend.image.pullPolicy` default changed from `Always` to `IfNotPresent`.
- Frontend liveness and readiness probes now target `/static/config.json` instead of `/`.
  Update any upstream Ingress or Gateway health check to match.

Routing and extras (`ingress.*`, `httpRoute.*`, `extraObjects`) keep their shape.
The chart Ingress now routes only `/api` to the api-server and `/` to the frontend.

For the full list of Dependency-Track properties the chart maps to environment variables,
see the [configuration properties reference][properties-ref].

### 5. Cut over

```sh
# 1. Scale the old hyades release to zero so nothing writes to the database.
kubectl scale --replicas=0 deployment -l app.kubernetes.io/instance=<release> -n <namespace>

# 2. Uninstall hyades.
helm uninstall <release> -n <namespace>

# 3. Delete the old PVC if you ran hyades with `apiServer.persistentVolume.enabled: true`.
#    Nothing on it is read by the new chart.
kubectl get pvc -n <namespace> -l app.kubernetes.io/instance=<release>
kubectl delete pvc <old-claim> -n <namespace> --ignore-not-found

# 4. Install the new chart with your translated values file, pointing at the same database.
helm install <release> oci://ghcr.io/dependencytrack/charts/dependency-track \
  -n <namespace> \
  -f values-v2.yaml
```

Then verify as in [step 8 of the 1.x guide](#8-verify).

[datasources-ref]: https://dependencytrack.github.io/docs/next/reference/configuration/datasources/
[file-storage-ref]: https://dependencytrack.github.io/docs/next/reference/configuration/file-storage/
[init-tasks-ref]: https://dependencytrack.github.io/docs/next/reference/configuration/init-tasks/
[migrate-v4]: https://dependencytrack.github.io/docs/next/guides/administration/migrating-from-v4/
[properties-ref]: https://dependencytrack.github.io/docs/next/reference/configuration/properties/
[secret-mgmt-ref]: https://dependencytrack.github.io/docs/next/guides/administration/configuring-secret-management/#database
[tink-keyset]: https://developers.google.com/tink/design/keysets

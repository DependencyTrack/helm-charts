# dependency-track

![Version: 2.0.0-rc.1](https://img.shields.io/badge/Version-2.0.0--rc.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 5.0.2](https://img.shields.io/badge/AppVersion-5.0.2-informational?style=flat-square)

Dependency-Track is an intelligent Component Analysis platform
that allows organizations to identify and reduce risk in the software supply chain.

**Homepage:** <https://github.com/DependencyTrack/dependency-track>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| nscuro | <nscuro@protonmail.com> | <https://github.com/nscuro> |

## Source Code

* <https://github.com/DependencyTrack/helm-charts/tree/main/charts/dependency-track>

## Requirements

Kubernetes: `>=1.27.0-0`

## Quickstart

Evaluate the chart on any conformant Kubernetes cluster, no Postgres or KEK Secret needed:

```sh
helm install dt oci://ghcr.io/dependencytrack/charts/dependency-track \
  --create-namespace -n dependency-track \
  -f https://raw.githubusercontent.com/DependencyTrack/helm-charts/main/charts/dependency-track/values-quickstart.yaml

kubectl -n dependency-track port-forward svc/dt-dependency-track-frontend 8080:8080
# Open http://localhost:8080 - default credentials: admin / admin
```

> [!WARNING]
> The quickstart values bundle an inline Postgres and a fixture KEK Secret.
> They are NOT suitable for production. The Postgres has no persistence and
> the KEK is a public, deterministic fixture.
>
> For real deployments, provision Postgres and the KEK Secret separately.
> Reference them via `database.existingSecret.name` and `secretManagement.database.kek.existingSecret.name`.

## Upgrading from chart 1.x

Chart 2.0 is a rewrite for Dependency-Track 5 and is not API-compatible with
chart 1.x. See [UPGRADING.md](UPGRADING.md) for the migration procedure.

## OpenShift compatibility

The chart targets parity with OpenShift's `restricted-v2` SCC and the Kubernetes Pod Security Admission
`restricted` profile. Every workload pod ships with:

- `allowPrivilegeEscalation: false`
- `capabilities.drop: [ALL]`
- `runAsNonRoot: true`
- `seccompProfile.type: RuntimeDefault`
- `readOnlyRootFilesystem: true` (except the frontend)
- no `hostNetwork`, `hostPID`, `hostIPC`, `hostPath`, or `privileged: true`
- no ports below 1024, no `NodePort` default

OpenShift assigns UIDs and supplemental groups per namespace via the active SCC.
The chart's `fsGroup: 1000` defaults fall outside most namespaces' allowed ranges.
Override on install:

```yaml
apiServer:
  podSecurityContext: ~
frontend:
  podSecurityContext: ~
```

If the namespace's default SCC does not already grant `restricted-v2`,
bind it to the chart-created `ServiceAccount`:

```sh
oc adm policy add-scc-to-user restricted-v2 \
  -z <release>-dependency-track \
  -n <namespace>
```

## Initializer

On startup, `api-server` pods run Dependency-Track's initialization tasks
(database schema migrations, default-object seeding, and partition maintenance),
serialized across pods by a Postgres advisory lock.
This needs no configuration and works for both Helm and GitOps installs.

Every pod runs these tasks on startup. They are idempotent, but each run still costs a little
to check whether migrations are pending, whether default data already exists, and so on.
With many replicas or autoscaling, that overhead repeats on every pod and every scale-up.
The initializer Job confines it to a single run and lets all api-server replicas skip initialization entirely:

```yaml
apiServer:
  initializer:
    enabled: true
```

When enabled, the Job becomes the sole initializer. It runs as a `pre-install`/`pre-upgrade` Helm hook
and completes **before** the `api-server` pods start, which then skip in-pod initialization.
Helm, Flux (its helm-controller runs hooks), and Argo CD (which runs `pre-install` hooks as a `PreSync` step)
all honor this with no extra annotations.

Do note however:

- **Credentials must come from existing Secrets.** The hook runs before the chart's own Secrets are created,
  so set `database.existingSecret.name`. Provision it separately. Chart rendering fails if the initializer
  is enabled without `database.existingSecret.name`.
- **The Job runs on every sync.** Argo CD re-runs `PreSync` on each sync. This is safe because the tasks no-op
  when the database is already current. If your team disables Helm hooks in Argo CD entirely,
  leave the initializer *off* and keep the default startup initialization.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiServer.additionalVolumeMounts | list | `[]` |  |
| apiServer.additionalVolumes | list | `[]` |  |
| apiServer.annotations | object | `{}` | Annotations on the Deployment(s). |
| apiServer.args | list | `[]` |  |
| apiServer.command | list | `[]` |  |
| apiServer.deployment.strategy | object | `{"rollingUpdate":{"maxSurge":0,"maxUnavailable":1},"type":"RollingUpdate"}` | `maxSurge: 0` avoids cluster overcommit on multi-CPU pods. |
| apiServer.extraContainers | list | `[]` |  |
| apiServer.extraEnv | list | `[]` | Extra env applied to web, worker and initializer. Don't set chart-managed variables (DT_DATASOURCE_*, DT_CONFIG_PROFILE, DT_METRICS_*, DT_MANAGEMENT_*, DT_FILE_STORAGE_*, DT_SECRET_MANAGEMENT_*, DT_INIT_TASKS_*). |
| apiServer.extraEnvFrom | list | `[]` |  |
| apiServer.image.pullPolicy | string | `"IfNotPresent"` |  |
| apiServer.image.registry | string | `""` | Override `image.registry` for the API server. |
| apiServer.image.repository | string | `"dependencytrack/apiserver"` | Repository of the `apiserver` image. |
| apiServer.image.tag | string | `""` | Tag name or `sha256:<digest>`. Defaults to the chart's `appVersion`. |
| apiServer.initContainers | list | `[]` |  |
| apiServer.initializer | object | `{"backoffLimit":3,"enabled":false,"initContainers":[],"podAnnotations":{},"resources":{"limits":{"memory":"256Mi"},"requests":{"cpu":"150m","memory":"256Mi"}}}` | Initializer Job settings. Runs DT's init tasks (migrations, default-object seeding, partition maintenance) as a pre-install/pre-upgrade Helm hook instead of in every starting api-server pod. Requires `database.existingSecret`. See the Initializer section in the README. |
| apiServer.podAnnotations | object | `{}` |  |
| apiServer.podLabels | object | `{}` |  |
| apiServer.podSecurityContext | object | `{"fsGroup":1000}` | `fsGroup: 1000` matches the DT container UID so chart-mounted PVCs are writable. On OpenShift (and any cluster that assigns UIDs/GIDs via SCC or PSA), set `podSecurityContext: ~` so the namespace picks the effective fsGroup. |
| apiServer.probes.liveness.failureThreshold | int | `3` |  |
| apiServer.probes.liveness.initialDelaySeconds | int | `10` |  |
| apiServer.probes.liveness.periodSeconds | int | `15` |  |
| apiServer.probes.liveness.successThreshold | int | `1` |  |
| apiServer.probes.liveness.timeoutSeconds | int | `5` |  |
| apiServer.probes.readiness.failureThreshold | int | `3` |  |
| apiServer.probes.readiness.initialDelaySeconds | int | `10` |  |
| apiServer.probes.readiness.periodSeconds | int | `5` |  |
| apiServer.probes.readiness.successThreshold | int | `1` |  |
| apiServer.probes.readiness.timeoutSeconds | int | `5` |  |
| apiServer.probes.startup | object | `{"failureThreshold":60,"initialDelaySeconds":10,"periodSeconds":30,"successThreshold":1,"timeoutSeconds":5}` | Startup probe timing. The budget covers schema migrations on first install and upgrades: 60 * 30s = 30 min, enough for any realistic single-step DT migration. For multi-hour upgrade migrations, bump this and pass `helm upgrade --timeout 30m`, since Helm's 5-minute default fires first. |
| apiServer.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Container security context. Defaults target the restricted Pod Security Standard. |
| apiServer.service.annotations | object | `{}` |  |
| apiServer.service.managementPort | int | `9000` | Management port (health + metrics) exposed only on the pod. |
| apiServer.service.nodePort | string | `nil` |  |
| apiServer.service.port | int | `8080` |  |
| apiServer.service.type | string | `"ClusterIP"` |  |
| apiServer.serviceMonitor.enabled | bool | `false` | Whether to create a Prometheus Operator ServiceMonitor scraping the management port. |
| apiServer.serviceMonitor.labels | object | `{}` |  |
| apiServer.serviceMonitor.namespace | string | `"monitoring"` | Namespace for the ServiceMonitor. Set it where your Prometheus selects ServiceMonitors. |
| apiServer.serviceMonitor.scrapeInterval | string | `"60s"` |  |
| apiServer.serviceMonitor.scrapeTimeout | string | `"30s"` |  |
| apiServer.topology | string | `"monolith"` | The topology to deploy. Possible choices are `monolith` (single `Deployment`), or `split` (separate `web` and `worker` `Deployment`s, individually scalable). In the `monolith` topology, `web` values configure the single `Deployment`. |
| apiServer.web | object | `{"affinity":{},"autoscaling":{"annotations":{},"behavior":{},"enabled":false,"maxReplicas":5,"minReplicas":1,"targetCPUUtilizationPercentage":70,"targetMemoryUtilizationPercentage":null},"extraEnv":[],"extraEnvFrom":[],"nodeSelector":{},"pdb":{"enabled":false,"maxUnavailable":null,"minAvailable":1},"priorityClassName":"","replicaCount":1,"resources":{"limits":{"memory":"2Gi"},"requests":{"cpu":"500m","memory":"2Gi"}},"revisionHistoryLimit":5,"terminationGracePeriodSeconds":120,"tolerations":[],"topologySpreadConstraints":[]}` | Web role (API + UI). In `monolith` topology this configures the single Deployment. |
| apiServer.web.replicaCount | int | `1` | Number of web replicas. Default 1. Bump only after switching `fileStorage.provider` to `s3` (or wiring an RWX-capable StorageClass). A multi-replica `local` PVC will not bind on cloud-default block storage. |
| apiServer.web.terminationGracePeriodSeconds | int | `120` | 120s allows in-flight BOM uploads to finish. |
| apiServer.web.topologySpreadConstraints | list | `[]` | Pod topology spread constraints. Recommended for production: - maxSkew: 1   topologyKey: kubernetes.io/hostname   whenUnsatisfiable: ScheduleAnyway   labelSelector:     matchLabels:       app.kubernetes.io/component: api-server |
| apiServer.worker | object | `{"affinity":{},"autoscaling":{"annotations":{},"behavior":{},"enabled":false,"maxReplicas":5,"minReplicas":1,"targetCPUUtilizationPercentage":70,"targetMemoryUtilizationPercentage":null},"extraEnv":[],"extraEnvFrom":[],"nodeSelector":{},"pdb":{"enabled":false,"maxUnavailable":null,"minAvailable":1},"priorityClassName":"","replicaCount":1,"resources":{"limits":{"memory":"2Gi"},"requests":{"cpu":"500m","memory":"2Gi"}},"revisionHistoryLimit":5,"terminationGracePeriodSeconds":300,"tolerations":[],"topologySpreadConstraints":[]}` | Worker role. Only rendered when `topology: split`. |
| apiServer.worker.autoscaling | object | `{"annotations":{},"behavior":{},"enabled":false,"maxReplicas":5,"minReplicas":1,"targetCPUUtilizationPercentage":70,"targetMemoryUtilizationPercentage":null}` | CPU/memory-driven HPA. For queue-backlog scaling, wire your own ScaledObject/HPA via `extraObjects` against the `dt_dex_engine_*` metrics. |
| apiServer.worker.terminationGracePeriodSeconds | int | `300` | 300s leaves room for multi-minute background tasks (BOM ingest, vuln analysis, repo meta sync) to drain. |
| database.existingSecret | object | `{"name":"","passwordKey":"password","usernameKey":"username"}` | Reference to an existing Secret. Credentials are mounted as files under `/etc/dt/secrets/db/`. |
| database.existingSecret.name | string | `""` | Name of the existing secret. |
| database.existingSecret.passwordKey | string | `"password"` | Key in the secret that's holding the password. |
| database.existingSecret.usernameKey | string | `"username"` | Key in the secret that's holding the username. |
| database.jdbcUrl | string | `"jdbc:postgresql://postgresql:5432/dtrack?reWriteBatchedInserts=true"` | JDBC URL for the PostgreSQL database. Supports templating. |
| database.password | string | `""` | Plain password. Ignored when `existingSecret.name` is set. Not recommended for production. |
| database.username | string | `""` | Plain username. Ignored when `existingSecret.name` is set. Not recommended for production. |
| enableServiceLinks | bool | `false` |  |
| extraObjects | list | `[]` | Extra manifests via values. |
| fileStorage.local.accessModes | list | `["ReadWriteOnce"]` | Access modes for the created PVC. MUST use `ReadWriteMany` in order to support multiple api-server replicas! Ignored when `existingClaim` is provided. |
| fileStorage.local.existingClaim | string | `""` | Name of an existing PVC. When set, no PVC is created by the chart. |
| fileStorage.local.mountPath | string | `"/data"` | Mount path of the PVC. Should match the api server's `dt.data.directory` config property, which defaults to `/data`. If you alter that property, you need to modify this path accordingly. |
| fileStorage.local.size | string | `"10Gi"` | Storage capacity of the created PVC. Ignored when `existingClaim` is provided. |
| fileStorage.local.storageClassName | string | `""` | Name of the `StorageClass` for the created PVC. Ignored when `existingClaim` is provided. |
| fileStorage.provider | string | `"local"` | Name of the file storage provider to use. Supported options are `local` (backed by a PVC) or `s3`. For multi-replica api-server use `s3`, or configure an RWX-capable `StorageClass` (e.g. EFS, Azure Files, CephFS) and set `accessModes: [ReadWriteMany]`. Note that most cloud-default block storage is RWO-only. |
| fileStorage.s3.bucket | string | `""` | Name of the S3 bucket. The bucket must exist, and the application verifies this on startup. A non-existing bucket will cause application startup to fail. |
| fileStorage.s3.credentials.accessKeyId | string | `""` | Plain access key ID. Ignored when `existingSecret.name` is set. Not recommended for production. |
| fileStorage.s3.credentials.existingSecret | object | `{"accessKeyIdKey":"accessKeyId","name":"","secretAccessKeyKey":"secretAccessKey"}` | Reference an existing Secret. Credentials are mounted as files under `/etc/dt/secrets/s3/`. |
| fileStorage.s3.credentials.existingSecret.accessKeyIdKey | string | `"accessKeyId"` | Key in the secret that's holding the access key ID. |
| fileStorage.s3.credentials.existingSecret.name | string | `""` | Name of the existing secret. |
| fileStorage.s3.credentials.existingSecret.secretAccessKeyKey | string | `"secretAccessKey"` | Key in the secret that's holding the secret access key. |
| fileStorage.s3.credentials.secretAccessKey | string | `""` | Plain secret access key. Ignored when `existingSecret.name` is set. Not recommended for production. |
| fileStorage.s3.endpoint | string | `""` | S3 endpoint to use. |
| fileStorage.s3.region | string | `""` | Region to use. |
| frontend.additionalVolumeMounts | list | `[]` |  |
| frontend.additionalVolumes | list | `[]` |  |
| frontend.affinity | object | `{}` |  |
| frontend.annotations | object | `{}` |  |
| frontend.apiBaseUrl | string | `""` | Base URL the UI calls for the API. Leave empty when the chart's Ingress/HTTPRoute serves UI + API from the same host (relative URLs). Set to the external API base URL when the UI is served from a different host. |
| frontend.args | list | `[]` |  |
| frontend.autoscaling.annotations | object | `{}` |  |
| frontend.autoscaling.behavior | object | `{}` |  |
| frontend.autoscaling.enabled | bool | `false` |  |
| frontend.autoscaling.maxReplicas | int | `3` |  |
| frontend.autoscaling.minReplicas | int | `1` |  |
| frontend.autoscaling.targetCPUUtilizationPercentage | int | `70` |  |
| frontend.autoscaling.targetMemoryUtilizationPercentage | string | `nil` |  |
| frontend.command | list | `[]` |  |
| frontend.deployment.strategy.type | string | `"RollingUpdate"` |  |
| frontend.enabled | bool | `true` | Whether to deploy the frontend UI. When disabled, the api-server serves the API only. |
| frontend.extraContainers | list | `[]` |  |
| frontend.extraEnv | list | `[]` |  |
| frontend.extraEnvFrom | list | `[]` |  |
| frontend.image.pullPolicy | string | `"IfNotPresent"` |  |
| frontend.image.registry | string | `""` |  |
| frontend.image.repository | string | `"dependencytrack/frontend"` |  |
| frontend.image.tag | string | `""` | Tag name or `sha256:<digest>`. Defaults to the chart's appVersion. |
| frontend.initContainers | list | `[]` |  |
| frontend.nodeSelector | object | `{}` |  |
| frontend.pdb.enabled | bool | `false` |  |
| frontend.pdb.maxUnavailable | int | `1` |  |
| frontend.pdb.minAvailable | string | `nil` |  |
| frontend.podAnnotations | object | `{}` |  |
| frontend.podLabels | object | `{}` |  |
| frontend.podSecurityContext | object | `{"fsGroup":1000}` | On OpenShift (and any cluster that assigns UIDs/GIDs via SCC or PSA), set `podSecurityContext: ~` so the namespace picks the effective fsGroup. |
| frontend.priorityClassName | string | `""` |  |
| frontend.probes.liveness.failureThreshold | int | `3` |  |
| frontend.probes.liveness.initialDelaySeconds | int | `5` |  |
| frontend.probes.liveness.periodSeconds | int | `15` |  |
| frontend.probes.liveness.successThreshold | int | `1` |  |
| frontend.probes.liveness.timeoutSeconds | int | `5` |  |
| frontend.probes.readiness.failureThreshold | int | `3` |  |
| frontend.probes.readiness.initialDelaySeconds | int | `5` |  |
| frontend.probes.readiness.periodSeconds | int | `15` |  |
| frontend.probes.readiness.successThreshold | int | `1` |  |
| frontend.probes.readiness.timeoutSeconds | int | `5` |  |
| frontend.replicaCount | int | `1` |  |
| frontend.resources.limits.memory | string | `"128Mi"` |  |
| frontend.resources.requests.cpu | string | `"150m"` |  |
| frontend.resources.requests.memory | string | `"64Mi"` |  |
| frontend.revisionHistoryLimit | int | `5` |  |
| frontend.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| frontend.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| frontend.securityContext.readOnlyRootFilesystem | bool | `false` | Whether the frontend root filesystem is read-only. Kept false because the frontend renders runtime config at startup and needs a writable rootfs. |
| frontend.securityContext.runAsNonRoot | bool | `true` |  |
| frontend.securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| frontend.service.annotations | object | `{}` |  |
| frontend.service.nodePort | string | `nil` |  |
| frontend.service.port | int | `8080` |  |
| frontend.service.type | string | `"ClusterIP"` |  |
| frontend.tolerations | list | `[]` |  |
| frontend.topologySpreadConstraints | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| httpRoute.annotations | object | `{}` |  |
| httpRoute.enabled | bool | `false` | Whether to create a Gateway API HTTPRoute. Requires `parentRefs`. |
| httpRoute.hostnames[0] | string | `"example.com"` |  |
| httpRoute.labels | object | `{}` |  |
| httpRoute.parentRefs | list | `[]` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"docker.io"` | Default container image registry. Overridable per component. |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` | Routes `/api` to api-server and `/` to frontend (or to api-server if `frontend.enabled: false`). |
| ingress.hostname | string | `"example.com"` |  |
| ingress.ingressClassName | string | `""` |  |
| ingress.labels | object | `{}` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| secretManagement.database.kek | object | `{"existingSecret":{"key":"","name":""},"mode":"config","value":""}` | The key encryption key (KEK) configuration. Required when `provider: database`. The chart does not generate the KEK. Either supply it inline via `value` (the chart creates the Secret), or reference an `existingSecret`. |
| secretManagement.database.kek.existingSecret.key | string | `""` | Key of the KEK in the existing secret. Defaults to `kek` in config mode and `kek-keyset.json` in keyset mode. Override only if your Secret backend uses a different key name. |
| secretManagement.database.kek.existingSecret.name | string | `""` | Name of the existing secret. |
| secretManagement.database.kek.mode | string | `"config"` | Mode in which the KEK is provided.  `mode: config` (default): a base64-encoded 32-byte AES key. Easy to provision (`openssl rand -base64 32`) but does NOT support in-place KEK rotation.  `mode: keyset`: a Tink AES-GCM JSON keyset. Supports DT's rotation flow, and is required for long-running production deployments that expect to rotate the KEK without re-encrypting every DB-stored secret. |
| secretManagement.database.kek.value | string | `""` | Inline KEK value. When set, the chart creates the KEK Secret for you. Mutually exclusive with `existingSecret.name`. For `mode: config` generate one with `openssl rand -base64 32`. For `mode: keyset` paste the Tink AES-GCM JSON keyset. NOTE: this is stored in plaintext in etcd. For stronger isolation, leave this empty and use `existingSecret` with external secret tooling. |
| secretManagement.provider | string | `"database"` | Name of the secret management provider to use. Supported options are `database` (encrypted in Postgres, KEK on disk) and `env` (read-only lookup against DT_SECRET_* env vars).  With `provider: env` the chart wires nothing beyond `DT_SECRET_MANAGEMENT_PROVIDER`. Supply each secret yourself as a `DT_SECRET_*` variable via `apiServer.extraEnv` (or `extraEnvFrom`), e.g. from an externally-managed Secret. |
| serviceAccount.annotations | object | `{}` | Annotations to attach to the created service account. |
| serviceAccount.create | bool | `true` | Whether to create a service account. |
| serviceAccount.name | string | `""` | Name of the service account. Defaults to the release fullname when empty. Provide a custom name and set `create: false` to use a custom service account. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

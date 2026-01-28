# hyades

![Version: 0.10.0](https://img.shields.io/badge/Version-0.10.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.6.0-SNAPSHOT](https://img.shields.io/badge/AppVersion-0.6.0--SNAPSHOT-informational?style=flat-square)

Hyades is an incubating project for decoupling responsibilities from Dependency-Track's
monolithic API server into separate, scalable services. It will eventually become
Dependency-Track version 5. HYADES IS NOT CONSIDERED GENERALLY AVAILABLE YET,
and breaking changes may be introduced without prior notice. Use this chart
locally or in test environments, but don't rely on it in production yet.
The GA roadmap for Hyades is tracked here: https://github.com/DependencyTrack/hyades/issues/860

**Homepage:** <https://github.com/DependencyTrack/hyades>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| nscuro | <nscuro@protonmail.com> | <https://github.com/nscuro> |
| mehab | <meha.bhargava@citi.com> | <https://github.com/mehab> |
| sahibamittal | <sahiba.mittal@citi.com> | <https://github.com/sahibamittal> |
| VithikaS | <vithika.shukla@citi.com> | <https://github.com/VithikaS> |

## Source Code

* <https://github.com/DependencyTrack/helm-charts/tree/main/charts/hyades>
* <https://github.com/DependencyTrack/hyades>
* <https://github.com/DependencyTrack/hyades-apiserver>
* <https://github.com/DependencyTrack/hyades-frontend>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiServer.additionalVolumeMounts | list | `[]` |  |
| apiServer.additionalVolumes | list | `[]` |  |
| apiServer.annotations | object | `{}` |  |
| apiServer.args | list | `[]` |  |
| apiServer.autoScaling | object | `{"annotations":{},"enabled":false,"maxReplicas":3,"minReplicas":1,"targetCPUUtilizationPercentage":70,"targetMemoryUtilizationPercentage":70}` | Enables horizontal pod autoscaling |
| apiServer.command | list | `[]` |  |
| apiServer.deployment.strategy | object | `{"type":"RollingUpdate"}` | The deployment strategy to use. |
| apiServer.enabled | bool | `true` | Whether the API server shall be deployed. |
| apiServer.extraContainers | list | `[]` | Additional containers to deploy. Supports templating. |
| apiServer.extraEnv | list | `[]` |  |
| apiServer.extraEnvFrom | list | `[]` |  |
| apiServer.image.pullPolicy | string | `"Always"` |  |
| apiServer.image.registry | string | `""` | Override common.image.registry for the API server. |
| apiServer.image.repository | string | `"dependencytrack/hyades-apiserver"` |  |
| apiServer.image.tag | string | `"snapshot"` | Can be a tag name such as "latest", or an image digest prefixed with "sha256:". |
| apiServer.initContainers | list | `[]` | Additional init containers to deploy. Supports templating. |
| apiServer.nodeSelector | object | `{}` |  |
| apiServer.probes.liveness.failureThreshold | int | `3` |  |
| apiServer.probes.liveness.initialDelaySeconds | int | `10` |  |
| apiServer.probes.liveness.periodSeconds | int | `15` |  |
| apiServer.probes.liveness.successThreshold | int | `1` |  |
| apiServer.probes.liveness.timeoutSeconds | int | `5` |  |
| apiServer.probes.readiness.failureThreshold | int | `3` |  |
| apiServer.probes.readiness.initialDelaySeconds | int | `10` |  |
| apiServer.probes.readiness.periodSeconds | int | `15` |  |
| apiServer.probes.readiness.successThreshold | int | `1` |  |
| apiServer.probes.readiness.timeoutSeconds | int | `5` |  |
| apiServer.replicaCount | int | `1` | replicaCount is not used when autoscaling is enabled |
| apiServer.resources.limits.cpu | string | `"4"` |  |
| apiServer.resources.limits.memory | string | `"2Gi"` |  |
| apiServer.resources.requests.cpu | string | `"2"` |  |
| apiServer.resources.requests.memory | string | `"2Gi"` |  |
| apiServer.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context of the Container. |
| apiServer.service.annotations | object | `{}` |  |
| apiServer.service.nodePort | string | `nil` |  |
| apiServer.service.port | int | `8080` |  |
| apiServer.service.type | string | `"ClusterIP"` |  |
| apiServer.serviceMonitor.enabled | bool | `false` |  |
| apiServer.serviceMonitor.namespace | string | `"monitoring"` |  |
| apiServer.serviceMonitor.scrapeInternal | string | `"15s"` |  |
| apiServer.serviceMonitor.scrapeTimeout | string | `"30s"` |  |
| apiServer.terminationGracePeriodSeconds | int | `60` | Grace period for pod termination in seconds. Should always be equal to or greater than the sum of `_DRAIN_TIMEOUT` configurations to ensure graceful shutdown. Refer to https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/ for details. |
| apiServer.tolerations | list | `[]` |  |
| common.database.jdbcUrl | string | `""` |  |
| common.database.password | string | `""` |  |
| common.database.username | string | `""` |  |
| common.fullnameOverride | string | `""` |  |
| common.image.pullSecrets | list | `[]` |  |
| common.image.registry | string | `"ghcr.io"` |  |
| common.kafka.bootstrapServers | string | `""` |  |
| common.kafka.topicPrefix | string | `""` |  |
| common.nameOverride | string | `""` |  |
| common.secretKey.createSecret | bool | `false` | Whether the chart should generate a secret key upon deployment. |
| common.secretKey.existingSecretName | string | `""` | Use the secret key defined in an existing secret. |
| common.serviceAccount.annotations | object | `{}` |  |
| common.serviceAccount.automount | bool | `false` | Whether the serviceAccount should mount the token. |
| common.serviceAccount.create | bool | `true` |  |
| common.serviceAccount.name | string | `""` | Use the name of the name of the release by default, or specify a custom name. |
| extraObjects | list | `[]` |  |
| frontend.additionalVolumeMounts | list | `[]` |  |
| frontend.additionalVolumes | list | `[]` |  |
| frontend.annotations | object | `{}` |  |
| frontend.apiBaseUrl | string | `""` |  |
| frontend.args | list | `[]` |  |
| frontend.autoScaling | object | `{"annotations":{},"enabled":false,"maxReplicas":3,"minReplicas":1,"targetCPUUtilizationPercentage":70,"targetMemoryUtilizationPercentage":70}` | Enables horizontal pod autoscaling |
| frontend.command | list | `[]` |  |
| frontend.deployment.strategy | object | `{"type":"RollingUpdate"}` | The deployment strategy to use. |
| frontend.enabled | bool | `true` | Whether the frontend shall be deployed. |
| frontend.extraContainers | list | `[]` | Additional containers to deploy. Supports templating. |
| frontend.extraEnv | list | `[]` |  |
| frontend.extraEnvFrom | list | `[]` |  |
| frontend.image.pullPolicy | string | `"Always"` |  |
| frontend.image.registry | string | `""` | Override common.image.registry for the API frontend. |
| frontend.image.repository | string | `"dependencytrack/hyades-frontend"` |  |
| frontend.image.tag | string | `"snapshot"` | Can be a tag name such as "latest", or an image digest prefixed with "sha256:". |
| frontend.initContainers | list | `[]` | Additional init containers to deploy. Supports templating. |
| frontend.nodeSelector | object | `{}` |  |
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
| frontend.replicaCount | int | `1` | replicaCount is not used when autoscaling is enabled |
| frontend.resources.limits.cpu | string | `"500m"` |  |
| frontend.resources.limits.memory | string | `"128Mi"` |  |
| frontend.resources.requests.cpu | string | `"150m"` |  |
| frontend.resources.requests.memory | string | `"64Mi"` |  |
| frontend.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":false,"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context of the Container. |
| frontend.service.annotations | object | `{}` |  |
| frontend.service.nodePort | string | `nil` |  |
| frontend.service.port | int | `8080` |  |
| frontend.service.type | string | `"ClusterIP"` |  |
| frontend.tolerations | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hostname | string | `"example.com"` |  |
| ingress.ingressClassName | string | `""` |  |
| ingress.tls | list | `[]` |  |
| initializer.annotations | object | `{}` |  |
| initializer.args | list | `[]` |  |
| initializer.command | list | `[]` |  |
| initializer.enabled | bool | `false` | Whether to enable the initializer Job. When enabled, an init container will be added to all deployments that require database access. The init container will wait for the initializer Job to complete. Requires the service account token to be mounted. |
| initializer.extraEnv | list | `[]` |  |
| initializer.extraEnvFrom | list | `[]` |  |
| initializer.image.pullPolicy | string | `"Always"` |  |
| initializer.image.registry | string | `""` | Override common.image.registry for the API server. |
| initializer.image.repository | string | `"dependencytrack/hyades-apiserver"` |  |
| initializer.image.tag | string | `"snapshot"` | Can be a tag name such as "latest", or an image digest prefixed with "sha256:". |
| initializer.noHelmHook | bool | `false` | Whether to NOT deploy the initializer Job as `post-install` and `post-upgrade` Helm hook. Deploying as Helm hook can create deadlock situations when `helm install` and `helm upgrade` are executed with `--wait` flag. See <https://github.com/helm/helm/issues/10555>. Note that without hooks, `helm upgrade` may fail due to Job fields being immutable. |
| initializer.nodeSelector | object | `{}` |  |
| initializer.resources.limits.cpu | string | `"500m"` |  |
| initializer.resources.limits.memory | string | `"256Mi"` |  |
| initializer.resources.requests.cpu | string | `"150m"` |  |
| initializer.resources.requests.memory | string | `"256Mi"` |  |
| initializer.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context of the Container. |
| initializer.tolerations | list | `[]` |  |
| initializer.waiter.createRole | bool | `true` | Whether to create a Role with permissions to wait for Job completion, and bind it to the ServiceAccount. |
| initializer.waiter.image.pullPolicy | string | `"Always"` |  |
| initializer.waiter.image.registry | string | `"docker.io"` |  |
| initializer.waiter.image.repository | string | `"bitnami/kubectl"` |  |
| initializer.waiter.image.tag | string | `"latest"` |  |
| repoMetaAnalyzer.additionalVolumeMounts | list | `[]` |  |
| repoMetaAnalyzer.additionalVolumes | list | `[]` |  |
| repoMetaAnalyzer.annotations | object | `{}` |  |
| repoMetaAnalyzer.args | list | `[]` |  |
| repoMetaAnalyzer.autoScaling | object | `{"annotations":{},"enabled":false,"maxReplicas":3,"minReplicas":1,"targetCPUUtilizationPercentage":70,"targetMemoryUtilizationPercentage":70}` | Enables horizontal pod autoscaling |
| repoMetaAnalyzer.command | list | `[]` |  |
| repoMetaAnalyzer.deployment.strategy | object | `{"type":"Recreate"}` | The deployment strategy to use. `Recreate` is recommended because the service does not serve user-traffic, and `RollingUpdate` will cause undesired Kafka consumer rebalances. |
| repoMetaAnalyzer.enabled | bool | `true` | Whether the repository metadata analyzer shall be deployed. |
| repoMetaAnalyzer.extraContainers | list | `[]` | Additional containers to deploy. Supports templating. |
| repoMetaAnalyzer.extraEnv | list | `[]` |  |
| repoMetaAnalyzer.extraEnvFrom | list | `[]` |  |
| repoMetaAnalyzer.image.pullPolicy | string | `"Always"` |  |
| repoMetaAnalyzer.image.registry | string | `""` | Override common.image.registry for the repository metadata analyzer. |
| repoMetaAnalyzer.image.repository | string | `"dependencytrack/hyades-repository-meta-analyzer"` |  |
| repoMetaAnalyzer.image.tag | string | `"snapshot-native"` | Can be a tag name such as "latest", or an image digest prefixed with "sha256:". |
| repoMetaAnalyzer.initContainers | list | `[]` | Additional init containers to deploy. Supports templating. |
| repoMetaAnalyzer.nodeSelector | object | `{}` |  |
| repoMetaAnalyzer.probes.liveness.failureThreshold | int | `3` |  |
| repoMetaAnalyzer.probes.liveness.initialDelaySeconds | int | `10` |  |
| repoMetaAnalyzer.probes.liveness.periodSeconds | int | `15` |  |
| repoMetaAnalyzer.probes.liveness.successThreshold | int | `1` |  |
| repoMetaAnalyzer.probes.liveness.timeoutSeconds | int | `5` |  |
| repoMetaAnalyzer.probes.readiness.failureThreshold | int | `3` |  |
| repoMetaAnalyzer.probes.readiness.initialDelaySeconds | int | `10` |  |
| repoMetaAnalyzer.probes.readiness.periodSeconds | int | `15` |  |
| repoMetaAnalyzer.probes.readiness.successThreshold | int | `1` |  |
| repoMetaAnalyzer.probes.readiness.timeoutSeconds | int | `5` |  |
| repoMetaAnalyzer.replicaCount | int | `1` | replicaCount is not used when autoscaling is enabled |
| repoMetaAnalyzer.resources.limits.cpu | string | `"2"` |  |
| repoMetaAnalyzer.resources.limits.memory | string | `"2Gi"` |  |
| repoMetaAnalyzer.resources.requests.cpu | string | `"500m"` |  |
| repoMetaAnalyzer.resources.requests.memory | string | `"512Mi"` |  |
| repoMetaAnalyzer.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context of the container. |
| repoMetaAnalyzer.tolerations | list | `[]` |  |
| vulnAnalyzer.additionalVolumeMounts | list | `[]` |  |
| vulnAnalyzer.additionalVolumes | list | `[]` |  |
| vulnAnalyzer.annotations | object | `{}` |  |
| vulnAnalyzer.args | list | `[]` |  |
| vulnAnalyzer.autoScaling | object | `{"annotations":{},"enabled":false,"maxReplicas":3,"minReplicas":1,"targetCPUUtilizationPercentage":70,"targetMemoryUtilizationPercentage":70}` | Enables horizontal pod autoscaling |
| vulnAnalyzer.command | list | `[]` |  |
| vulnAnalyzer.deployment.strategy | object | `{"type":"Recreate"}` | The deployment strategy to use. `Recreate` is recommended because the service does not serve user-traffic, and `RollingUpdate` will cause undesired Kafka consumer rebalances. |
| vulnAnalyzer.enabled | bool | `true` | Whether the vulnerability analyzer shall be deployed. |
| vulnAnalyzer.extraContainers | list | `[]` | Additional containers to deploy. Supports templating. |
| vulnAnalyzer.extraEnv | list | `[]` |  |
| vulnAnalyzer.extraEnvFrom | list | `[]` |  |
| vulnAnalyzer.image.pullPolicy | string | `"Always"` |  |
| vulnAnalyzer.image.registry | string | `""` | Override common.image.registry for the vulnerability analyzer. |
| vulnAnalyzer.image.repository | string | `"dependencytrack/hyades-vulnerability-analyzer"` |  |
| vulnAnalyzer.image.tag | string | `"snapshot-native"` | Can be a tag name such as "latest", or an image digest prefixed with "sha256:". |
| vulnAnalyzer.initContainers | list | `[]` | Additional init containers to deploy. Supports templating. |
| vulnAnalyzer.nodeSelector | object | `{}` |  |
| vulnAnalyzer.persistentVolume.className | string | `""` |  |
| vulnAnalyzer.persistentVolume.enabled | bool | `false` | Whether to use a persistent volume to store application state. Has no effect unless useStatefulSet is true. Is pointless unless the STATE_STORE_TYPE environment variable is set to "rocks_db", since state is kept in memory per default. A volume will be created for each Pod, via volumeClaimTemplates, since state must not be shared between multiple replicas. |
| vulnAnalyzer.persistentVolume.size | string | `"2Gi"` |  |
| vulnAnalyzer.probes.liveness.failureThreshold | int | `3` |  |
| vulnAnalyzer.probes.liveness.initialDelaySeconds | int | `10` |  |
| vulnAnalyzer.probes.liveness.periodSeconds | int | `15` |  |
| vulnAnalyzer.probes.liveness.successThreshold | int | `1` |  |
| vulnAnalyzer.probes.liveness.timeoutSeconds | int | `5` |  |
| vulnAnalyzer.probes.readiness.failureThreshold | int | `3` |  |
| vulnAnalyzer.probes.readiness.initialDelaySeconds | int | `10` |  |
| vulnAnalyzer.probes.readiness.periodSeconds | int | `15` |  |
| vulnAnalyzer.probes.readiness.successThreshold | int | `1` |  |
| vulnAnalyzer.probes.readiness.timeoutSeconds | int | `5` |  |
| vulnAnalyzer.replicaCount | int | `1` | replicaCount is not used when autoscaling is enabled |
| vulnAnalyzer.resources.limits.cpu | string | `"2"` |  |
| vulnAnalyzer.resources.limits.memory | string | `"2Gi"` |  |
| vulnAnalyzer.resources.requests.cpu | string | `"500m"` |  |
| vulnAnalyzer.resources.requests.memory | string | `"512Mi"` |  |
| vulnAnalyzer.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context of the container. |
| vulnAnalyzer.service.annotations | object | `{}` |  |
| vulnAnalyzer.tolerations | list | `[]` |  |
| vulnAnalyzer.useStatefulSet | bool | `false` | Whether to deploy the vulnerability analyzer as StatefulSet. Should be enabled when the STATE_STORE_TYPE environment variable is set to "rocks_db", to allow for reliable storage of application state to disk. Should be used in combination with persistentVolume.enabled. |


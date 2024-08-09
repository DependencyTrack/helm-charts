# hyades

![Version: 0.5.0](https://img.shields.io/badge/Version-0.5.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0-SNAPSHOT](https://img.shields.io/badge/AppVersion-1.0.0--SNAPSHOT-informational?style=flat-square)

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
| apiServer.command | list | `[]` |  |
| apiServer.enabled | bool | `true` | Whether the API server shall be deployed. |
| apiServer.extraContainers | list | `[]` |  |
| apiServer.extraEnv | list | `[]` |  |
| apiServer.extraEnvFrom | list | `[]` |  |
| apiServer.image.pullPolicy | string | `"Always"` |  |
| apiServer.image.registry | string | `""` | Override common.image.registry for the API server. |
| apiServer.image.repository | string | `"dependencytrack/hyades-apiserver"` |  |
| apiServer.image.tag | string | `"snapshot"` |  |
| apiServer.initContainers | list | `[]` |  |
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
| apiServer.replicaCount | int | `1` |  |
| apiServer.resources.limits.cpu | string | `"4"` |  |
| apiServer.resources.limits.memory | string | `"2Gi"` |  |
| apiServer.resources.requests.cpu | string | `"2"` |  |
| apiServer.resources.requests.memory | string | `"2Gi"` |  |
| apiServer.service.annotations | object | `{}` |  |
| apiServer.service.nodePort | string | `nil` |  |
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
| frontend.command | list | `[]` |  |
| frontend.enabled | bool | `true` | Whether the frontend shall be deployed. |
| frontend.extraContainers | list | `[]` |  |
| frontend.extraEnv | list | `[]` |  |
| frontend.extraEnvFrom | list | `[]` |  |
| frontend.image.pullPolicy | string | `"Always"` |  |
| frontend.image.registry | string | `""` | Override common.image.registry for the API frontend. |
| frontend.image.repository | string | `"dependencytrack/hyades-frontend"` |  |
| frontend.image.tag | string | `"snapshot"` |  |
| frontend.initContainers | list | `[]` |  |
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
| frontend.replicaCount | int | `1` |  |
| frontend.resources.limits.cpu | string | `"500m"` |  |
| frontend.resources.limits.memory | string | `"128Mi"` |  |
| frontend.resources.requests.cpu | string | `"150m"` |  |
| frontend.resources.requests.memory | string | `"64Mi"` |  |
| frontend.service.annotations | object | `{}` |  |
| frontend.service.nodePort | string | `nil` |  |
| frontend.service.type | string | `"ClusterIP"` |  |
| frontend.tolerations | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hostname | string | `"example.com"` |  |
| ingress.ingressClassName | string | `""` |  |
| ingress.tls | list | `[]` |  |
| mirrorService.additionalVolumeMounts | list | `[]` |  |
| mirrorService.additionalVolumes | list | `[]` |  |
| mirrorService.annotations | object | `{}` |  |
| mirrorService.args | list | `[]` |  |
| mirrorService.command | list | `[]` |  |
| mirrorService.enabled | bool | `true` | Whether the mirror service shall be deployed. |
| mirrorService.extraContainers | list | `[]` |  |
| mirrorService.extraEnv | list | `[]` |  |
| mirrorService.extraEnvFrom | list | `[]` |  |
| mirrorService.image.pullPolicy | string | `"Always"` |  |
| mirrorService.image.registry | string | `""` | Override common.image.registry for the mirror service. |
| mirrorService.image.repository | string | `"dependencytrack/hyades-mirror-service"` |  |
| mirrorService.image.tag | string | `"snapshot-native"` |  |
| mirrorService.initContainers | list | `[]` |  |
| mirrorService.nodeSelector | object | `{}` |  |
| mirrorService.probes.liveness.failureThreshold | int | `3` |  |
| mirrorService.probes.liveness.initialDelaySeconds | int | `10` |  |
| mirrorService.probes.liveness.periodSeconds | int | `15` |  |
| mirrorService.probes.liveness.successThreshold | int | `1` |  |
| mirrorService.probes.liveness.timeoutSeconds | int | `5` |  |
| mirrorService.probes.readiness.failureThreshold | int | `3` |  |
| mirrorService.probes.readiness.initialDelaySeconds | int | `10` |  |
| mirrorService.probes.readiness.periodSeconds | int | `15` |  |
| mirrorService.probes.readiness.successThreshold | int | `1` |  |
| mirrorService.probes.readiness.timeoutSeconds | int | `5` |  |
| mirrorService.replicaCount | int | `1` | Number of replicas. Should be <= 1. |
| mirrorService.resources.limits.cpu | string | `"2"` |  |
| mirrorService.resources.limits.memory | string | `"2Gi"` |  |
| mirrorService.resources.requests.cpu | string | `"500m"` |  |
| mirrorService.resources.requests.memory | string | `"512Mi"` |  |
| mirrorService.tolerations | list | `[]` |  |
| notificationPublisher.additionalVolumeMounts | list | `[]` |  |
| notificationPublisher.additionalVolumes | list | `[]` |  |
| notificationPublisher.annotations | object | `{}` |  |
| notificationPublisher.args | list | `[]` |  |
| notificationPublisher.command | list | `[]` |  |
| notificationPublisher.enabled | bool | `true` | Whether the notification publisher shall be deployed. |
| notificationPublisher.extraContainers | list | `[]` |  |
| notificationPublisher.extraEnv | list | `[]` |  |
| notificationPublisher.extraEnvFrom | list | `[]` |  |
| notificationPublisher.image.pullPolicy | string | `"Always"` |  |
| notificationPublisher.image.registry | string | `""` | Override common.image.registry for the notification publisher. |
| notificationPublisher.image.repository | string | `"dependencytrack/hyades-notification-publisher"` |  |
| notificationPublisher.image.tag | string | `"snapshot-native"` |  |
| notificationPublisher.initContainers | list | `[]` |  |
| notificationPublisher.nodeSelector | object | `{}` |  |
| notificationPublisher.probes.liveness.failureThreshold | int | `3` |  |
| notificationPublisher.probes.liveness.initialDelaySeconds | int | `10` |  |
| notificationPublisher.probes.liveness.periodSeconds | int | `15` |  |
| notificationPublisher.probes.liveness.successThreshold | int | `1` |  |
| notificationPublisher.probes.liveness.timeoutSeconds | int | `5` |  |
| notificationPublisher.probes.readiness.failureThreshold | int | `3` |  |
| notificationPublisher.probes.readiness.initialDelaySeconds | int | `10` |  |
| notificationPublisher.probes.readiness.periodSeconds | int | `15` |  |
| notificationPublisher.probes.readiness.successThreshold | int | `1` |  |
| notificationPublisher.probes.readiness.timeoutSeconds | int | `5` |  |
| notificationPublisher.replicaCount | int | `1` |  |
| notificationPublisher.resources.limits.cpu | string | `"2"` |  |
| notificationPublisher.resources.limits.memory | string | `"2Gi"` |  |
| notificationPublisher.resources.requests.cpu | string | `"500m"` |  |
| notificationPublisher.resources.requests.memory | string | `"512Mi"` |  |
| notificationPublisher.tolerations | list | `[]` |  |
| repoMetaAnalyzer.additionalVolumeMounts | list | `[]` |  |
| repoMetaAnalyzer.additionalVolumes | list | `[]` |  |
| repoMetaAnalyzer.annotations | object | `{}` |  |
| repoMetaAnalyzer.args | list | `[]` |  |
| repoMetaAnalyzer.command | list | `[]` |  |
| repoMetaAnalyzer.enabled | bool | `true` | Whether the repository metadata analyzer shall be deployed. |
| repoMetaAnalyzer.extraContainers | list | `[]` |  |
| repoMetaAnalyzer.extraEnv | list | `[]` |  |
| repoMetaAnalyzer.extraEnvFrom | list | `[]` |  |
| repoMetaAnalyzer.image.pullPolicy | string | `"Always"` |  |
| repoMetaAnalyzer.image.registry | string | `""` | Override common.image.registry for the repository metadata analyzer. |
| repoMetaAnalyzer.image.repository | string | `"dependencytrack/hyades-repository-meta-analyzer"` |  |
| repoMetaAnalyzer.image.tag | string | `"snapshot-native"` |  |
| repoMetaAnalyzer.initContainers | list | `[]` |  |
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
| repoMetaAnalyzer.replicaCount | int | `1` |  |
| repoMetaAnalyzer.resources.limits.cpu | string | `"2"` |  |
| repoMetaAnalyzer.resources.limits.memory | string | `"2Gi"` |  |
| repoMetaAnalyzer.resources.requests.cpu | string | `"500m"` |  |
| repoMetaAnalyzer.resources.requests.memory | string | `"512Mi"` |  |
| repoMetaAnalyzer.tolerations | list | `[]` |  |
| vulnAnalyzer.additionalVolumeMounts | list | `[]` |  |
| vulnAnalyzer.additionalVolumes | list | `[]` |  |
| vulnAnalyzer.annotations | object | `{}` |  |
| vulnAnalyzer.args | list | `[]` |  |
| vulnAnalyzer.command | list | `[]` |  |
| vulnAnalyzer.enabled | bool | `true` | Whether the vulnerability analyzer shall be deployed. |
| vulnAnalyzer.extraContainers | list | `[]` |  |
| vulnAnalyzer.extraEnv | list | `[]` |  |
| vulnAnalyzer.extraEnvFrom | list | `[]` |  |
| vulnAnalyzer.image.pullPolicy | string | `"Always"` |  |
| vulnAnalyzer.image.registry | string | `""` | Override common.image.registry for the vulnerability analyzer. |
| vulnAnalyzer.image.repository | string | `"dependencytrack/hyades-vulnerability-analyzer"` |  |
| vulnAnalyzer.image.tag | string | `"snapshot-native"` |  |
| vulnAnalyzer.initContainers | list | `[]` |  |
| vulnAnalyzer.nodeSelector | object | `{}` |  |
| vulnAnalyzer.persistentVolume.className | string | `""` |  |
| vulnAnalyzer.persistentVolume.enabled | bool | `false` |  |
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
| vulnAnalyzer.replicaCount | int | `1` |  |
| vulnAnalyzer.resources.limits.cpu | string | `"2"` |  |
| vulnAnalyzer.resources.limits.memory | string | `"2Gi"` |  |
| vulnAnalyzer.resources.requests.cpu | string | `"500m"` |  |
| vulnAnalyzer.resources.requests.memory | string | `"512Mi"` |  |
| vulnAnalyzer.service.annotations | object | `{}` |  |
| vulnAnalyzer.tolerations | list | `[]` |  |


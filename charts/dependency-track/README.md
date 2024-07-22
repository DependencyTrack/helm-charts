# dependency-track

![Version: 0.12.0](https://img.shields.io/badge/Version-0.12.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 4.11.5](https://img.shields.io/badge/AppVersion-4.11.5-informational?style=flat-square)

Dependency-Track is an intelligent Component Analysis platform
that allows organizations to identify and reduce risk in the software supply chain.

**Homepage:** <https://github.com/DependencyTrack/dependency-track>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| nscuro | <nscuro@protonmail.com> | <https://github.com/nscuro> |

## Source Code

* <https://github.com/DependencyTrack/helm-charts/tree/main/charts/dependency-track>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiServer.additionalVolumeMounts | list | `[]` |  |
| apiServer.additionalVolumes | list | `[]` |  |
| apiServer.annotations | object | `{}` |  |
| apiServer.args | list | `[]` |  |
| apiServer.command | list | `[]` |  |
| apiServer.extraContainers | list | `[]` |  |
| apiServer.extraEnv | list | `[]` |  |
| apiServer.extraEnvFrom | list | `[]` |  |
| apiServer.image.pullPolicy | string | `"IfNotPresent"` |  |
| apiServer.image.registry | string | `""` | Override common.image.registry for the API server. |
| apiServer.image.repository | string | `"dependencytrack/apiserver"` |  |
| apiServer.image.tag | string | `nil` |  |
| apiServer.initContainers | list | `[]` |  |
| apiServer.nodeSelector | object | `{}` |  |
| apiServer.persistentVolume.className | string | `""` |  |
| apiServer.persistentVolume.enabled | bool | `false` |  |
| apiServer.persistentVolume.size | string | `"5Gi"` |  |
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
| apiServer.resources.limits.cpu | string | `"4"` |  |
| apiServer.resources.limits.memory | string | `"5Gi"` |  |
| apiServer.resources.requests.cpu | string | `"2"` |  |
| apiServer.resources.requests.memory | string | `"5Gi"` |  |
| apiServer.service.annotations | object | `{}` |  |
| apiServer.service.nodePort | string | `nil` |  |
| apiServer.service.type | string | `"ClusterIP"` |  |
| apiServer.serviceMonitor.enabled | bool | `false` |  |
| apiServer.serviceMonitor.namespace | string | `"monitoring"` |  |
| apiServer.serviceMonitor.scrapeInternal | string | `"15s"` |  |
| apiServer.serviceMonitor.scrapeTimeout | string | `"30s"` |  |
| apiServer.tolerations | list | `[]` |  |
| common.fullnameOverride | string | `""` |  |
| common.image.pullSecrets | list | `[]` |  |
| common.image.registry | string | `"docker.io"` |  |
| common.nameOverride | string | `""` |  |
| common.secretKey.createSecret | bool | `false` | Whether the chart should generate a secret key upon deployment. |
| common.secretKey.existingSecretName | string | `""` | Use the secret key defined in an existing secret. |
| common.serviceAccount.annotations | object | `{}` |  |
| common.serviceAccount.automount | bool | `false` | Whether the serviceAccount should mount the token. |
| common.serviceAccount.create | bool | `true` | Whether the chart should generate a serviceAccount |
| common.serviceAccount.name | string | `""` | Use the name of the name of the release by default, or specify a custom name. |
| extraObjects | list | `[]` | Create extra manifests via values. |
| frontend.additionalVolumeMounts | list | `[]` |  |
| frontend.additionalVolumes | list | `[]` |  |
| frontend.annotations | object | `{}` |  |
| frontend.apiBaseUrl | string | `""` |  |
| frontend.args | list | `[]` |  |
| frontend.command | list | `[]` |  |
| frontend.extraContainers | list | `[]` |  |
| frontend.extraEnv | list | `[]` |  |
| frontend.extraEnvFrom | list | `[]` |  |
| frontend.image.pullPolicy | string | `"IfNotPresent"` |  |
| frontend.image.registry | string | `""` | Override common.image.registry for the frontend. |
| frontend.image.repository | string | `"dependencytrack/frontend"` |  |
| frontend.image.tag | string | `nil` |  |
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


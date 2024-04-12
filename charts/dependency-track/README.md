# dependency-track

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 4.10.1](https://img.shields.io/badge/AppVersion-4.10.1-informational?style=flat-square)

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

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | common | ^2.19.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiServer.annotations | object | `{}` |  |
| apiServer.args | list | `[]` |  |
| apiServer.command | list | `[]` |  |
| apiServer.extraContainers | list | `[]` |  |
| apiServer.extraEnv | object | `{}` |  |
| apiServer.extraEnvFrom | list | `[]` |  |
| apiServer.image.pullPolicy | string | `"IfNotPresent"` |  |
| apiServer.image.repository | string | `"dependencytrack/apiserver"` |  |
| apiServer.image.tag | string | `nil` |  |
| apiServer.initContainers | list | `[]` |  |
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
| frontend.annotations | object | `{}` |  |
| frontend.apiBaseUrl | string | `""` |  |
| frontend.args | list | `[]` |  |
| frontend.command | list | `[]` |  |
| frontend.extraContainers | list | `[]` |  |
| frontend.extraEnv | object | `{}` |  |
| frontend.extraEnvFrom | list | `[]` |  |
| frontend.image.pullPolicy | string | `"IfNotPresent"` |  |
| frontend.image.repository | string | `"dependencytrack/frontend"` |  |
| frontend.image.tag | string | `"4.10.0"` |  |
| frontend.initContainers | list | `[]` |  |
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
| ingress.annotations | object | `{}` | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. For a full list of possible ingress annotations. Use this parameter to set the required annotations for cert-manager, see ref: https://cert-manager.io/docs/usage/ingress/#supported-annotations |
| ingress.apiVersion | string | `""` | Force Ingress API version (automatically detected if not set) |
| ingress.enabled | bool | `false` | Set to true to enable ingress record generation |
| ingress.extraHosts | list | `[]` | The list of additional hostnames to be covered with this ingress record. Most likely the hostname above will be enough, but in the event more hosts are needed, this is an array |
| ingress.extraPaths | list | `[]` | Any additional arbitrary paths that may need to be added to the ingress under the main host. For example: The ALB ingress controller requires a special rule for handling SSL redirection. |
| ingress.extraRules | list | `[]` | The list of additional rules to be added to this ingress record. Evaluated as a template. Useful when looking for additional customization, such as using different backend |
| ingress.extraTls | list | `[]` | The tls configuration for additional hostnames to be covered with this ingress record. see: https://kubernetes.io/docs/concepts/services-networking/ingress/#tls |
| ingress.hostname | string | `"dependency-track.local.gd"` | Default host for the ingress resource |
| ingress.ingressClassName | string | `""` | Set the ingerssClassName on the ingress record for k8s 1.18+ This is supported in **Kubernetes 1.18+** and required if you have more than one `IngressClass` marked as the `default` for your cluster. ref: https://kubernetes.io/blog/2020/04/02/improvements-to-the-ingress-api-in-kubernetes-1.18/ |
| ingress.path | string | `"/"` | The URL Path to **dependency-track**. You may need to set this to `/*` in order to use this with ALB ingress controllers. |
| ingress.pathType | string | `"ImplementationSpecific"` | Ingress path type |
| ingress.secrets | list | `[]` | If you're providing your own certificates, please use this to add the certificates as secrets key and certificate should start with `-----BEGIN CERTIFICATE-----` or `-----BEGIN RSA PRIVATE KEY-----` and name should line up with a `tlsSecret` set further up. If you're using **cert-manager**, this is unneeded, as it will create the **secret** for you if it is not set. It is also possible to create and manage the certificates outside of this helm chart. |
| ingress.selfSigned | bool | `false` | Create a TLS secret for this ingress record using self-signed certificates generated by Helm |
| ingress.tls | bool | `false` | Create TLS Secret TLS certificates will be retrieved from a TLS secret with name: `{{- printf "%s-tls" .Values.ingress.hostname }}` You can use the `ingress.secrets` parameter to create this TLS secret or relay on cert-manager to create it |
| ingress.tlsWwwPrefix | bool | `false` | Adds **www** subdomain to default certificate Creates tls host with ingress.hostname: `{{ print "www.%s" .Values.ingress.hostname }}` Is enabled if "`nginx.ingress.kubernetes.io/from-to-www-redirect`" is "`true`" |
| tls.autoGenerated | bool | `true` | Auto-generate self-signed certificates |
| tls.ca | string | `""` | Content of the certificate CA to be added to the secret |
| tls.cert | string | `""` | Content of the certificate to be added to the secret |
| tls.certCAFilename | string | `"ca.crt"` | Path of the certificate CA file when mounted as a secret |
| tls.certFilename | string | `"tls.crt"` | Path of the certificate file when mounted as a secret |
| tls.certKeyFilename | string | `"tls.key"` | Path of the certificate key file when mounted as a secret |
| tls.enabled | bool | `false` | Enable TLS transport |
| tls.existingSecret | string | `""` | Name of a secret containing the certificates |
| tls.key | string | `""` | Content of the certificate key to be added to the secret |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)

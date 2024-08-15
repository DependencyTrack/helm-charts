{{/*
Expand the name of the chart.
The name is truncated to 38 characters, as the longest suffix being added to it is 25 characters long.
*/}}
{{- define "hyades.name" -}}
{{- default .Chart.Name .Values.common.nameOverride | trunc 38 | trimSuffix "-" }}
{{- end -}}

{{/*
Create a default fully qualified app name.
The name is truncated to 38 characters, as the longest suffix being added to it is 25 characters long.
*/}}
{{- define "hyades.fullname" -}}
{{- if .Values.common.fullnameOverride -}}
{{- .Values.common.fullnameOverride | trunc 38 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.common.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 38 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 38 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hyades.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hyades.commonLabels" -}}
helm.sh/chart: {{ include "hyades.chart" . }}
app.kubernetes.io/part-of: {{ include "hyades.name" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Common selector labels
*/}}
{{- define "hyades.commonSelectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


{{/*
API server labels
*/}}
{{- define "hyades.apiServerLabels" -}}
{{ include "hyades.commonLabels" . }}
{{ include "hyades.apiServerSelectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}

{{/*
API server selector labels
*/}}
{{- define "hyades.apiServerSelectorLabels" -}}
{{ include "hyades.commonSelectorLabels" . }}
app.kubernetes.io/name: {{ printf "%s-api-server" (include "hyades.name" .) }}
app.kubernetes.io/component: api-server
{{- end -}}

{{/*
API server name
*/}}
{{- define "hyades.apiServerName" -}}
{{- printf "%s-api-server" (include "hyades.name" .) -}}
{{- end -}}

{{/*
API server fully qualified name
*/}}
{{- define "hyades.apiServerFullname" -}}
{{- printf "%s-api-server" (include "hyades.fullname" .) -}}
{{- end -}}

{{/*
API server image
*/}}
{{- define "hyades.apiServerImage" -}}
{{- if eq (substr 0 7 .Values.apiServer.image.tag) "sha256:" -}}
{{- printf "%s/%s@%s" (.Values.apiServer.image.registry | default .Values.common.image.registry) .Values.apiServer.image.repository .Values.apiServer.image.tag -}}
{{- else -}}
{{- printf "%s/%s:%s" (.Values.apiServer.image.registry | default .Values.common.image.registry) .Values.apiServer.image.repository (.Values.apiServer.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end -}}


{{/*
Frontend labels
*/}}
{{- define "hyades.frontendLabels" -}}
{{ include "hyades.commonLabels" . }}
{{ include "hyades.frontendSelectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}

{{/*
Frontend selector labels
*/}}
{{- define "hyades.frontendSelectorLabels" -}}
{{ include "hyades.commonSelectorLabels" . }}
app.kubernetes.io/name: {{ printf "%s-frontend" (include "hyades.name" .) }}
app.kubernetes.io/component: frontend
{{- end -}}

{{/*
Frontend name
*/}}
{{- define "hyades.frontendName" -}}
{{- printf "%s-frontend" (include "hyades.name" .) -}}
{{- end -}}

{{/*
Frontend fully qualified name
*/}}
{{- define "hyades.frontendFullname" -}}
{{- printf "%s-frontend" (include "hyades.fullname" .) -}}
{{- end -}}

{{/*
Frontend image
*/}}
{{- define "hyades.frontendImage" -}}
{{- if eq (substr 0 7 .Values.frontend.image.tag) "sha256:" -}}
{{- printf "%s/%s@%s" (.Values.frontend.image.registry | default .Values.common.image.registry) .Values.frontend.image.repository .Values.frontend.image.tag -}}
{{- else -}}
{{- printf "%s/%s:%s" (.Values.frontend.image.registry | default .Values.common.image.registry) .Values.frontend.image.repository (.Values.frontend.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end -}}


{{/*
Mirror service labels
*/}}
{{- define "hyades.mirrorServiceLabels" -}}
{{ include "hyades.commonLabels" . }}
{{ include "hyades.mirrorServiceSelectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}

{{/*
Mirror service selector labels
*/}}
{{- define "hyades.mirrorServiceSelectorLabels" -}}
{{ include "hyades.commonSelectorLabels" . }}
app.kubernetes.io/name: {{ printf "%s-mirror-service" (include "hyades.name" .) }}
app.kubernetes.io/component: mirror-service
{{- end -}}

{{/*
Mirror service name
*/}}
{{- define "hyades.mirrorServiceName" -}}
{{- printf "%s-mirror-service" (include "hyades.name" .) -}}
{{- end -}}

{{/*
Mirror service fully qualified name
*/}}
{{- define "hyades.mirrorServiceFullname" -}}
{{- printf "%s-mirror-service" (include "hyades.fullname" .) -}}
{{- end -}}

{{/*
Mirror service image
*/}}
{{- define "hyades.mirrorServiceImage" -}}
{{- if eq (substr 0 7 .Values.mirrorService.image.tag) "sha256:" -}}
{{- printf "%s/%s@%s" (.Values.mirrorService.image.registry | default .Values.common.image.registry) .Values.mirrorService.image.repository .Values.mirrorService.image.tag -}}
{{- else -}}
{{- printf "%s/%s:%s" (.Values.mirrorService.image.registry | default .Values.common.image.registry) .Values.mirrorService.image.repository (.Values.mirrorService.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end -}}


{{/*
Notification publisher labels
*/}}
{{- define "hyades.notificationPublisherLabels" -}}
{{ include "hyades.commonLabels" . }}
{{ include "hyades.notificationPublisherSelectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}

{{/*
Notification publisher selector labels
*/}}
{{- define "hyades.notificationPublisherSelectorLabels" -}}
{{ include "hyades.commonSelectorLabels" . }}
app.kubernetes.io/name: {{ printf "%s-notification-publisher" (include "hyades.name" .) }}
app.kubernetes.io/component: notification-publisher
{{- end -}}

{{/*
Notification publisher name
*/}}
{{- define "hyades.notificationPublisherName" -}}
{{- printf "%s-notification-publisher" (include "hyades.name" .) -}}
{{- end -}}

{{/*
Notification publisher fully qualified name
*/}}
{{- define "hyades.notificationPublisherFullname" -}}
{{- printf "%s-notification-publisher" (include "hyades.fullname" .) -}}
{{- end -}}

{{/*
Notification publisher image
*/}}
{{- define "hyades.notificationPublisherImage" -}}
{{- if eq (substr 0 7 .Values.notificationPublisher.image.tag) "sha256:" -}}
{{- printf "%s/%s@%s" (.Values.notificationPublisher.image.registry | default .Values.common.image.registry) .Values.notificationPublisher.image.repository .Values.notificationPublisher.image.tag -}}
{{- else -}}
{{- printf "%s/%s:%s" (.Values.notificationPublisher.image.registry | default .Values.common.image.registry) .Values.notificationPublisher.image.repository (.Values.notificationPublisher.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end -}}


{{/*
Repository metadata analyzer labels
*/}}
{{- define "hyades.repoMetaAnalyzerLabels" -}}
{{ include "hyades.commonLabels" . }}
{{ include "hyades.repoMetaAnalyzerSelectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}

{{/*
Repository metadata analyzer selector labels
*/}}
{{- define "hyades.repoMetaAnalyzerSelectorLabels" -}}
{{ include "hyades.commonSelectorLabels" . }}
app.kubernetes.io/name: {{ printf "%s-repository-meta-analyzer" (include "hyades.name" .) }}
app.kubernetes.io/component: repository-meta-analyzer
{{- end -}}

{{/*
Repository metadata analyzer name
*/}}
{{- define "hyades.repoMetaAnalyzerName" -}}
{{- printf "%s-repository-meta-analyzer" (include "hyades.name" .) -}}
{{- end -}}

{{/*
Repository metadata analyzer fully qualified name
*/}}
{{- define "hyades.repoMetaAnalyzerFullname" -}}
{{- printf "%s-repository-meta-analyzer" (include "hyades.fullname" .) -}}
{{- end -}}

{{/*
Repository metadata analyzer image
*/}}
{{- define "hyades.repoMetaAnalyzerImage" -}}
{{- if eq (substr 0 7 .Values.repoMetaAnalyzer.image.tag) "sha256:" -}}
{{- printf "%s/%s@%s" (.Values.repoMetaAnalyzer.image.registry | default .Values.common.image.registry) .Values.repoMetaAnalyzer.image.repository .Values.repoMetaAnalyzer.image.tag -}}
{{- else -}}
{{- printf "%s/%s:%s" (.Values.repoMetaAnalyzer.image.registry | default .Values.common.image.registry) .Values.repoMetaAnalyzer.image.repository (.Values.repoMetaAnalyzer.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end -}}


{{/*
Vulnerability analyzer labels
*/}}
{{- define "hyades.vulnAnalyzerLabels" -}}
{{ include "hyades.commonLabels" . }}
{{ include "hyades.vulnAnalyzerSelectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}

{{/*
Vulnerability analyzer selector labels
*/}}
{{- define "hyades.vulnAnalyzerSelectorLabels" -}}
{{ include "hyades.commonSelectorLabels" . }}
app.kubernetes.io/name: {{ printf "%s-vulnerability-analyzer" (include "hyades.name" .) }}
app.kubernetes.io/component: vulnerability-analyzer
{{- end -}}

{{/*
Vulnerability analyzer name
*/}}
{{- define "hyades.vulnAnalyzerName" -}}
{{- printf "%s-vulnerability-analyzer" (include "hyades.name" .) -}}
{{- end -}}

{{/*
Vulnerability analyzer fully qualified name
*/}}
{{- define "hyades.vulnAnalyzerFullname" -}}
{{- printf "%s-vulnerability-analyzer" (include "hyades.fullname" .) -}}
{{- end -}}

{{/*
Vulnerability analyzer image
*/}}
{{- define "hyades.vulnAnalyzerImage" -}}
{{- if eq (substr 0 7 .Values.vulnAnalyzer.image.tag) "sha256:" -}}
{{- printf "%s/%s@%s" (.Values.vulnAnalyzer.image.registry | default .Values.common.image.registry) .Values.vulnAnalyzer.image.repository .Values.vulnAnalyzer.image.tag -}}
{{- else -}}
{{- printf "%s/%s:%s" (.Values.vulnAnalyzer.image.registry | default .Values.common.image.registry) .Values.vulnAnalyzer.image.repository (.Values.vulnAnalyzer.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end -}}

{{/*
*/}}
{{- define "hyades.secretKeySecretName" -}}
{{- if .Values.common.secretKey.existingSecretName -}}
{{- .Values.common.secretKey.existingSecretName -}}
{{- else if .Values.common.secretKey.createSecret -}}
{{- printf "%s-secret-key" (include "hyades.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account
*/}}
{{- define "hyades.serviceAccountName" -}}
{{- if .Values.common.serviceAccount.create }}
{{- default (include "hyades.fullname" .) .Values.common.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.common.serviceAccount.name }}
{{- end }}
{{- end }}
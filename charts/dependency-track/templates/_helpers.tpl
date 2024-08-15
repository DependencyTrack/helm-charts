{{/*
Expand the name of the chart.
The name is truncated to 38 characters, as the longest suffix being added to it is 25 characters long.
*/}}
{{- define "dependencytrack.name" -}}
{{- default .Chart.Name .Values.common.nameOverride | trunc 38 | trimSuffix "-" }}
{{- end -}}

{{/*
Create a default fully qualified app name.
The name is truncated to 38 characters, as the longest suffix being added to it is 25 characters long.
*/}}
{{- define "dependencytrack.fullname" -}}
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
{{- define "dependencytrack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dependencytrack.commonLabels" -}}
helm.sh/chart: {{ include "dependencytrack.chart" . }}
app.kubernetes.io/part-of: {{ include "dependencytrack.name" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Common selector labels
*/}}
{{- define "dependencytrack.commonSelectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


{{/*
API server labels
*/}}
{{- define "dependencytrack.apiServerLabels" -}}
{{ include "dependencytrack.commonLabels" . }}
{{ include "dependencytrack.apiServerSelectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}

{{/*
API server selector labels
*/}}
{{- define "dependencytrack.apiServerSelectorLabels" -}}
{{ include "dependencytrack.commonSelectorLabels" . }}
app.kubernetes.io/name: {{ printf "%s-api-server" (include "dependencytrack.name" .) }}
app.kubernetes.io/component: api-server
{{- end -}}

{{/*
API server name
*/}}
{{- define "dependencytrack.apiServerName" -}}
{{- printf "%s-api-server" (include "dependencytrack.name" .) -}}
{{- end -}}

{{/*
API server fully qualified name
*/}}
{{- define "dependencytrack.apiServerFullname" -}}
{{- printf "%s-api-server" (include "dependencytrack.fullname" .) -}}
{{- end -}}

{{/*
API server image
*/}}
{{- define "dependencytrack.apiServerImage" -}}
{{- if eq (substr 0 7 .Values.apiServer.image.tag) "sha256:" -}}
{{- printf "%s/%s@%s" (.Values.apiServer.image.registry | default .Values.common.image.registry) .Values.apiServer.image.repository .Values.apiServer.image.tag -}}
{{- else -}}
{{- printf "%s/%s:%s" (.Values.apiServer.image.registry | default .Values.common.image.registry) .Values.apiServer.image.repository (.Values.apiServer.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end -}}


{{/*
Frontend labels
*/}}
{{- define "dependencytrack.frontendLabels" -}}
{{ include "dependencytrack.commonLabels" . }}
{{ include "dependencytrack.frontendSelectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}

{{/*
Frontend selector labels
*/}}
{{- define "dependencytrack.frontendSelectorLabels" -}}
{{ include "dependencytrack.commonSelectorLabels" . }}
app.kubernetes.io/name: {{ printf "%s-frontend" (include "dependencytrack.name" .) }}
app.kubernetes.io/component: frontend
{{- end -}}

{{/*
Frontend name
*/}}
{{- define "dependencytrack.frontendName" -}}
{{- printf "%s-frontend" (include "dependencytrack.name" .) -}}
{{- end -}}

{{/*
Frontend fully qualified name
*/}}
{{- define "dependencytrack.frontendFullname" -}}
{{- printf "%s-frontend" (include "dependencytrack.fullname" .) -}}
{{- end -}}

{{/*
Frontend image
*/}}
{{- define "dependencytrack.frontendImage" -}}
{{- if eq (substr 0 7 .Values.frontend.image.tag) "sha256:" -}}
{{- printf "%s/%s@%s" (.Values.frontend.image.registry | default .Values.common.image.registry) .Values.frontend.image.repository .Values.frontend.image.tag -}}
{{- else -}}
{{- printf "%s/%s:%s" (.Values.frontend.image.registry | default .Values.common.image.registry) .Values.frontend.image.repository (.Values.frontend.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end -}}

{{/*
*/}}
{{- define "dependencytrack.secretKeySecretName" -}}
{{- if .Values.common.secretKey.existingSecretName -}}
{{- .Values.common.secretKey.existingSecretName -}}
{{- else if .Values.common.secretKey.createSecret -}}
{{- printf "%s-secret-key" (include "dependencytrack.fullname" .) -}}
{{- end -}}
{{- end -}}


{{/*
Create the name of the service account
*/}}
{{- define "dependencytrack.serviceAccountName" -}}
{{- if .Values.common.serviceAccount.create }}
{{- default (include "dependencytrack.fullname" .) .Values.common.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.common.serviceAccount.name }}
{{- end }}
{{- end }}


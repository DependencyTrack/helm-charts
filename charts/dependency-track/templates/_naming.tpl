{{/*
  Truncated to 45 chars; the longest chart suffix is `-api-server-worker`
  (18 chars), keeping final resource names under k8s' 63-char label cap.
*/}}
{{- define "dependencytrack.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 45 | trimSuffix "-" }}
{{- end }}

{{- define "dependencytrack.fullname" }}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 45 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 45 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 45 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "dependencytrack.chart" }}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "dependencytrack.commonLabels" -}}
helm.sh/chart: {{ include "dependencytrack.chart" . }}
app.kubernetes.io/part-of: {{ include "dependencytrack.name" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "dependencytrack.componentFullname" }}
{{- printf "%s-%s" (include "dependencytrack.fullname" .ctx) .suffix | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
  Empty `role` omits the per-role label, yielding a family selector
  that matches both web and worker.
*/}}
{{- define "dependencytrack.selectorLabels" -}}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
app.kubernetes.io/name: {{ printf "%s-%s" (include "dependencytrack.name" .ctx) .component }}
app.kubernetes.io/component: {{ .component }}
{{- if .role }}
dependencytrack.io/role: {{ .role }}
{{- end }}
{{- end }}

{{- define "dependencytrack.componentLabels" -}}
{{ include "dependencytrack.commonLabels" .ctx }}
{{ include "dependencytrack.selectorLabels" . }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion }}
{{- end -}}

{{/*
  In monolith topology the api-server runs as a single Deployment named
  <fullname>-api-server (no -web suffix). In split topology it becomes
  <fullname>-api-server-web alongside <fullname>-api-server-worker.
*/}}
{{- define "dependencytrack.apiServer.webFullname" }}
{{- if eq (include "dependencytrack.topology" .) "split" }}
{{- include "dependencytrack.componentFullname" (dict "ctx" . "suffix" "api-server-web") }}
{{- else }}
{{- include "dependencytrack.componentFullname" (dict "ctx" . "suffix" "api-server") }}
{{- end }}
{{- end }}

{{- define "dependencytrack.apiServer.workerFullname" }}
{{- include "dependencytrack.componentFullname" (dict "ctx" . "suffix" "api-server-worker") }}
{{- end }}

{{- define "dependencytrack.apiServer.metricsFullname" }}
{{- include "dependencytrack.componentFullname" (dict "ctx" . "suffix" "api-server-metrics") }}
{{- end }}

{{- define "dependencytrack.frontend.fullname" }}
{{- include "dependencytrack.componentFullname" (dict "ctx" . "suffix" "frontend") }}
{{- end }}

{{- define "dependencytrack.serviceAccountName" }}
{{- if .Values.serviceAccount.create }}
{{- default (include "dependencytrack.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "dependencytrack.topology" }}
{{- $t := .Values.apiServer.topology | default "monolith" }}
{{- if not (has $t (list "monolith" "split")) }}
{{- fail (printf "apiServer.topology must be 'monolith' or 'split', got %q" $t) }}
{{- end }}
{{- $t }}
{{- end }}

{{- define "dependencytrack.workerEnabled" }}
{{- if eq (include "dependencytrack.topology" .) "split" -}}true{{- end }}
{{- end -}}

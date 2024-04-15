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
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
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
{{- printf "%s/%s:%s" .Values.common.image.registry .Values.apiServer.image.repository (.Values.apiServer.image.tag | default .Chart.AppVersion) -}}
{{- end -}}


{{/*
Frontend labels
*/}}
{{- define "dependencytrack.frontendLabels" -}}
{{ include "dependencytrack.commonLabels" . }}
{{ include "dependencytrack.frontendSelectorLabels" . }}
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
{{- printf "%s/%s:%s" .Values.common.image.registry .Values.frontend.image.repository (.Values.frontend.image.tag | default .Chart.AppVersion) -}}
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

{{- /*
Expand the name of the namespace
*/ -}}
{{- define "dependencytrack.namespace" -}}
{{- default .Release.Namespace (include "!TPL" (dict "ROOT" . "VALUE" (get .Values "namespaceOverride" | default ""))) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Reuses the value from an existing secret, otherwise sets its value to a default value.

Usage:
{{ include "dependencytrack.secrets.lookup" (dict "SECRET" "secret-name" "KEY" "keyName" "DEFAULTVALUE" .Values.myValue "ROOT" $) }}

Params:
  - SECRET - String - Required - Name of the 'Secret' resource where the password is stored.
  - KEY - String - Required - Name of the key in the secret.
  - DEFAULTVALUE - String - Required - The path to the validating value in the values.yaml, e.g: "mysql.password". Will pick first parameter with a defined value.
  - ROOT - Context - Required - Parent context.

*/}}
{{- define "dependencytrack.secrets.lookup" -}}
{{- $value := "" -}}
{{- $secretData := (lookup "v1" "Secret" (include "dependencytrack.namespace" .ROOT) .SECRET).data -}}
{{- if and $secretData (hasKey $secretData .KEY) -}}
  {{- $value = index $secretData .KEY -}}
{{- else if .DEFAULTVALUE -}}
  {{- $value = .DEFAULTVALUE | toString | b64enc -}}
{{- end -}}
{{- if $value -}}
{{- printf "%s" $value -}}
{{- end -}}
{{- end -}}
{{- /*

  dependencytrack.tpl.render - Renders a value that contains a template

  ALIAS: !TPL

  This template takes a value that may contain a Helm template and renders it. It's useful for dynamic configuration
  values that need to be evaluated during chart rendering. If the value is a empty, nothing is returned. If the value is
  not a string, it converts it to a YAML string first. If the value doesn't contain a Helm template (identified by "{{"),
  input value is passed and returned as-is. If a scope is provided, it prepares the scope before evaluating the
  template. This is useful if you need to evaluate the template in a different context (with, range).

  Arguments:
  - ROOT: The root context. If not provided, a default empty dictionary is used.
  - VALUE: The value that may contain a Helm template. This is the value that will be rendered.
  - SCOPE: The scope within which to evaluate the template. If not provided, a default empty dictionary is used.

  Example Usage:
    {{ include "dependencytrack.tpl.render" (dict "ROOT" $ "VALUE" .Values.path.to.the.Value) }}
    {{ include "!TPL" (dict "ROOT" $ "VALUE" .Values.path.to.the.Value) }}
    {{ include "!TPL" (dict "ROOT" $ "VALUE" .Values.path.to.the.Value "SCOPE" .scope) }}

*/ -}}
{{- define "dependencytrack.tpl.render" -}}
{{- /* Initialize arguments */ -}}
{{- $ := .ROOT | default (dict) -}}
{{- $SCOPE := .SCOPE | default (dict) -}}
{{- $VALUE := .VALUE -}}

{{- /* Check, if $VALUE is NOT empty */ -}}
{{- if $VALUE | empty | not -}}
  {{- /* If $VALUE is NOT a string, convert it to YAML string first */ -}}
  {{- $value := ternary $VALUE ($VALUE | toYaml) ($VALUE | typeIs "string") }}
  {{- /* Initialize the $result */ -}}
  {{- $result := "" -}}

  {{- /* If $value contains "{{" (it's template), ... */ -}}
  {{- /* NOTE: This avoids templating of values that are not templates for better performance */ -}}
  {{- if contains "{{" (toJson $value) }}
    {{- /* ... check, if $SCOPE is defined and ... */ -}}
    {{- if $SCOPE | empty | not -}}
        {{- /* ... prepare scope and then evaluate the template */ -}}
        {{- $result = tpl (cat "{{- with $.RelativeScope -}}" $value "{{- end }}") (merge (dict "RelativeScope" $SCOPE) $) }}
    {{- else }}
      {{- /* ... evaluate the template */ -}}
      {{- $result = tpl $value $ }}
    {{- end }}
  {{- else }}
      {{- /* ... pass $value AS-IS */ -}}
      {{- $result = $value }}
  {{- end }}

  {{- /* Return the result */ -}}
  {{- $result -}}
{{- end -}}
{{- end -}}

{{- /* ALIAS */ -}}
{{- define "!TPL" }}{{- include "dependencytrack.tpl.render" . }}{{- end -}}
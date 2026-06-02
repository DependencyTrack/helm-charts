{{- define "dependencytrack.image" }}
{{- $registry := .image.registry | default .fallbackRegistry }}
{{- $repo := .image.repository | default .fallbackRepo }}
{{- $tag := .image.tag | default .fallbackTag }}
{{- if eq (substr 0 7 $tag) "sha256:" }}
{{- printf "%s/%s@%s" $registry $repo $tag }}
{{- else }}
{{- printf "%s/%s:%s" $registry $repo $tag }}
{{- end }}
{{- end }}

{{- define "dependencytrack.apiServer.image" }}
{{- include "dependencytrack.image" (dict "image" .Values.apiServer.image "fallbackRegistry" .Values.image.registry "fallbackRepo" "" "fallbackTag" .Chart.AppVersion) }}
{{- end }}

{{- define "dependencytrack.frontend.image" }}
{{- include "dependencytrack.image" (dict "image" .Values.frontend.image "fallbackRegistry" .Values.image.registry "fallbackRepo" "" "fallbackTag" .Chart.AppVersion) }}
{{- end -}}

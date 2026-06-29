{{- define "dependencytrack.validate.routing" }}
{{- if and .Values.ingress.enabled .Values.httpRoute.enabled }}
{{- fail "ingress.enabled and httpRoute.enabled are mutually exclusive; both routes would target the same Services. Pick one." }}
{{- end }}
{{- end -}}

{{/*
  In monolith topology the worker.* block is silently ignored.
  A single Deployment runs with web's knobs. Fail loudly when a user
  has touched keys that only take effect in split mode,
  so a monolith -> split bump never encounters half-configured worker knobs.
*/}}
{{- define "dependencytrack.validate.monolithWorker" }}
{{- if eq (include "dependencytrack.topology" .) "monolith" }}
{{- $w := .Values.apiServer.worker }}
{{- $touched := list }}
{{- if ne (int $w.replicaCount) 1 }}{{- $touched = append $touched "replicaCount" }}{{- end }}
{{- if $w.autoscaling.enabled }}{{- $touched = append $touched "autoscaling.enabled" }}{{- end }}
{{- if $w.pdb.enabled }}{{- $touched = append $touched "pdb.enabled" }}{{- end }}
{{- if $w.extraEnv }}{{- $touched = append $touched "extraEnv" }}{{- end }}
{{- if $w.extraEnvFrom }}{{- $touched = append $touched "extraEnvFrom" }}{{- end }}
{{- if $w.tolerations }}{{- $touched = append $touched "tolerations" }}{{- end }}
{{- if $w.nodeSelector }}{{- $touched = append $touched "nodeSelector" }}{{- end }}
{{- if $w.affinity }}{{- $touched = append $touched "affinity" }}{{- end }}
{{- if $w.topologySpreadConstraints }}{{- $touched = append $touched "topologySpreadConstraints" }}{{- end }}
{{- if $w.priorityClassName }}{{- $touched = append $touched "priorityClassName" }}{{- end }}
{{- if $touched }}
{{- fail (printf "apiServer.worker.{%s} set, but apiServer.topology=monolith renders no worker Deployment. Set apiServer.topology=split to enable the worker role, or move these settings to apiServer.web.*" (join "," $touched)) }}
{{- end }}
{{- end }}
{{- end }}

{{- define "dependencytrack.validate.initializer" }}
{{- if .Values.apiServer.initializer.enabled }}
{{- if not .Values.database.existingSecret.name }}
{{- fail "apiServer.initializer.enabled requires database.existingSecret.name: the pre-install/pre-upgrade hook Job runs before chart-managed Secrets are created, so provision DB credentials separately." }}
{{- end }}
{{- if eq (include "dependencytrack.secretManagement.database.kek.chartManaged" .) "true" }}
{{- fail "apiServer.initializer.enabled is incompatible with an inline secretManagement.database.kek.value: the pre-install/pre-upgrade hook Job runs before chart-managed Secrets are created. Provision the KEK Secret separately and reference it via secretManagement.database.kek.existingSecret.name." }}
{{- end }}
{{- end }}
{{- end }}

{{- define "dependencytrack.validate.fileStorage" }}
{{- if and (eq .Values.fileStorage.provider "local") (not .Values.fileStorage.local.existingClaim) }}
{{- if not (has "ReadWriteMany" .Values.fileStorage.local.accessModes) }}
{{- $roles := list }}
{{- $web := .Values.apiServer.web }}
{{- if or (gt (int $web.replicaCount) 1) $web.autoscaling.enabled }}{{- $roles = append $roles "web" }}{{- end }}
{{- if eq (include "dependencytrack.topology" .) "split" }}
{{- $worker := .Values.apiServer.worker }}
{{- if or (gt (int $worker.replicaCount) 1) $worker.autoscaling.enabled }}{{- $roles = append $roles "worker" }}{{- end }}
{{- end }}
{{- if $roles }}
{{- fail (printf "apiServer.{%s} scales above one replica, but fileStorage.provider=local with accessModes=%v cannot be shared across pods. Set fileStorage.local.accessModes: [ReadWriteMany] with an RWX-capable StorageClass, or switch to fileStorage.provider=s3." (join "," $roles) .Values.fileStorage.local.accessModes) }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "dependencytrack.validate.all" }}
{{- include "dependencytrack.validate.routing" . }}
{{- include "dependencytrack.validate.kek" . }}
{{- include "dependencytrack.validate.monolithWorker" . }}
{{- include "dependencytrack.validate.initializer" . }}
{{- include "dependencytrack.validate.fileStorage" . }}
{{- end -}}

{{/*
  Assmble the full `env` section for a pod, accounting for its role in the topology.

  $ctx and $role are provided by callers of this template.

  $role is any of `monolith`, `web`, `worker`, or `initializer`, where:
    * `web` sets `DT_CONFIG_PROFILE=web` which disables any background processing.
    * `monolith` / `worker` run with DT defaults (i.e. `web` and background processing).
    * `initializer` exits after init tasks were executed.
*/}}
{{- define "dependencytrack.podEnv" }}
{{- $ctx := .ctx }}
{{- $role := .role }}
{{- $v := $ctx.Values }}
{{- include "dependencytrack.validate.all" $ctx -}}
- name: DT_METRICS_ENABLED
  value: "true"
- name: DT_MANAGEMENT_PORT
  value: "{{ $v.apiServer.service.managementPort }}"
- name: DT_DATASOURCE_URL
  value: {{ tpl $v.database.jdbcUrl $ctx | quote }}
- name: DT_DATASOURCE_USERNAME
  value: "${file::{{ include "dependencytrack.secretMountDir.db" $ctx }}/username}"
- name: DT_DATASOURCE_PASSWORD
  value: "${file::{{ include "dependencytrack.secretMountDir.db" $ctx }}/password}"
- name: DT_SECRET_MANAGEMENT_PROVIDER
  value: {{ $v.secretManagement.provider | quote }}
{{- if eq (include "dependencytrack.secretManagement.database.active" $ctx) "true" }}
{{- if eq (include "dependencytrack.secretManagement.database.kekMode" $ctx) "keyset" }}
- name: DT_SECRET_MANAGEMENT_DATABASE_KEK_KEYSET_PATH
  value: "{{ include "dependencytrack.secretManagement.database.kekFilePath" $ctx }}"
{{- else }}
- name: DT_SECRET_MANAGEMENT_DATABASE_KEK
  value: "${file::{{ include "dependencytrack.secretManagement.database.kekFilePath" $ctx }}}"
{{- end }}
{{- end }}
{{- if eq $role "initializer" }}
- name: DT_INIT_TASKS_ENABLED
  value: "true"
- name: DT_INIT_TASKS_EXIT_AFTER_COMPLETION
  value: "true"
- name: DT_DATASOURCE_POOL_ENABLED
  value: "false"
{{- else }}
{{- if eq $v.fileStorage.provider "local" }}
- name: DT_FILE_STORAGE_PROVIDER
  value: "local"
- name: DT_FILE_STORAGE_LOCAL_DIRECTORY
  value: "{{ $v.fileStorage.local.mountPath }}"
{{- else if eq $v.fileStorage.provider "s3" }}
- name: DT_FILE_STORAGE_PROVIDER
  value: "s3"
- name: DT_FILE_STORAGE_S3_ENDPOINT
  value: {{ tpl $v.fileStorage.s3.endpoint $ctx | quote }}
- name: DT_FILE_STORAGE_S3_REGION
  value: {{ tpl $v.fileStorage.s3.region $ctx | quote }}
- name: DT_FILE_STORAGE_S3_BUCKET
  value: {{ tpl $v.fileStorage.s3.bucket $ctx | quote }}
- name: DT_FILE_STORAGE_S3_ACCESS_KEY
  value: "${file::{{ include "dependencytrack.secretMountDir.s3" $ctx }}/access-key-id}"
- name: DT_FILE_STORAGE_S3_SECRET_KEY
  value: "${file::{{ include "dependencytrack.secretMountDir.s3" $ctx }}/secret-access-key}"
{{- end }}
{{- if $v.apiServer.initializer.enabled }}
- name: DT_INIT_TASKS_ENABLED
  value: "false"
{{- end }}
{{- end }}
{{- if eq $role "web" }}
- name: DT_CONFIG_PROFILE
  value: "web"
{{- end }}
{{- with $v.apiServer.extraEnv }}
{{ toYaml . }}
{{- end }}
{{- if or (eq $role "web") (eq $role "monolith") }}
{{- with $v.apiServer.web.extraEnv }}
{{ toYaml . }}
{{- end }}
{{- else if eq $role "worker" }}
{{- with $v.apiServer.worker.extraEnv }}
{{ toYaml . }}
{{- end }}
{{- end }}
{{- end -}}

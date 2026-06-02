{{- define "dependencytrack.db.secretName" }}
{{- if .Values.database.existingSecret.name }}
{{- .Values.database.existingSecret.name }}
{{- else }}
{{- printf "%s-db" (include "dependencytrack.fullname" .) }}
{{- end }}
{{- end }}

{{- define "dependencytrack.db.usernameKey" }}
{{- .Values.database.existingSecret.usernameKey | default "username" }}
{{- end }}

{{- define "dependencytrack.db.passwordKey" }}
{{- .Values.database.existingSecret.passwordKey | default "password" }}
{{- end }}

{{- define "dependencytrack.db.chartManaged" }}
{{- if not .Values.database.existingSecret.name -}}true{{- end }}
{{- end }}

{{- define "dependencytrack.secretManagement.database.active" }}
{{- if eq .Values.secretManagement.provider "database" -}}
true
{{- end }}
{{- end }}

{{- define "dependencytrack.secretManagement.database.kekSecretName" }}
{{- .Values.secretManagement.database.kek.existingSecret.name }}
{{- end }}

{{- define "dependencytrack.secretManagement.database.kekMode" }}
{{- $m := .Values.secretManagement.database.kek.mode | default "config" }}
{{- if not (has $m (list "config" "keyset")) }}
{{- fail (printf "secretManagement.database.kek.mode must be 'config' or 'keyset', got %q" $m) }}
{{- end }}
{{- $m }}
{{- end }}

{{- define "dependencytrack.secretManagement.database.kekKey" }}
{{- $explicit := .Values.secretManagement.database.kek.existingSecret.key }}
{{- if $explicit }}
{{- $explicit }}
{{- else if eq (include "dependencytrack.secretManagement.database.kekMode" .) "keyset" -}}
kek-keyset.json
{{- else -}}
kek
{{- end }}
{{- end }}

{{- define "dependencytrack.secretManagement.database.kekFilePath" }}
{{- include "dependencytrack.secretMountDir.kek" . -}}/{{- include "dependencytrack.secretManagement.database.kekKey" . }}
{{- end }}

{{- define "dependencytrack.s3.secretName" }}
{{- if .Values.fileStorage.s3.credentials.existingSecret.name }}
{{- .Values.fileStorage.s3.credentials.existingSecret.name }}
{{- else }}
{{- printf "%s-s3" (include "dependencytrack.fullname" .) }}
{{- end }}
{{- end }}

{{- define "dependencytrack.s3.accessKeyIdKey" }}
{{- .Values.fileStorage.s3.credentials.existingSecret.accessKeyIdKey | default "accessKeyId" }}
{{- end }}

{{- define "dependencytrack.s3.secretAccessKeyKey" }}
{{- .Values.fileStorage.s3.credentials.existingSecret.secretAccessKeyKey | default "secretAccessKey" }}
{{- end }}

{{- define "dependencytrack.s3.chartManaged" }}
{{- if and (eq .Values.fileStorage.provider "s3") (not .Values.fileStorage.s3.credentials.existingSecret.name) -}}true{{- end }}
{{- end }}

{{- define "dependencytrack.secretMountDir.db" -}}/etc/dt/secrets/db{{- end }}
{{- define "dependencytrack.secretMountDir.s3" -}}/etc/dt/secrets/s3{{- end }}
{{- define "dependencytrack.secretMountDir.kek" -}}/etc/dt/secrets/sm/database/kek{{- end }}

{{- define "dependencytrack.validate.kek" }}
{{- if eq (include "dependencytrack.secretManagement.database.active" .) "true" }}
{{- if not .Values.secretManagement.database.kek.existingSecret.name }}
{{- fail "secretManagement.database.kek.existingSecret.name is required when secretManagement.provider=database. Provision the KEK Secret out of band (ESO/Vault/SealedSecrets) and reference it here." }}
{{- end }}
{{- end }}
{{- end }}

{{- define "dependencytrack.secretVolumes" -}}
{{- $ctx := .ctx -}}
- name: db-secret
  secret:
    secretName: {{ include "dependencytrack.db.secretName" $ctx }}
    defaultMode: 0444
    items:
      - key: {{ include "dependencytrack.db.usernameKey" $ctx }}
        path: username
      - key: {{ include "dependencytrack.db.passwordKey" $ctx }}
        path: password
{{- if eq (include "dependencytrack.secretManagement.database.active" $ctx) "true" }}
- name: sm-database-kek
  secret:
    secretName: {{ include "dependencytrack.secretManagement.database.kekSecretName" $ctx }}
    defaultMode: 0444
    items:
      - key: {{ include "dependencytrack.secretManagement.database.kekKey" $ctx }}
        path: {{ include "dependencytrack.secretManagement.database.kekKey" $ctx }}
{{- end }}
{{- if and .includeFileStorage (eq $ctx.Values.fileStorage.provider "s3") }}
- name: s3-secret
  secret:
    secretName: {{ include "dependencytrack.s3.secretName" $ctx }}
    defaultMode: 0444
    items:
      - key: {{ include "dependencytrack.s3.accessKeyIdKey" $ctx }}
        path: access-key-id
      - key: {{ include "dependencytrack.s3.secretAccessKeyKey" $ctx }}
        path: secret-access-key
{{- end }}
{{- end }}

{{- define "dependencytrack.secretVolumeMounts" -}}
{{- $ctx := .ctx -}}
- name: db-secret
  mountPath: {{ include "dependencytrack.secretMountDir.db" $ctx }}
  readOnly: true
{{- if eq (include "dependencytrack.secretManagement.database.active" $ctx) "true" }}
- name: sm-database-kek
  mountPath: {{ include "dependencytrack.secretMountDir.kek" $ctx }}
  readOnly: true
{{- end }}
{{- if and .includeFileStorage (eq $ctx.Values.fileStorage.provider "s3") }}
- name: s3-secret
  mountPath: {{ include "dependencytrack.secretMountDir.s3" $ctx }}
  readOnly: true
{{- end }}
{{- end }}

{{- define "dependencytrack.fileStorage.localClaimName" }}
{{- if .Values.fileStorage.local.existingClaim }}
{{- .Values.fileStorage.local.existingClaim }}
{{- else }}
{{- printf "%s-storage" (include "dependencytrack.fullname" .) }}
{{- end }}
{{- end }}

{{- define "dependencytrack.fileStorage.volumes" }}
{{- if eq .Values.fileStorage.provider "local" }}
- name: file-storage
  persistentVolumeClaim:
    claimName: {{ include "dependencytrack.fileStorage.localClaimName" . }}
{{- end }}
{{- end }}

{{- define "dependencytrack.fileStorage.volumeMounts" }}
{{- if eq .Values.fileStorage.provider "local" }}
- name: file-storage
  mountPath: {{ .Values.fileStorage.local.mountPath }}
{{- end }}
{{- end -}}

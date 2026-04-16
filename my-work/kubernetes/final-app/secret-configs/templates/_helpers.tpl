{{/* Define a consistent secret name */}}
{{- define "orders.secretName" -}}
{{- printf "%s-db-secret" .Release.Name -}}
{{- end -}}
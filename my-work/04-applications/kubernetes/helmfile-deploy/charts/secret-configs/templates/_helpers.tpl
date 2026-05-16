{{/* Define a consistent secret name */}}
{{- define "orders.secretName" -}}
{{- printf "%s-secret" .Release.Name -}}
{{- end -}}
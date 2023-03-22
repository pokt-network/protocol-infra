
{{/*
Some services might always need dev image, e.g. to access debug client.
*/}}
{{- define "dev-image" -}}
{{- if hasSuffix "-dev" $.Values.validators.image.tag }}
{{- .Values.validators.image.tag }}
{{- else }}
{{- .Values.validators.image.tag }}-dev
{{- end }}
{{- end }}

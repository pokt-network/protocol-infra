
{{/*
Some services might always need dev image, e.g. to access debug client.
*/}}
{{- define "dev-image" -}}
{{- if hasSuffix "-dev" $.Values.image.tag }}
{{- .Values.image.tag }}
{{- else }}
{{- .Values.image.tag }}-dev
{{- end }}
{{- end }}

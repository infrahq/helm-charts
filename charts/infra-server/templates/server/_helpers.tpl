{{/*
Expand the name of the chart.
*/}}
{{- define "server.name" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if hasSuffix .Values.server.name  $name }}
{{- $name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $name .Values.server.name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "server.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if .Values.fullnameOverride }}
{{- $name = .Values.fullnameOverride }}
{{- else }}
{{- if contains $name .Release.Name }}
{{- $name = .Release.Name }}
{{- else }}
{{- $name = printf "%s-%s" .Release.Name $name }}
{{- end }}
{{- end }}
{{- if hasSuffix .Values.server.name $name }}
{{- $name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $name .Values.server.name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "server.labels" -}}
helm.sh/chart: {{ include "server.chart" . }}
{{ include "server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if or .Values.server.labels .Values.global.labels }}
{{- merge .Values.server.labels .Values.global.labels | toYaml }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Pod labels
*/}}
{{- define "server.podLabels" -}}
{{- include "server.selectorLabels" . }}
{{- if or .Values.server.podLabels .Values.global.podLabels }}
{{- merge .Values.server.podLabels .Values.global.podLabels | toYaml }}
{{- end }}
{{- end }}

{{/*
Pod annotations
*/}}
{{- define "server.podAnnotations" -}}
rollme: {{ include (print .Template.BasePath "/server/configmap.yaml") . | sha1sum }}
{{- if or .Values.server.podAnnotations .Values.global.podAnnotations }}
{{- merge .Values.server.podAnnotations .Values.global.podAnnotations | toYaml }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "server.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create }}
{{- default (include "server.fullname" .) .Values.server.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.server.serviceAccount.name }}
{{- end }}
{{- end }}

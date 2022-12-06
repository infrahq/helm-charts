{{/*
Expand the name of the chart.
*/}}
{{- define "postgres.name" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if hasSuffix .Values.postgres.name  $name }}
{{- $name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $name .Values.postgres.name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "postgres.fullname" -}}
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
{{- if hasSuffix .Values.postgres.name $name }}
{{- $name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $name .Values.postgres.name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "postgres.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "postgres.labels" -}}
helm.sh/chart: {{ include "postgres.chart" . }}
{{ include "postgres.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if or .Values.postgres.labels .Values.global.labels }}
{{ merge .Values.postgres.labels .Values.global.labels | toYaml }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "postgres.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgres.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Pod labels
*/}}
{{- define "postgres.podLabels" -}}
{{- include "postgres.selectorLabels" . }}
{{- if or .Values.postgres.podLabels .Values.global.podLabels }}
{{ merge .Values.postgres.podLabels .Values.global.podLabels | toYaml }}
{{- end }}
{{- end }}

{{/*
Pod annotations
*/}}
{{- define "postgres.podAnnotations" -}}
{{- if or .Values.postgres.podAnnotations .Values.global.podAnnotations }}
{{ merge .Values.postgres.podAnnotations .Values.global.podAnnotations | toYaml }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "postgres.serviceAccountName" -}}
{{- if .Values.postgres.serviceAccount.create }}
{{- default (include "postgres.fullname" .) .Values.postgres.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.postgres.serviceAccount.name }}
{{- end }}
{{- end }}

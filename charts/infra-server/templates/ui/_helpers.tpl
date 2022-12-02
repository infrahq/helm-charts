{{/*
Expand the name of the chart.
*/}}
{{- define "ui.name" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if hasSuffix .Values.ui.name  $name }}
{{- $name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $name .Values.ui.name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ui.fullname" -}}
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
{{- if hasSuffix .Values.ui.name $name }}
{{- $name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $name .Values.ui.name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ui.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ui.labels" -}}
helm.sh/chart: {{ include "ui.chart" . }}
{{ include "ui.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if or .Values.ui.labels .Values.global.labels }}
{{- merge .Values.ui.labels .Values.global.labels | toYaml }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Pod labels
*/}}
{{- define "ui.podLabels" -}}
{{- include "ui.selectorLabels" . }}
{{- if or .Values.ui.podLabels .Values.global.podLabels }}
{{- merge .Values.ui.podLabels .Values.global.podLabels | toYaml }}
{{- end }}
{{- end }}

{{/*
Pod annotations
*/}}
{{- define "ui.podAnnotations" -}}
{{- if or .Values.ui.podAnnotations .Values.global.podAnnotations }}
{{- merge .Values.ui.podAnnotations .Values.global.podAnnotations | toYaml }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ui.serviceAccountName" -}}
{{- if .Values.ui.serviceAccount.create }}
{{- default (include "ui.fullname" .) .Values.ui.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.ui.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "clearml.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "clearml.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "clearml.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "clearml.labels" -}}
helm.sh/chart: {{ include "clearml.chart" . }}
{{ include "clearml.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "clearml.selectorLabels" -}}
app.kubernetes.io/name: {{ include "clearml.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

Selector labels (apiserver)
*/}}
{{- define "clearml.selectorLabelsApiServer" -}}
app.kubernetes.io/name: {{ include "clearml.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}-apiserver
{{- end }}

Selector labels (fileserver)
*/}}
{{- define "clearml.selectorLabelsFileServer" -}}
app.kubernetes.io/name: {{ include "clearml.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}-fileserver
{{- end }}

Selector labels (webserver)
*/}}
{{- define "clearml.selectorLabelsWebServer" -}}
app.kubernetes.io/name: {{ include "clearml.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}-webserver
{{- end }}

Selector labels (agentservices)
*/}}
{{- define "clearml.selectorLabelsAgentServices" -}}
app.kubernetes.io/name: {{ include "clearml.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}-agentservices
{{- end }}

Selector labels (agent)
*/}}
{{- define "clearml.selectorLabelsAgent" -}}
app.kubernetes.io/name: {{ include "clearml.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}-agent
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "clearml.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "clearml.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the App service to use
*/}}
{{- define "clearml.serviceApp" -}}
{{- if .Values.ingress.enabled }}
{{- if .Values.ingress.app.tlsSecretName }}
{{- printf "%s%s" "https://" .Values.ingress.app.hostName }}
{{- else }}
{{- printf "%s%s" "http://" .Values.ingress.app.hostName }}
{{- end }}
{{- else }}
{{- printf "%s%s%s%s" "http://" (include "clearml.fullname" .) "-webserver:" (.Values.webserver.service.port | toString) }}
{{- end }}
{{- end }}

{{/*
Create the name of the Api service to use
*/}}
{{- define "clearml.serviceApi" -}}
{{- if .Values.ingress.enabled }}
{{- if .Values.ingress.api.tlsSecretName }}
{{- printf "%s%s" "https://" .Values.ingress.api.hostName }}
{{- else }}
{{- printf "%s%s" "http://" .Values.ingress.api.hostName }}
{{- end }}
{{- else }}
{{- printf "%s%s%s%s" "http://" (include "clearml.fullname" .) "-apiserver:" (.Values.apiserver.service.port | toString) }}
{{- end }}
{{- end }}

{{/*
Create the name of the Files service to use
*/}}
{{- define "clearml.serviceFiles" -}}
{{- if .Values.ingress.enabled }}
{{- if .Values.ingress.files.tlsSecretName }}
{{- printf "%s%s" "https://" .Values.ingress.files.hostName }}
{{- else }}
{{- printf "%s%s" "http://" .Values.ingress.files.hostName }}
{{- end }}
{{- else }}
{{- printf "%s%s%s%s" "http://" (include "clearml.fullname" .) "-fileserver:" (.Values.fileserver.service.port | toString) }}
{{- end }}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "clearml.imagePullSecrets" -}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}
{{- end -}}

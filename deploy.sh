#!/bin/bash
# Deploy script for Job Cleaner

set -e

NAMESPACE="edygc1988-dev"
IMAGE_NAME="job-cleaner"
IMAGE_TAG="${1:-latest}"

echo "🚀 Iniciando deploy de Job Cleaner..."
echo "Namespace: $NAMESPACE"
echo "Image: $IMAGE_NAME:$IMAGE_TAG"

# Aplicar manifiestos
echo "📋 Aplicando manifiestos de Kubernetes..."
oc apply -f k8s/namespace.yaml
oc apply -f k8s/serviceaccount.yaml
oc apply -f k8s/clusterrole.yaml
oc apply -f k8s/clusterrolebinding.yaml
oc apply -f k8s/cronjob.yaml

echo "✅ Deploy completado!"
echo ""
echo "Comandos útiles:"
echo "  Ver CronJob:     oc get cronjob -n $NAMESPACE"
echo "  Ver Jobs:        oc get jobs -n $NAMESPACE"
echo "  Ver logs:        oc logs -n $NAMESPACE job/job-cleaner-<timestamp>"
echo "  Editar CronJob:  oc edit cronjob job-cleaner -n $NAMESPACE"

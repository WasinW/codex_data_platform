#!/bin/bash
set -e

echo "Initializing Terraform"
cd infrastructure/terraform
terraform init
terraform apply -auto-approve
cd ../../

echo "Building Airflow image"
(cd infrastructure/k8s && docker build -t airflow-gcloud:latest .)

echo "Applying Kubernetes manifests"
kubectl apply -f infrastructure/k8s/airflow.yaml

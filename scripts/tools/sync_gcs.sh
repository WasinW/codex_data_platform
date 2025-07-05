#!/bin/bash
set -e

BUCKET=$1
if [ -z "$BUCKET" ]; then
  echo "Usage: sync_gcs.sh <bucket-name>"
  exit 1
fi

# upload airflow scripts
gsutil -m rsync -r scripts/airflow/dag gs://$BUCKET/airflow/dag
gsutil -m rsync -r scripts/airflow/config gs://$BUCKET/airflow/config
# upload spark framework jar
gsutil -m cp scripts/fw/lib/output/framework.jar gs://$BUCKET/fw/lib/output/

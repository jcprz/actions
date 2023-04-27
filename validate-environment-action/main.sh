#!/bin/bash
ENV=$1
REPOSITORY_NAME=$2
CREATE_IF_NOT_EXISTS=$3

kubectl get namespace ${ENV}-apps || exit 1

if ! kubectl -n ${ENV}-apps get secret ${ENV}-${REPOSITORY_NAME}-scrts; then
  if [[ "${CREATE_IF_NOT_EXISTS}" == "true" ]]; then
    echo "Secret not found, creating..."
    kubectl -n ${ENV}-apps create secret generic ${ENV}-${REPOSITORY_NAME}-scrts --from-literal=EXAMPLE_KEY=EXAMPLE_VALUE
  else
    echo "Secret not found, failing the step"
    exit 1
  fi
fi

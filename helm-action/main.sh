#!/bin/bash
COMMAND=$1
ATOMIC_TIMEOUT=$2
REPOSITORY_NAME=$3
CHART_DIRECTORY=$4
ENV=$5
IMAGE_TAG=$6
DRY_RUN_OPTION=$7


if [ "${DRY_RUN_OPTION}" == "true" ]; then
  DRY_RUN_OPTION="--dry-run"
else
  DRY_RUN_OPTION=""
fi

case "${COMMAND}" in
  "dependency_update")
    echo "helm dependency update "${CHART_DIRECTORY}" ${DRY_RUN_OPTION}"
    ;;
  "lint")
    echo "helm lint --values "${CHART_DIRECTORY}/values-${ENV}.yaml" "${CHART_DIRECTORY}" ${DRY_RUN_OPTION}"
    ;;
  "upgrade")
    echo helm upgrade --install --atomic --timeout "${ATOMIC_TIMEOUT}" \
      --values "${CHART_DIRECTORY}/values-${ENV}.yaml" \
      --set-string image.tag="${IMAGE_TAG}" \
      --set-string env.ENV="${ENV}" \
      "${ENV}-${REPOSITORY_NAME}" \
      --namespace="${ENV}-apps" "${CHART_DIRECTORY}" ${DRY_RUN_OPTION}
    ;;
  *)
    echo "Invalid command: ${COMMAND}"
    exit 1
    ;;
esac

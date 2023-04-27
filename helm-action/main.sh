#!/bin/bash
COMMAND=$1
CHART_DIRECTORY=$2
ENV=$3
REPOSITORY_NAME=$4
GIT_SHORT_SHA=$5
ATOMIC_TIMEOUT=$6
DRY_RUN_OPTION=$7

if [ "${DRY_RUN_OPTION}" == "true" ]; then
  DRY_RUN_OPTION="--dry-run"
else
  DRY_RUN_OPTION=""
fi

case "${COMMAND}" in
  "dependency_update")
    helm dependency update "${CHART_DIRECTORY}" ${DRY_RUN_OPTION}
    ;;
  "lint")
    helm lint --values "${CHART_DIRECTORY}/values-${ENV}.yaml" "${CHART_DIRECTORY}" ${DRY_RUN_OPTION}
    ;;
  "upgrade")
    helm upgrade --install --atomic --timeout "${ATOMIC_TIMEOUT}" ${DRY_RUN_OPTION} \
      --values "${CHART_DIRECTORY}/values-${ENV}.yaml" \
      --set-string image.tag="${GIT_SHORT_SHA}" \
      --set-string env.ENV="${ENV}" \
      "${ENV}-${REPOSITORY_NAME}" \
      --namespace="${ENV}-apps" "${CHART_DIRECTORY}"
    ;;
  *)
    echo "Invalid command: ${COMMAND}"
    exit 1
    ;;
esac

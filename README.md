# Custom GitHub Actions

This repository contains custom GitHub Actions that can be used in your workflows. The actions included are:

1. [Validate Environment](#validate-environment)
2. [Generate Git Short SHA](#generate-git-short-sha)
3. [Helm Action](#helm-action)

## **Validate Environment**

This action validates the Kubernetes environment and optionally creates a Kubernetes secret if it doesn't exist.

### **Inputs**

- `env` - The environment to validate
- `repository_name` - The repository name
- `create_if_not_exists` - (Optional) If set to `true`, the action will create the Kubernetes secret if it doesn't exist. Default is `false`.

### **Usage**

```yaml
- name: Validate Environment
  uses: jcprz/actions/validate-environment@main
  with:
    env: ${{ env.ENV }}
    repository_name: ${{ env.REPOSITORY_NAME }}
    create_if_not_exists: false
```

## Generate Git Short SHA
This action generates a short Git SHA (8 characters) from the current commit.

### **Outputs**
- `git_short_sha` - The generated Git short SHA

```yaml
- name: Generate Git SHA
  id: git_sha
  uses: jcprz/actions/generate-git-sha@main

- name: Use Git SHA
  run: |
    echo "Generated Git SHA: ${{ steps.git_sha.outputs.git_short_sha }}"
```

## **Helm Action**
This custom action allows you to run Helm commands such as lint, dependency update, and upgrade.

### **Inputs**
- `command` - The Helm command to run (lint, dependency_update, or upgrade)
- `chart_path` - The path to the Helm chart directory
- `values_file` - The path to the Helm values file
- `release_name` - The Helm release name (required for upgrade command)
- `namespace` - The Kubernetes namespace (required for upgrade command)
- `image_tag` - The Docker image tag (required for upgrade command)
- `env` - The environment (required for upgrade command)
- `atomic_timeout` - (Optional) Timeout for Helm upgrade with --atomic flag. Default is 3m.

```yaml
- name: Helm Lint
  uses: jcprz/actions/helm-action@main
  with:
    command: lint
    chart_path: helm/${{ env.REPOSITORY_NAME }}
    values_file: helm/${{ env.REPOSITORY_NAME }}/values-${{ env.ENV }}.yaml

- name: Helm Dependency Update
  uses: jcprz/actions/helm-action@main
  with:
    command: dependency_update
    chart_path: helm/${{ env.REPOSITORY_NAME }}
    values_file: helm/${{ env.REPOSITORY_NAME }}/values-${{ env.ENV }}.yaml

- name: Helm Upgrade
  uses: jcprz/actions/helm-action@main
  with:
    command: upgrade
    chart_path: helm/${{ env.REPOSITORY_NAME }}
    values_file: helm/${{ env.REPOSITORY_NAME }}/values-${{ env.ENV }}.yaml
    release_name: ${{ env.REPOSITORY_NAME }}-${{ env.ENV }}
    namespace: ${{ env.ENV }}-apps
    image_tag: ${{ steps.git_sha.outputs.git_short_sha }}
    env: ${{ env.ENV }}
    atomic_timeout: 5m
```

# **Contributing**
If you would like to contribute to this repository, please submit a pull request with your proposed changes. Make sure to update the README to reflect any new actions or changes to existing actions.

# **License**
This project is licensed under the MIT License.
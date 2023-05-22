# Azure OIDC Integration with GitHub Actions via Terraform

This project creates an Azure Active Directory (Azure AD) service principal that has federated credentials (OIDC) with GitHub Actions. This allows the audience `api://AzureADTokenExchange` with issuer `https://token.actions.githubusercontent.com` and subject `repo:<your-org>/<your-repo>:environment:<github-action-environment-name>` to assume that Azure AD identity.

Due to Azure federated credentials not [supporting wildcards](https://stackoverflow.com/questions/71051432/github-actions-azure-oidc-with-subject-value-for-any-branch) in the subject, we must use the `environment` field in the GitHub Actions workflow.

```yaml
name: Run Azure Login with OIDC

on: workflow_dispatch

permissions:
  id-token: write
  contents: read
jobs:
  echo:
    runs-on: ubuntu-latest
    environment: <github-action-environment-name>
```

The Terraform script included in this project bootstraps an identity that's allowed to run the command `az account show` after successful OIDC authentication.

Beware that the `<github-action-environment-name>` must be updated in both the [GitHub Actions pipeline](./.github/workflows/release.yaml) and the [Terraform oidc config](./terraform/azure-oidc.tf).

## GitHub Actions Pipeline

The GitHub Actions pipeline is defined in `action.yaml`. The workflow runs on `workflow_dispatch` event and performs Azure login using OIDC.

The pipeline consists of two steps:

1. Azure CLI login
2. Running the Azure commands `az account show` and `az group list`.

Refer to `action.yaml` for complete pipeline configuration.

## Terraform Setup

The project uses Terraform to set up resources needed for the Azure AD and GitHub integration.

The Terraform scripts create an Azure AD application, service principal, sets up federated identity credentials and assigns the 'Reader' role to the service principal for the Azure subscription. It also sets up environment variables for the GitHub repository that corresponds to Azure credentials.

### Variables

The Terraform script uses the following variables:

- `principal_owner_id`: The object ID of the principal owner of the Azure AD application & service principal.
- `github_repository_name`: The name of the GitHub repository that this code is checked into.
- `gh_pat`: The GitHub personal access token (PAT) that has access to the GitHub repository.
- `arm_tenant_id`: Azure tenant ID.
- `arm_subscription_id`: Azure subscription ID.
- `arm_client_id`: Azure client ID.
- `arm_client_secret`: Azure client secret.

These variables can be defined in a separate `variables.auto.tfvars` file or directly in `variables.tf` as default variables.

### Providers

The Terraform script uses the following providers:

- Azure Active Directory Provider
- Azure Resource Manager Provider
- GitHub Provider

Refer to the [terraform folder](./terraform/) for complete Terraform configuration.

## Getting Started

1. Clone the repository

   ```
   git clone <repository_url>
   ```

2. Navigate to the project directory

   ```
   cd <project_directory>
   ```

3. Initialize Terraform

   ```
   terraform init
   ```

4. Apply the Terraform configuration

   ```
   terraform apply
   ```

5. Rebase the repository and push it to your own github org.

6. Run the [pipeline](./.github/workflows/release.yaml) and enjoy the results

## Gotchas

Note that the service principal used to configure the `azurerm` provider must have the [owner](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) role in order to assign the federated identity principal the `reader` scope in the `azurerm` provider subscription.

data "github_repository" "this" {
  name = var.github_repository_name
}

resource "github_actions_variable" "azure_tenant_id" {
  repository    = data.github_repository.this.name
  variable_name = "AZURE_TENANT_ID"
  value         = var.arm_tenant_id
}

resource "github_actions_variable" "azure_subscription_id" {
  repository    = data.github_repository.this.name
  variable_name = "AZURE_SUBSCRIPTION_ID"
  value         = var.arm_subscription_id
}

resource "github_actions_variable" "azure_client_id" {
  repository    = data.github_repository.this.name
  variable_name = "AZURE_CLIENT_ID"
  value         = azuread_application.this.application_id
}

resource "azuread_application" "this" {
  display_name = "github-actions-oidc"
  owners       = [var.principal_owner_id]
}

resource "azuread_service_principal" "this" {
  application_id               = azuread_application.this.application_id
  app_role_assignment_required = false
  owners                       = [var.principal_owner_id]
}

data "azurerm_subscription" "this" {}

resource "azurerm_role_assignment" "this" {
  scope                = data.azurerm_subscription.this.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.this.object_id
}

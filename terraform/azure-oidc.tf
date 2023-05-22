resource "azuread_application_federated_identity_credential" "this" {
  application_object_id = azuread_application.this.object_id
  display_name          = data.github_repository.this.name
  description           = "A demo OIDC integration between Github Actions and Azure AD"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  # subject = "repo:${data.github_repository.this.full_name}:*" //doesn't work
  # subject = "repo:${data.github_repository.this.full_name}:ref:refs/heads/master" //works.. but
  subject = "repo:${data.github_repository.this.full_name}:environment:azure"
}

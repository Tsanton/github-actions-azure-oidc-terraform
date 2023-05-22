variable "principal_owner_id" {
  type        = string
  description = "The object ID of the principal owner of the Azure AD application & service principal"
  default     = "e51916ae-0b2b-4fb0-9650-99a9adde633f" #t*****@t***t.no
}

variable "github_repository_name" {
  type        = string
  description = "The name of the GitHub repository that this code is checked into."
  default     = "github-actions-azure-oidc-terraform"
}

variable "gh_pat" {
  type        = string
  description = "The GitHub personal access token (PAT) that has access to the GitHub repository."
}

variable "arm_tenant_id" {
  type        = string
  description = "Azure tenant ID"
}

variable "arm_subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "arm_client_id" {
  type        = string
  description = "Azure client ID"
}

variable "arm_client_secret" {
  type        = string
  description = "Azure client secret"
}

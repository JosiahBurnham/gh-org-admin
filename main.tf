terraform {
    required_providers {
      github = {
        source = "integrations/github"
        version = "~> 5.0"
      }
    }
}

variable "gh_token" {
  type = string
  description = "GitHub Access Token"
}

provider "github" {
  token = var.gh_token
}

resource "github_repository" "test-terraform" {
  name = "test-terraform-repo"
  description = "this is a test repo for terraform"
}
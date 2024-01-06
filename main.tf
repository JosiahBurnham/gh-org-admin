terraform {
    required_providers {
      github = {
        source = "integrations/github"
        version = "~> 5.0"
      }
    }

    required_version = ">=0.14.9"

    backend "s3" {
      bucket = "jb-tf-statefile-backend"
      key = "gh-org-admin"
      region = "us-east-1"
    }

}

variable "gh_token" {
  type = string
  sensitive = true
  description = "GitHub Access Token"
}

provider "github" {
  token = var.gh_token
}

resource "github_repository" "test-terraform" {
  name = "test-terraform-repo"
  description = "this is a test repo for terraform"
}
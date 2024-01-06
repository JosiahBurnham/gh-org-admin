#----------------------------------------------------------
# File    : main.tf
# Author  : J.Burnham
# Purpose : Create terraform infra template repo
#----------------------------------------------------------

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


# Terraform Infra Template Repo
#----------------------------------------------------------

resource "github_repository" "infra_templaate" {
  name = "aws-infra-template-tf"
  description = "Template Repo for all Terraform Infrastructure Repositories"
  is_template = true
  delete_branch_on_merge = true
  auto_init = true
}

resource "github_branch_protection" "infra_template_barnch_protection" {
  repository_id = github_repository.infra_templaate
  pattern = "main"

  required_pull_request_reviews {
    require_code_owner_reviews = true
    required_approving_review_count = 1
    pull_request_bypassers = ["/JosiahBurnham"]
  }

}
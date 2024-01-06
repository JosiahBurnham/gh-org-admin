#==========================================================
# File    : main.tf
# Author  : J.Burnham
# Purpose : Create aws-app-name-tf
#==========================================================

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
      key = "aws-app-name-tf"
      region = "us-east-1"
    }

}

variable "gh_token" {
  type = string
  sensitive = true
  description = "GitHub Access Token"
}

variable "aws_role" {
  type = string
  sensitive = true
  description = "AWS Role to Assume"
}

provider "github" {
  token = var.gh_token
}


# Terraform Infra Template Repo
#----------------------------------------------------------

resource "github_repository" "infra_template" {
  name = "aws-app-name-tf"
  description = "Repo for App Name"
  is_template = false
  delete_branch_on_merge = true
  
  template {
    owner = "github"
    repository = "aws-infra-template-tf"
    include_all_branches = false
  }
}

resource "github_branch_protection" "infra_template_barnch_protection" {
  repository_id = github_repository.infra_template.name
  pattern = "master"

  required_pull_request_reviews {
    require_code_owner_reviews = true
    required_approving_review_count = 1
    pull_request_bypassers = ["/JosiahBurnham"]
    require_last_push_approval = true
  }

}

resource "github_actions_secret" "dev_assume_role" {
  repository = github_repository.infra_template.name
  secret_name = "DEV_ASSUME_ROLE"
  plaintext_value = var.aws_role
}

resource "github_actions_secret" "stage_assume_role" {
  repository = github_repository.infra_template.name
  secret_name = "STAGE_ASSUME_ROLE"
  plaintext_value = var.aws_role
}

resource "github_actions_secret" "prod_assume_role" {
  repository = github_repository.infra_template.name
  secret_name = "PROD_ASSUME_ROLE"
  plaintext_value = var.aws_role
}

resource "github_actions_secret" "gh_token_secret" {
  repository = github_repository.infra_template.name
  secret_name = "GH_PAT_TOKEN"
  plaintext_value = var.gh_token
}
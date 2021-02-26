terraform {
  # Require Terraform version 0.13.x (recommended)
  required_version = "~> 0.14.0"

  # Require the latest 2.x version of the New Relic provider
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.12"
    }
  }
}

provider "newrelic" {
  account_id = var.account_id 
  api_key = var.api_key 
  region = var.region        
}

# Creates the alert policies and subscribe channels
module "AlertPolicies" {
  source = "./modules/AlertPolicies"
  channelId = var.channel_id
}

# Creates the infra alerts
module "HostConditions" {
  source = "./modules/HostConditions"
  #source = "git::https://github.com/username/repo.git" #you can also specify a module from Git etc
  policyId = module.AlertPolicies.policyId
}



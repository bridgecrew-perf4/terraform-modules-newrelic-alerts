variable "channelId" {}

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

# Create an alert policy
resource "newrelic_alert_policy" "host_alerts_policy" {
  name = "Host Alerts"
}

# Subscribe alert policy to notification channel(s)
resource "newrelic_alert_policy_channel" "ChannelSubs" {
  policy_id = newrelic_alert_policy.host_alerts_policy.id
  channel_ids = [
    var.channelId
  ]
}

output "policyId" {
  value = newrelic_alert_policy.host_alerts_policy.id
}
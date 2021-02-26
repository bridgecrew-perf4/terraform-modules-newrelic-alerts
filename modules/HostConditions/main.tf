variable "policyId" {}

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

/*
# APM Response time
resource "newrelic_alert_condition" "response_time_web" {
  policy_id       = newrelic_alert_policy.host_alerts_policy.id
  name            = "High Response Time (Web) - ${data.newrelic_entity.app_name.name}"
  type            = "apm_app_metric"
  entities        = [data.newrelic_entity.todo_app.application_id]
  metric          = "response_time_web"
  condition_scope = "application"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "5"
    time_function = "all"
  }
}
*/

/*
# APM Low throughput
resource "newrelic_alert_condition" "throughput_web" {
  policy_id       = newrelic_alert_policy.host_alerts_policy.id
  name            = "High Throughput (Web)"
  type            = "apm_app_metric"
  entities        = [data.newrelic_entity.todo_app.application_id]
  metric          = "throughput_web"
  condition_scope = "application"

  # Define a critical alert threshold that will
  # trigger after 5 minutes above 10 requests per minute.
  term {
    priority      = "critical"
    duration      = 5
    operator      = "above"
    threshold     = "10"
    time_function = "all"
  }
}
*/

/*
# APM Error percentage
resource "newrelic_alert_condition" "error_percentage" {
  policy_id       = newrelic_alert_policy.host_alerts_policy.id
  name            = "High Error Percentage"
  type            = "apm_app_metric"
  entities        = [data.newrelic_entity.app_name.application_id]
  metric          = "error_percentage"
  condition_scope = "application"

  # Define a critical alert threshold that will trigger after 5 minutes above a 10% error rate.
  term {
    duration      = 5
    operator      = "above"
    threshold     = "10"
    time_function = "all"
  }
}
*/

/*
# Infra High CPU usage
resource "newrelic_infra_alert_condition" "high_cpu" {
  policy_id   = newrelic_alert_policy.host_alerts_policy.id
  name        = "High CPU usage"
  type        = "infra_metric"
  event       = "SystemSample"
  select      = "cpuPercent"
  comparison  = "above"
  where       = "(`applicationId` = '${data.newrelic_entity.app_name.application_id}')"

  # Define a critical alert threshold that will trigger after 5 minutes above 50% CPU utilization.
  critical {
    duration      = 5
    value         = 50
    time_function = "all"
  }
}
*/

# Infra High CPU usage (metric)
resource "newrelic_infra_alert_condition" "high_cpu" {
  policy_id   = var.policyId
  name        = "High CPU usage"
  type        = "infra_metric"
  event       = "SystemSample"
  select      = "cpuPercent"
  comparison  = "above"
  where       = "(owner = 'tab')"

  # Define a critical alert threshold
  critical {
    duration      = 60
    value         = 95
    time_function = "all"
  }
}

# Infra High Memory usage (metric)
resource "newrelic_infra_alert_condition" "high_mem" {
  policy_id   = var.policyId
  name        = "Low Memory available"
  type        = "infra_metric"
  event       = "SystemSample"
  select      = "memoryFreePercent"
  comparison  = "below"
  where       = "(owner = 'tab')"

  # Define a critical alert threshold
  critical {
    duration      = 30
    value         = 10
    time_function = "all"
  }
}

# Infra High CPU usage (nrql)
resource "newrelic_nrql_alert_condition" "high_cpu_usage" {
  policy_id                    = var.policyId
  type                         = "static"
  name                         = "High CPU usage"
  description                  = "Alert when CPU above 95%"
  enabled                      = true
  violation_time_limit_seconds = 3600
  value_function               = "single_value"

  fill_option          = "static"
  fill_value           = 1.0

  aggregation_window             = 60
  expiration_duration            = 120
  open_violation_on_expiration   = true
  close_violations_on_expiration = true

  nrql {
    query             = "SELECT average(cpuPercent) FROM SystemSample WHERE owner = 'tab' facet hostname"
    evaluation_offset = 3
  }

  critical {
    operator              = "above"
    threshold             = 95
    threshold_duration    = 3600
    threshold_occurrences = "ALL"
  }
}

# Infra High Memory usage (nrql)
resource "newrelic_nrql_alert_condition" "high_mem_usage" {
  policy_id                    = var.policyId
  type                         = "static"
  name                         = "High Memory usage"
  description                  = "Alert when memory usage exceeds 90%"
  enabled                      = true
  violation_time_limit_seconds = 3600
  value_function               = "single_value"

  fill_option          = "static"
  fill_value           = 1.0

  aggregation_window             = 60
  expiration_duration            = 120
  open_violation_on_expiration   = true
  close_violations_on_expiration = true

  nrql {
    query             = "SELECT average(memoryUsedPercent) FROM SystemSample WHERE owner = 'tab' facet hostname"
    evaluation_offset = 3
  }

  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 1800
    threshold_occurrences = "ALL"
  }
}

# Infra High Disk Space Usage (nrql)
resource "newrelic_nrql_alert_condition" "high_disk_usage" {
  policy_id                    = var.policyId
  type                         = "static"
  name                         = "High Disk Space usage"
  description                  = "Alert when disk space usage exceeds 80%"
  enabled                      = true
  violation_time_limit_seconds = 3600
  value_function               = "single_value"

  fill_option          = "static"
  fill_value           = 1.0

  aggregation_window             = 60
  expiration_duration            = 120
  open_violation_on_expiration   = true
  close_violations_on_expiration = true

  nrql {
    query             = "SELECT average(diskUsedPercent) FROM SystemSample WHERE owner = 'tab' facet hostname"
    evaluation_offset = 3
  }

  critical {
    operator              = "above"
    threshold             = 80
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
}

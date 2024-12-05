# Terraform module for budget consumption monitoring in Azure

Terraform module to create consumption budget with alerting in Azure.  
Module has following features:  

- Create consumption budget (in local currency).  
- Create alert rule on budget consumption threshold with email notification.  
- Create alert with email notification when budget consumption anomaly is detected.  


## Usage

Refer to [examples](./examples/) for usage of module.

<!-- Below is a placeholder for Terraform-docs generated documentation. Do not edit between the delimiters. -->  
<!-- BEGIN_TF_DOCS -->



```hcl
locals {
  # all values of notification maps are optional, these will be used when nothing is specified
  default_notification_settings = {
    enabled        = true
    threshold      = 80.0
    operator       = "GreaterThan"
    contact_emails = []
  }
}

data "azurerm_subscription" "current" {}

resource "azurerm_consumption_budget_subscription" "sub_budget_consumption" {
  amount          = var.consumption_budget_amount
  name            = "budget-${var.subscription}-${var.app_short_name}-${var.environment}"
  subscription_id = data.azurerm_subscription.current.id
  time_grain      = var.consumption_budget_time_grain

  dynamic "notification" {
    for_each = var.consumption_budget_notification_cfg

    content {
      operator       = coalesce(notification.value.operator, local.default_notification_settings.operator)
      threshold      = coalesce(notification.value.threshold, local.default_notification_settings.threshold)
      contact_emails = coalesce(notification.value.contact_emails, local.default_notification_settings.contact_emails)
      enabled        = coalesce(notification.value.enabled, local.default_notification_settings.enabled)
    }
  }
  time_period {
    # first day of current month, ignore_changes lifecycle to avoid drift
    start_date = formatdate("YYYY-MM-01'T'hh:mm:ssZ", timestamp())
    # end_date # not set means 10 years after start date
  }

  lifecycle {
    ignore_changes = [
      time_period
    ]
  }

  # tags not supported
}

moved {
  from = azurerm_cost_anomaly_alert.sub_cost_anomaly_alert
  to   = azurerm_cost_anomaly_alert.sub_cost_anomaly_alert[0]
}

resource "azurerm_cost_anomaly_alert" "sub_cost_anomaly_alert" {
  count = try(length(var.cost_anomaly_alert_email_receivers), 0) > 0 ? 1 : 0

  display_name    = "Cost Anomaly Alert for subscription: ${var.subscription}"
  email_addresses = var.cost_anomaly_alert_email_receivers
  email_subject   = "Cost Anomaly detected in subscription: ${var.subscription}"
  name            = "cost-anomaly-alert-${var.subscription}-${var.app_short_name}-${var.environment}"
  subscription_id = data.azurerm_subscription.current.id

  # tags not supported
}
```
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_consumption_budget_id"></a> [consumption\_budget\_id](#output\_consumption\_budget\_id) | value of the consumption budget id |
| <a name="output_cost_anomaly_alert_id"></a> [cost\_anomaly\_alert\_id](#output\_cost\_anomaly\_alert\_id) | value of the cost anomaly alert id |
<!-- END_TF_DOCS -->

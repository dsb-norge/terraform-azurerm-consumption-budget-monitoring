locals {
  # all values of notification maps are optional, these will be used when nothing is specified
  default_notification_settings = {
    enabled        = true
    threshold      = 80.0
    operator       = "GreaterThan"
    contact_emails = []
  }

  # Azure rejects a cost anomaly alert (a scheduled action) whose name is over 50 characters
  # (InvalidName). A name that fits is kept, so an existing alert is not replaced; a longer one is cut
  # and ends in a hash of the whole name, which keeps it unique per subscription, app and environment.
  cost_anomaly_alert_name_full = "cost-anomaly-alert-${var.subscription}-${var.app_short_name}-${var.environment}"
  cost_anomaly_alert_name = (
    length(local.cost_anomaly_alert_name_full) <= 50
    ? local.cost_anomaly_alert_name_full
    : "${trimsuffix(substr(local.cost_anomaly_alert_name_full, 0, 41), "-")}-${substr(sha1(local.cost_anomaly_alert_name_full), 0, 8)}"
  )

  create_cost_anomaly_alert = try(length(var.cost_anomaly_alert_email_receivers), 0) > 0
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

# Azure ends a cost anomaly alert's schedule a year after the alert was created or last updated (azurerm sets the
# end date on every write), and Terraform does not track the dates, so an alert nothing changes stops sending after
# a year without any drift to show. The timer's time is in the alert's message: when the timer rotates, 330 days on,
# the message changes and the update renews the alert in place, a month before it would end. replace_triggered_by
# on the timer does not work: an expired timer is planned as a create, which triggers nothing. The message holds the
# month and year, never a full date: Azure refuses a message it takes for a phone number or an email address
# (InvalidScheduledActionFieldContainsPii), as it did "2026-10-06".
resource "time_rotating" "cost_anomaly_alert_renewal" {
  count = local.create_cost_anomaly_alert ? 1 : 0

  rotation_days = 330
}

resource "azurerm_cost_anomaly_alert" "sub_cost_anomaly_alert" {
  count = local.create_cost_anomaly_alert ? 1 : 0

  display_name    = "Cost Anomaly Alert"
  email_addresses = var.cost_anomaly_alert_email_receivers
  email_subject   = "Cost Anomaly detected in one of subscriptions"
  name            = local.cost_anomaly_alert_name
  message         = "Managed by Terraform and renewed yearly; last renewed in ${formatdate("MMMM YYYY", time_rotating.cost_anomaly_alert_renewal[count.index].rfc3339)}."
  subscription_id = data.azurerm_subscription.current.id

  # tags not supported
}

mock_provider "azurerm" {
  override_data {
    target = data.azurerm_subscription.current
    values = {
      id = "/subscriptions/12345678-1234-9876-4563-123456789012"
    }
  }
}

run "consuption_budget_amount_can_not_be_0" {
  command = plan

  variables {
    consumption_budget_amount = 0
  }

  #verify that amount can not be 0
  expect_failures = [
    var.consumption_budget_amount,
  ]
}


run "consuption_time_grain_not_allowed_value" {
  command = plan

  # verify that not allowed value is not allowed   
  variables {
    consumption_budget_time_grain = "NotAllowed"
  }

  expect_failures = [
    var.consumption_budget_time_grain,
  ]
}


run "consumption_budget_time_grain_default_value" {
  command = plan

  #verify that time grain default value is set to Monthly
  assert {
    error_message = "Default value for consumption_budget_time_grain expected to be Monthly"
    condition     = azurerm_consumption_budget_subscription.sub_budget_consumption.time_grain == "Monthly"
  }

}

run "consumption_budget_timegrain_billingannual_allowed" {
  command = plan

  #verify that time grain can be set to BillingAnnual
  variables {
    consumption_budget_time_grain = "BillingAnnual"
  }

  assert {
    error_message = "BillingAnnual is a valid value for consumption_budget_time_grain"
    condition     = azurerm_consumption_budget_subscription.sub_budget_consumption.time_grain == "BillingAnnual"
  }

}

run "consumption_budget_timegrain_billingmonth_allowed" {
  command = plan

  #verify that time grain can be set to BillingMonth
  variables {
    consumption_budget_time_grain = "BillingMonth"
  }

  assert {
    error_message = "BillingMonth is a valid value for consumption_budget_time_grain"
    condition     = azurerm_consumption_budget_subscription.sub_budget_consumption.time_grain == "BillingMonth"
  }

}

run "consumption_budget_timegrain_billingquarter_allowed" {
  command = plan

  #verify that time grain can be set to BillingQuarter
  variables {
    consumption_budget_time_grain = "BillingQuarter"
  }

  assert {
    error_message = "BillingQuarter is a valid value for consumption_budget_time_grain"
    condition     = azurerm_consumption_budget_subscription.sub_budget_consumption.time_grain == "BillingQuarter"
  }

}

run "consumption_budget_timegrain_annually_allowed" {
  command = plan

  #verify that time grain can be set to Annually
  variables {
    consumption_budget_time_grain = "Annually"
  }

  assert {
    error_message = "Annually is a valid value for consumption_budget_time_grain"
    condition     = azurerm_consumption_budget_subscription.sub_budget_consumption.time_grain == "Annually"
  }

}

run "consumption_budget_timegrain_quarterly_allowed" {
  command = plan

  #verify that time grain can be set to Quarterly
  variables {
    consumption_budget_time_grain = "Quarterly"
  }

  assert {
    error_message = "Quarterly is a valid value for consumption_budget_time_grain"
    condition     = azurerm_consumption_budget_subscription.sub_budget_consumption.time_grain == "Quarterly"
  }

}

run "consumption_budget_notification_default_disabled" {
  command = plan

  assert {
    error_message = "Default value for enabled in consumption_budget_notification_cfg expected to be false"
    condition     = alltrue([for k, v in azurerm_consumption_budget_subscription.sub_budget_consumption.notification : v.enabled == false])
  }
}

run "cost_anomaly_alert_default_not_created" {
  command = plan

  assert {
    error_message = "Cost anomaly alert should not be created if no email receivers are specified"
    condition     = length(azurerm_cost_anomaly_alert.sub_cost_anomaly_alert) == 0
  }
}

run "cost_anomaly_alert_created_with_email_receivers" {
  command = plan

  variables {
    cost_anomaly_alert_email_receivers = ["ole.bole@domain.com"]
  }

  assert {
    error_message = "Cost anomaly alert should be created if email receivers are specified"
    condition     = length(azurerm_cost_anomaly_alert.sub_cost_anomaly_alert) == 1
  }
}

run "cost_anomaly_alert_name_correct" {
  command = plan

  variables {
    cost_anomaly_alert_email_receivers = ["ole.bole@domain.com"]
  }

  assert {
    condition     = azurerm_cost_anomaly_alert.sub_cost_anomaly_alert[0].name == var._test_expected_attributes.cost_anomaly_alert_name
    error_message = "Cost anomaly alert name is not correct"
  }

  assert {
    condition     = length(azurerm_cost_anomaly_alert.sub_cost_anomaly_alert[0].name) <= 50
    error_message = "Cost anomaly alert name is longer than the 50 characters Azure accepts"
  }
}

run "cost_anomaly_alert_name_that_fits_is_kept" {
  command = plan

  variables {
    cost_anomaly_alert_email_receivers = ["ole.bole@domain.com"]
    subscription                       = "subscription-test"
    app_short_name                     = "app"
    environment                        = "dev-tests"
  }

  assert {
    condition     = azurerm_cost_anomaly_alert.sub_cost_anomaly_alert[0].name == "cost-anomaly-alert-subscription-test-app-dev-tests"
    error_message = "A cost anomaly alert name of 50 characters or fewer must be kept as it is, or existing alerts are replaced"
  }
}

run "cost_anomaly_alert_name_cut_at_a_hyphen" {
  command = plan

  variables {
    cost_anomaly_alert_email_receivers = ["ole.bole@domain.com"]
    subscription                       = "subscription-test-nam"
  }

  assert {
    condition     = azurerm_cost_anomaly_alert.sub_cost_anomaly_alert[0].name == "cost-anomaly-alert-subscription-test-nam-a92ce1aa"
    error_message = "A name cut where a hyphen follows must not carry two hyphens before its hash"
  }
}

run "cost_anomaly_alert_email_receivers_validation" {
  command = plan

  variables {
    cost_anomaly_alert_email_receivers = ["wrong@emailadress", "secondadress@", "valid@email.com"]
  }

  # verify that email receivers are valid email addresses
  expect_failures = [
    var.cost_anomaly_alert_email_receivers,
  ]

}

run "cost_anomaly_alert_email_receivers_at_most_five" {
  command = plan

  variables {
    cost_anomaly_alert_email_receivers = ["a@domain.com", "b@domain.com", "c@domain.com", "d@domain.com", "e@domain.com", "f@domain.com"]
  }

  # verify that a sixth receiver, which Azure refuses, fails the plan
  expect_failures = [
    var.cost_anomaly_alert_email_receivers,
  ]
}

run "cost_anomaly_alert_email_receivers_five_allowed" {
  command = plan

  variables {
    cost_anomaly_alert_email_receivers = ["a@domain.com", "b@domain.com", "c@domain.com", "d@domain.com", "e@domain.com"]
  }

  assert {
    condition     = length(azurerm_cost_anomaly_alert.sub_cost_anomaly_alert[0].email_addresses) == 5
    error_message = "Five receivers, Azure's limit, must be accepted"
  }
}

run "it_should_output_resource_id_for_budget" {
  command = apply

  variables {
    consumption_budget_notification_cfg = {
      "80_percent_consumed" = {
        contact_emails = ["vaild.dummy@epost.her"]
      }
    }
  }

  assert {
    condition     = length(output.consumption_budget_id) > 0
    error_message = "Consumption budget id outpout is missing"
  }
}

run "it_should_output_resource_id_for_cost_anomaly_alert" {
  command = apply

  variables {
    cost_anomaly_alert_email_receivers = ["vaild.dummy@epost.her"]
  }

  assert {
    condition     = length(output.cost_anomaly_alert_id) > 0
    error_message = "Cost anomaly alert id outpout is missing"
  }
}

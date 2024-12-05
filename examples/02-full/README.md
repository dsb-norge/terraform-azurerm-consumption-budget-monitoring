# Full example
<!-- BEGIN_TF_DOCS -->



```hcl
provider "azurerm" {
  features {}
}

module "consumption_budget" {
  source = "../../"

  app_short_name            = "my-budget-full"
  subscription              = "sub-name"
  environment               = "prod"
  consumption_budget_amount = 9000 # in local currency of subscription location
  consumption_budget_notification_cfg = {
    "80_percent_consumed" = {
      contact_emails = ["vaild.dummy@epost.her"]
    }
    "100_precent_consumed" = {
      threshold = 100.0
      contact_emails = [
        "valid.first@epost.her",
        "valid.second@epost.her"
      ]
    }
  }

  cost_anomaly_alert_email_receivers = ["vaild.dummy@epost.her"]
}

```
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_consumption_budget_id"></a> [consumption\_budget\_id](#output\_consumption\_budget\_id) | The consumption budget id |
| <a name="output_cost_anomaly_alert_id"></a> [cost\_anomaly\_alert\_id](#output\_cost\_anomaly\_alert\_id) | The cost anomaly alert id |
<!-- END_TF_DOCS -->
<!-- BEGIN_TF_DOCS -->
# Complete example of Azure consumption budget monitoring  

The example below shows how to create and monitor Azure consumption budget with additional cost anomaly detection alert.  

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

<!-- markdownlint-disable MD033 -->
## Requirements

No requirements.

## Resources

No resources.

<!-- markdownlint-disable MD013 -->
## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_consumption_budget_id"></a> [consumption\_budget\_id](#output\_consumption\_budget\_id) | The consumption budget id |
| <a name="output_cost_anomaly_alert_id"></a> [cost\_anomaly\_alert\_id](#output\_cost\_anomaly\_alert\_id) | The cost anomaly alert id |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_consumption_budget"></a> [consumption\_budget](#module\_consumption\_budget) | ../../ | n/a |

<!-- END_TF_DOCS -->
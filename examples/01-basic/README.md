<!-- BEGIN_TF_DOCS -->
# Basic example for the Azure budget consumption module.

The example below shows how to create and monitor Azure consumption budget.  

```hcl
provider "azurerm" {
  features {}
}

module "consumption_budget" {
  source = "../../"

  app_short_name            = "my-budget-basic"
  subscription              = "sub-name"
  environment               = "prod"
  consumption_budget_amount = 9000 # in local currency of subscription location
  consumption_budget_notification_cfg = {
    "80_percent_consumed" = {
      contact_emails = ["vaild.dummy@epost.her"]
    }
  }
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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_consumption_budget"></a> [consumption\_budget](#module\_consumption\_budget) | ../../ | n/a |

<!-- END_TF_DOCS -->
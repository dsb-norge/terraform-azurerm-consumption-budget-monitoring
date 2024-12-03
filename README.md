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
<!-- markdownlint-disable MD033 -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0, < 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0.0, < 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_consumption_budget_subscription.sub_budget_consumption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_subscription) | resource |
| [azurerm_cost_anomaly_alert.sub_cost_anomaly_alert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cost_anomaly_alert) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

<!-- markdownlint-disable MD013 -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_short_name"></a> [app\_short\_name](#input\_app\_short\_name) | Name of app short, used for rg | `string` | n/a | yes |
| <a name="input_consumption_budget_amount"></a> [consumption\_budget\_amount](#input\_consumption\_budget\_amount) | The amount of money to be consumed | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The runtime environment targeted. Development, test, qa, production etc | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription | `string` | n/a | yes |
| <a name="input_consumption_budget_notification_cfg"></a> [consumption\_budget\_notification\_cfg](#input\_consumption\_budget\_notification\_cfg) | The notification blocks | <pre>map(object({<br/>    enabled        = optional(bool)<br/>    threshold      = optional(number)<br/>    operator       = optional(string)<br/>    contact_emails = optional(list(string))<br/>  }))</pre> | <pre>{<br/>  "notification1": {<br/>    "enabled": false<br/>  }<br/>}</pre> | no |
| <a name="input_consumption_budget_time_grain"></a> [consumption\_budget\_time\_grain](#input\_consumption\_budget\_time\_grain) | The time grain for the consumption budget | `string` | `"Monthly"` | no |
| <a name="input_cost_anomaly_alert_email_receivers"></a> [cost\_anomaly\_alert\_email\_receivers](#input\_cost\_anomaly\_alert\_email\_receivers) | The email addresses to receive cost anomaly alerts | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_consumption_budget_id"></a> [consumption\_budget\_id](#output\_consumption\_budget\_id) | value of the consumption budget id |
| <a name="output_cost_anomaly_alert_id"></a> [cost\_anomaly\_alert\_id](#output\_cost\_anomaly\_alert\_id) | value of the cost anomaly alert id |

## Modules

No modules.
<!-- END_TF_DOCS -->

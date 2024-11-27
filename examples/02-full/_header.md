# Azure consumption budget and it's monitoring module.  

Terraform module to create consumption budget with alerting rules in Azure.  

## Features  

This module supports creating budget on Azure subscription and monitor it's consumption.  

The module support:  

- Creating a budget on Azure subscription in local currency with adjustable time grain.
- Creating notification alerts based on consumption. 
- Creating cost anomaly alerts.  

## Usage

To use this module in your Terraform configuration, you'll need to provide values for the required variables.  

### Example - Consumption budget with alert on 80% budget utilization and anomaly alert

```terraform  
module "consumption_budget" {
  source = "dsb-norge/consumption-budget-monitoring/azurerm"

  app_short_name            = "my-budget-basic"
  subscription              = "sub-name"
  environment               = "prod"
  consumption_budget_amount = 9000 # in local currency of subscription location
  consumption_budget_notification_cfg = {
    "80_percent_consumed" = {
      contact_emails = ["emaily@mail.here"]
    }
  }

  cost_anomaly_alert_email_receivers = ["email@mail.here"]
}  
```  

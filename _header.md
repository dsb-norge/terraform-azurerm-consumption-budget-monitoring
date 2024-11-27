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
Check [examples](./examples/) for details.  

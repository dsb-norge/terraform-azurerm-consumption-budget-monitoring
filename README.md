# Terraform module for budget consumption monitoring in Azure

Terraform module to create consumption budget with alerting in Azure.  
Module has following features:  

- Create consumption budget (in local currency).  
- Create alert rule on budget consumption threshold with email notification.  
- Create alert with email notification when budget consumption anomaly is detected.  


## Usage

### Basic example

Example with minimum set of input parameters.

```terraform
provider "azurerm" {
  features {}
}
module "consumption_budget" {
  source = "git@github.com:dsb-norge/tf-mod-azure-consumption-budget-monitoring.git?ref=v0"

  app_short_name                      = "my-azure-app"
  subscription                        = "my-subscription-name"
  environment                         = "production"
  consumption_budget_amount           = "9000" # in local currency of subscription location
}
```

### Full example

Example with all possible set of input parameters.

```terraform
provider "azurerm" {
  features {}
}
module "consumption_budget" {
  source = "git@github.com:dsb-norge/tf-mod-azure-consumption-budget-monitoring.git?ref=v0"

  app_short_name                      = "my-azure-app"
  subscription                        = "my-subscription-name"
  environment                         = "production"
  consumption_budget_amount           = "9000" # in local currency of subscription location
  consumption_budget_time_grain       = "Monthly"
  consumption_budget_notification_cfg = {
    "80_percent_consumed" = {
      contact_emails = [
        "some@email.internal",
        "some.other@email.internal",
      ]
    }
  }

  cost_anomaly_alert_email_receivers = [
    "some@email.internal",
    "some.other@email.internal",
  ]
}
```

## Development

### Validate your code

```shell
  # Init project, run fmt and validate
  terraform init -reconfigure
  terraform fmt -check -recursive
  terraform validate

  # Lint with TFLint, calling script from https://github.com/dsb-norge/terraform-tflint-wrappers
  alias lint='curl -s https://raw.githubusercontent.com/dsb-norge/terraform-tflint-wrappers/main/tflint_linux.sh | bash -s --'
  lint

```

### Generate and inject terraform-docs in README.md

```shell
# go1.17+
go install github.com/terraform-docs/terraform-docs@v0.18.0
export PATH=$PATH:$(go env GOPATH)/bin
terraform-docs markdown table --output-file README.md .
```

### Release

After merge of PR to main use tags to release.

Use semantic versioning, see [semver.org](https://semver.org/). Always push tags and add tag annotations.

#### Patch release

Example of patch release `v0.0.4`:

```bash
git checkout origin/main
git pull origin main
git tag --sort=-creatordate | head -n 5 # review latest release tag to determine which is the next one
git log v0..HEAD --pretty=format:"%s"   # output changes since last release
git tag -a 'v0.0.4'  # add patch tag, add change description
git tag -f -a 'v0.0' # move the minor tag, amend the change description
git tag -f -a 'v0'   # move the major tag, amend the change description
git push origin 'refs/tags/v0.0.4'  # push the new tag
git push -f origin 'refs/tags/v0.0' # force push moved tags
git push -f origin 'refs/tags/v0'   # force push moved tags
```

#### Major release

Same as patch release except that the major version tag is a new one. I.e. we do not need to force tag/push.

Example of major release `v1.0.0`:

```bash
git checkout origin/main
git pull origin main
git tag --sort=-creatordate | head -n 5 # review latest release tag to determine which is the next one
git log v0..HEAD --pretty=format:"%s"   # output changes since last release
git tag -a 'v1.0.0'  # add patch tag, add your change description
git tag -a 'v1.0'    # add minor tag, add your change description
git tag -a 'v0'      # add major tag, add your change description
git push --tags      # push the new tags
```

**Note:** If you are having problems pulling main after a release, try to force fetch the tags: `git fetch --tags -f`.

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

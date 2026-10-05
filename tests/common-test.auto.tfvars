# Input vars for tests

consumption_budget_amount = 5000
app_short_name            = "my-azure-app"
subscription              = "subscription-test-name"
environment               = "prod"

_test_expected_attributes = {
  # The whole name, cost-anomaly-alert-subscription-test-name-my-azure-app-prod, is 59 characters,
  # past Azure's 50: it is cut and ends in a hash of itself.
  cost_anomaly_alert_name = "cost-anomaly-alert-subscription-test-name-4bb55551"
}
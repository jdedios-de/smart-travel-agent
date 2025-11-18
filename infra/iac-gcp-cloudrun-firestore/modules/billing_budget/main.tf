resource "google_billing_budget" "budget" {
  billing_account = var.billing_account_id
  display_name    = "Example Billing Budget"

  amount {
    specified_amount {
      currency_code = "EUR"
      units         = "10"
    }
  }

  threshold_rules {
    threshold_percent = 1.0
  }
  threshold_rules {
    threshold_percent = 1.0
    spend_basis       = "FORECASTED_SPEND"
  }

  all_updates_rule {
    monitoring_notification_channels = [
      google_monitoring_notification_channel.notification_channel.id,
    ]
    disable_default_iam_recipients = true
  }
}

resource "google_monitoring_notification_channel" "notification_channel" {
  display_name = "${var.prefix} Notification Channel"
  type         = "email"

  labels = {
    email_address = var.billing_email_address
  }
}

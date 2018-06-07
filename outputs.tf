output "version" {
  description = "Slack slash command module version"
  value       = "${local.version}"
}

output "request_url" {
  description = "Slack slash command Request URL."
  value       = "${google_cloudfunctions_function.function.https_trigger_url}"
}

// Slack
variable "web_api_token" {
  description = "Slack Web API token."
}

variable "verification_token" {
  description = "Slack verification token."
}

// Cloud Storage
variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "bucket_prefix" {
  description = "Prefix for Cloud Storage bucket."
  default     = ""
}

// Cloud Function
variable "function_name" {
  description = "Cloud Function for publishing events from Slack to Pub/Sub."
}

variable "memory" {
  description = "Memory for Slack event listener."
  default     = 512
}

variable "timeout" {
  description = "Timeout in seconds for Slack event listener."
  default     = 10
}

variable "response" {
  description = "Slack response object."
  type        = "map"

  default {
    text = "OK"
  }
}

variable "response_type" {
  description = "Response type of command."
  default     = "direct"
}

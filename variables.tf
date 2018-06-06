variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "function_name" {
  description = "Cloud Function for publishing events from Slack to Pub/Sub."
}

variable "verification_token" {
  description = "Slack verification token."
}

variable "bucket_prefix" {
  description = "Prefix for Cloud Storage bucket."
  default     = ""
}

variable "memory" {
  description = "Memory for Slack event listener."
  default     = 128
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

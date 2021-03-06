// Google Cloud
variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

// Slack
variable "web_api_token" {
  description = "Slack Web API token."
}

variable "verification_token" {
  description = "Slack verification token."
}

// Cloud Function
variable "description" {
  description = "Description of the function."
  default     = "Slack slash command"
}

variable "function_name" {
  description = "Cloud Function for publishing events from Slack to Pub/Sub."
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the function."
  type        = "map"

  default {
    deployment-tool = "terraform"
  }
}

variable "memory" {
  description = "Memory for Slack event listener."
  default     = 512
}

variable "timeout" {
  description = "Timeout in seconds for Slack event listener."
  default     = 10
}

// App
variable "auth_channels_exclude" {
  description = "Optional list of Slack channel IDs to blacklist."
  type        = "list"
  default     = []
}

variable "auth_channels_include" {
  description = "Optional list of Slack channel IDs to whitelist."
  type        = "list"
  default     = []
}

variable "auth_channels_permission_denied" {
  description = "Permission denied message for channels."
  type        = "map"

  default {
    text = "Sorry, you can't do that in this channel."
  }
}

variable "auth_users_exclude" {
  description = "Optional list of Slack user IDs to blacklist."
  type        = "list"
  default     = []
}

variable "auth_users_include" {
  description = "Optional list of Slack user IDs to whitelist."
  type        = "list"
  default     = []
}

variable "auth_users_permission_denied" {
  description = "Permission denied message for users."
  type        = "map"

  default {
    text = "Sorry, you don't have permission to do that."
  }
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

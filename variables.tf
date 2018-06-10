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

// App
/*
variable "auth" {
  description = "Model for limiting authorization to slash command"
  type        = "map"

  default {

    channels {
      message = "Sorry, you aren't allowed to do that in this channel."
      include = []
      exclude = []
    }

    users {
      message = "Sorry, you don't have permission to do that."
      exclude = []
      include = []
    }
  }
}
*/
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

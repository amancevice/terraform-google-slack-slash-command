provider "archive" {
  version = "~> 1.0"
}

provider "template" {
  version = "~> 1.0"
}

locals {
  version = "0.4.0"

  auth {
    channels {
      permission_denied = "${var.auth_channels_permission_denied}"
      exclude           = ["${var.auth_channels_exclude}"]
      include           = ["${var.auth_channels_include}"]
    }
    users {
      permission_denied = "${var.auth_users_permission_denied}"
      exclude           = ["${var.auth_users_exclude}"]
      include           = ["${var.auth_users_include}"]
    }
  }
}

data "template_file" "config" {
  template = "${file("${path.module}/src/config.tpl")}"

  vars {
    response_type      = "${var.response_type}"
    web_api_token      = "${var.web_api_token}"
    verification_token = "${var.verification_token}"
  }
}

data "template_file" "package" {
  template = "${file("${path.module}/src/package.tpl")}"

  vars {
    version = "${local.version}"
  }
}

data "archive_file" "archive" {
  type        = "zip"
  output_path = "${path.module}/dist/${var.function_name}-${local.version}.zip"

  source {
    content  = "${jsonencode("${local.auth}")}"
    filename = "auth.json"
  }

  source {
    content  = "${data.template_file.config.rendered}"
    filename = "config.json"
  }

  source {
    content  = "${file("${path.module}/src/index.js")}"
    filename = "index.js"
  }

  source {
    content  = "${data.template_file.package.rendered}"
    filename = "package.json"
  }

  source {
    content  = "${jsonencode("${var.response}")}"
    filename = "response.json"
  }
}

resource "google_storage_bucket_object" "archive" {
  bucket = "${var.bucket_name}"
  name   = "${var.bucket_prefix}${var.function_name}-${local.version}-${md5(file("${data.archive_file.archive.output_path}"))}.zip"
  source = "${data.archive_file.archive.output_path}"
}

resource "google_cloudfunctions_function" "function" {
  available_memory_mb   = "${var.memory}"
  description           = "${var.description}"
  entry_point           = "slashCommand"
  labels                = "${var.labels}"
  name                  = "${var.function_name}"
  source_archive_bucket = "${var.bucket_name}"
  source_archive_object = "${google_storage_bucket_object.archive.name}"
  timeout               = "${var.timeout}"
  trigger_http          = true
}

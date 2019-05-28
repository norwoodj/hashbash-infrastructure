terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  version = ">= 2.6.0"
  region  = "${var.region}"
}

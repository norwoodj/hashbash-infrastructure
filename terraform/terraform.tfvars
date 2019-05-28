terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket = "use2-veintitres-terraform-state"
      key = "${path_relative_to_include()}/terraform.tfstate"
      region = "us-east-2"
      encrypt = true

      s3_bucket_tags {
        owner = "veintitres"
        purpose = "hashbash"
      }
    }
  }

  terraform {
    extra_arguments "common_vars" {
      commands = ["${get_terraform_commands_that_need_vars()}"]
      required_var_files = ["${get_parent_tfvars_dir()}/global.tfvars"]
    }
  }
}

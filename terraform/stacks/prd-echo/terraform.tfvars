terragrunt = {
  include = {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "../../modules//aws-vpc-eks-cluster"
  }
}

ec2_key_pair = "veintitres"
stack_name   = "prd-echo"

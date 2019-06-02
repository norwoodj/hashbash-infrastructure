data "aws_availability_zones" "available" {}

resource "aws_security_group" "world_bastion_access" {
  count  = "${var.enable_bastion}"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  count                  = "${var.enable_bastion}"
  ami                    = "${var.bastion_ami}"
  instance_type          = "t3.nano"
  key_name               = "${var.ec2_key_pair}"
  subnet_id              = "${module.vpc.public_subnets[0]}"
  vpc_security_group_ids = ["${module.vpc.default_security_group_id}", "${aws_security_group.world_bastion_access.0.id}"]

  tags = {
    Name = "${var.stack_name}-bastion"
  }
}

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "1.66.0"
  name            = "${var.stack_name}"
  cidr            = "10.0.0.0/16"
  azs             = "${data.aws_availability_zones.available.names}"
  public_subnets  = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
  private_subnets = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]

  enable_dns_hostnames = true
  enable_nat_gateway   = true

  tags = {
    "kubernetes.io/cluster/${var.stack_name}" = "shared"
  }

  public_subnet_tags = {
    "Tier"                   = "public"
    "KubernetesCluster"      = "${var.stack_name}"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "Tier"                            = "private"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "4.0.2"
  cluster_name = "${var.stack_name}"

  vpc_id  = "${module.vpc.vpc_id}"
  subnets = ["${module.vpc.private_subnets}"]

  manage_aws_auth    = true
  worker_group_count = 3

  worker_groups = [
    {
      name                 = "default"
      instance_type        = "t3.medium"
      key_name             = "${var.ec2_key_pair}"
      asg_desired_capacity = 1
      asg_min_size         = 0
      asg_max_size         = 1
    },
    {
      name                 = "database"
      instance_type        = "m5.xlarge"
      key_name             = "${var.ec2_key_pair}"
      kubelet_extra_args   = "--node-labels role=database --register-with-taints database=true:NoSchedule"
      asg_desired_capacity = 1
      asg_min_size         = 0
      asg_max_size         = 1
    },
    {
      name                 = "engine"
      instance_type        = "c4.2xlarge"
      key_name             = "${var.ec2_key_pair}"
      kubelet_extra_args   = "--node-labels role=engine --register-with-taints engine=true:NoSchedule"
      asg_desired_capacity = 1
      asg_min_size         = 0
      asg_max_size         = 1
    },
  ]

  worker_additional_security_group_ids = ["${module.vpc.default_security_group_id}"]

  tags = {
    Environment = "production"
  }
}

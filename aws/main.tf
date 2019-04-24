provider "aws" {
  access_key = "${var.token}"
  secret_key = "${var.key}"
  region     = "us-east-1"
}

# Params

variable "token" {
    default     = ""
}
variable "key" {
    default     = ""
}

# EKS

resource "aws_eks_cluster" "example" {
  enabled_cluster_log_types = ["api", "audit"]
  name                      = "exapmle"
  role_arn                  = "${aws_iam_role.tf_role.arn}"

  vpc_config {
    subnet_ids = ["${aws_subnet.subnet_1.id}", "${aws_subnet.subnet_2.id}"]
  }
}

output "endpoint" {
  value = "${aws_eks_cluster.example.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.example.certificate_authority.0.data}"
}

# Role

resource "aws_iam_role" "tf_role" {
  name = "tf_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}


# Subnet

resource "aws_subnet" "subnet_1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
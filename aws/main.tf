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
  role_arn                  = "arn:aws:iam::177510963163:role/ServiceRoleForAmazonEKS2"

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
        "Service": "eks.amazonaws.com"
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

resource "aws_iam_role_policy_attachment" "attach-cluster" {
  role       = "tf_role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "attach-service" {
  role       = "tf_role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# Subnet

resource "aws_subnet" "subnet_1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Main"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

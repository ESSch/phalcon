provider "aws" {
	region     = "us-west-1"
}
resource "aws_sqs_queue" "terraform_queue" {
	name                      = "terraform-queue"
	delay_seconds             = 90
	max_message_size          = 2048
	message_retention_seconds = 86400
	receive_wait_time_seconds = 10
}
data "aws_route53_zone" "vuejs_phalcon" {
	name         = "test.com."
	private_zone = true
}
resource "aws_route53_record" "www" {
	zone_id = "${data.aws_route53_zone.vuejs_phalcon.zone_id}"
	name    = "www.${data.aws_route53_zone.selected.name}"
	type    = "A"
	ttl     = "300"
	records = ["10.0.0.1"]
}
resource "aws_elasticsearch_domain" "example" {
	domain_name           = "example"
	elasticsearch_version = "1.5"
	cluster_config {
		instance_type = "r4.large.elasticsearch"
	}
	snapshot_options {
		automated_snapshot_start_hour = 23
	}
}
resource "aws_eks_cluster" "eks_vuejs_phalcon" {
	name     = "eks_vuejs_phalcon"
	role_arn = "${aws_iam_role.eks_vuejs_phalcon.arn}"

	vpc_config {
		subnet_ids = ["${aws_subnet.eks_vuejs_phalcon.id}", "${aws_subnet.example2.id}"]
	}
}
output "endpoint" {
	value = "${aws_eks_cluster.eks_vuejs_phalcon.endpoint}"
}
output "kubeconfig-certificate-authority-data" {
	value = "${aws_eks_cluster.eks_vuejs_phalcon.certificate_authority.0.data}"
}

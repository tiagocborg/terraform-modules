output "pritunl_private_ip" {
  value = "${aws_instance.pritunl.private_ip}"
}

output "pritunl_public_url" {
  value = "https://${aws_instance.pritunl.public_ip}"
}

output "pritunl_public_ip" {
  value = "${aws_instance.pritunl.public_ip}"
}

output "security_group_id" {
  value = "${aws_security_group.pritunl.id}"
}

output "aws_instance_id" {
  value = "${aws_instance.pritunl.id}"
}
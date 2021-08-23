
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.pritunl.id
  allocation_id = aws_eip.instance_eip.id
}

resource "aws_eip" "instance_eip" {
  vpc = true
}
resource "aws_instance" "pritunl" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.aws_key_name
  user_data     = file("${path.module}/provision.sh")

  vpc_security_group_ids = [
    aws_security_group.pritunl.id
  ]

  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
    encrypted   = true
    tags = merge(
      tomap({"Name" = format("%s-%s", var.resource_name_prefix, "vpn")}),
      var.tags,
    )
  }

  tags = merge(
    tomap({"Name" = format("%s-%s", var.resource_name_prefix, "vpn")}),
    var.tags,
  )

  provisioner "remote-exec" {
    inline = [
      "sleep 60",
      "sudo pritunl setup-key",
    ]

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.aws_key_path)

      timeout = "30m"
    }
  }
}

# data "aws_instance" "pritunl_loaded" {
#   depends_on = [
#     aws_instance.pritunl
#   ]

#   filter {
#     name   = "image-id"
#     values = [var.ami_id]
#   }

#   filter {
#     name   = "tag:Name"
#     values = [format("%s-%s", var.resource_name_prefix, "vpn")]
#   }
# }

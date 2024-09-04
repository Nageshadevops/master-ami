resource "aws_instance" "ami" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = "ami-server"
  }
}

resource "null_resource" "ansible" {
  connection {
    type     = "ssh"
    user     = var.ssh_user
    password = var.ssh_pass
    host     = aws_instance.ami.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo pip3.11 install ansible hvac",
    ]
  }

}

resource "aws_ami_from_instance" "ami" {
  depends_on         = [null_resource.ansible]
  name               = "master-ami-${formatdate("DD-MM-YY", timestamp())}"
  source_instance_id = aws_instance.ami.id

  lifecycle {
    ignore_changes = [
      name
      ## Only for one IMAge a Day, if we need a second AMI then code need changes.
    ]
  }
}
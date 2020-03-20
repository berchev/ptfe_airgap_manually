resource "aws_instance" "ptfe_instance" {
  depends_on                  = [aws_internet_gateway.ptfe_gw]
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.third_ptfe_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ptfe_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ptfe_instance.name
  user_data                   = <<-EOF
  	  #! /bin/bash
      sudo aws s3 cp s3://${var.ptfe_airgap_location} /opt/tfe-installer/
  EOF

  tags = {
    Name = "PTFE-georgiman"
  }
}
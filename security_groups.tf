# Creating security group and rules for PTFE instance
resource "aws_security_group" "ptfe_sg" {
  name        = var.aws_security_group_name
  vpc_id      = aws_vpc.ptfe_vpc.id
  description = "Security group for ptfe instance"

  tags = {
    Name = "ptfe_instance"
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ptfe_sg.id
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ptfe_sg.id
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ptfe_sg.id
}

resource "aws_security_group_rule" "replicated" {
  type              = "ingress"
  from_port         = 8800
  to_port           = 8800
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ptfe_sg.id
}

# Additional ports
resource "aws_security_group_rule" "range_ports_1" {
  type              = "ingress"
  from_port         = 9870
  to_port           = 9880
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ptfe_sg.id
}

resource "aws_security_group_rule" "range_ports_2" {
  type              = "ingress"
  from_port         = 23000
  to_port           = 23100
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ptfe_sg.id
}

resource "aws_security_group_rule" "outbound_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ptfe_sg.id
}

# Creating security group and rule for Postgers Database 
resource "aws_security_group" "ptfe_postgres" {
  name   = "allow_postgres_connection"
  vpc_id = aws_vpc.ptfe_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ptfe_postgres"
  }
}
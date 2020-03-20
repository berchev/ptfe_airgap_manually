#####################################  Dtabase provision ##################################
resource "aws_db_subnet_group" "postgres_subnet" {
  name       = var.db_subnet_group_name
  subnet_ids = [aws_subnet.first_ptfe_subnet.id, aws_subnet.second_ptfe_subnet.id]

  tags = {
    Name = "Postgres_DB_subnet_group"
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage      = var.db_allocated_storage
  storage_type           = var.db_storage_type
  engine                 = var.db_engine
  engine_version         = var.db_version
  instance_class         = var.db_instance_class
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  port                   = var.db_port
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet.id
  vpc_security_group_ids = [aws_security_group.ptfe_postgres.id]
  skip_final_snapshot    = true
}


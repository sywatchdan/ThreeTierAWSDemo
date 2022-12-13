#Storage RDS
resource "aws_db_instance" "tt_rds" {
  allocated_storage      = 5
  db_subnet_group_name   = aws_db_subnet_group.tt_storage_subnet_group.id
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  multi_az               = true
  db_name                = var.rds_dbname
  username               = var.rds_username
  password               = var.rds_password
  vpc_security_group_ids = [aws_security_group.tt_storage_sg.id]
  skip_final_snapshot    = true
  tags = {
    Name = "${var.naming_prefix} RDS"
  }
}


# Security Group for Presentation Layer
resource "aws_security_group" "tt_presentation_sg" {
  name   = "${var.naming_prefix} Public Security Group"
  vpc_id = aws_vpc.tt_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "${var.naming_prefix} Public Security Group"
  }
}

# Security Group for Application Layer
resource "aws_security_group" "tt_application_sg" {
    name   = "${var.naming_prefix} Application Security Group"
  vpc_id = aws_vpc.tt_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.tt_presentation_sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.tt_presentation_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.tt_presentation_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.naming_prefix} Application Security Group"
  }
}

# Security Group for Storage Layer
resource "aws_security_group" "tt_storage_sg" {
name   = "${var.naming_prefix} Storage Security Group"
  vpc_id = aws_vpc.tt_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.tt_application_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.naming_prefix} Storage Security Group"
  }
}

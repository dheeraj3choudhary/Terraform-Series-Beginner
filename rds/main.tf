resource "aws_db_subnet_group" "rds_db_subnet_group" {
  name        = "rds-subnet-group"
  subnet_ids  = data.aws_subnet_ids.GetSubnet_Ids.ids
}

resource "aws_security_group" "rds" {
  name        = "rds_security_group"
  description = "Security group for RDS"
  vpc_id      = data.aws_vpc.GetVPC.id
  # Keep the instance private by only allowing traffic from the web server.
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds-security-group"
  }
}
resource "aws_db_instance" "rds_instance" {
  identifier                = "${var.rds_instance_identifier}"
  allocated_storage         = 5
  engine                    = "mysql"
  engine_version            = "5.6.35"
  instance_class            = "db.t2.micro"
  name                      = "${var.db_name}"
  username                  = "${var.db_name}"
  password                  = "${var.db_password}"
  db_subnet_group_name      = "${aws_db_subnet_group.rds_db_subnet_group.id}"
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
}
resource "aws_db_parameter_group" "rds_para_grp" {
  name        = "rds-param-group"
  description = "Parameter group for mysql5.6"
  family      = "mysql5.6"
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}
#---------------------Create Custom VPC----------------------
resource "aws_vpc" "CustomVPC" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "CustomVPC"
  }
}
#---------------------Create IGW And associate with VPC----------------------
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.CustomVPC.id

  tags = {
    Name = "IGW"
  }
}
#---------------------Create 2 Public Subnets----------------------
resource "aws_subnet" "PublicSubnet1" {
  vpc_id                  = aws_vpc.CustomVPC.id
  cidr_block              = "10.0.0.0/18"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet1"
    Type = "Public"
  }
}
resource "aws_subnet" "PublicSubnet2" {
  vpc_id                  = aws_vpc.CustomVPC.id
  cidr_block              = "10.0.64.0/18"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet2"
    Type = "Public"
  }
}
#---------------------Create Custom Public route table----------------------
resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.CustomVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}
#---------------------Create route table association with public route table----------------------
resource "aws_route_table_association" "PublicSubnetRouteTableAssociation1" {
  subnet_id      = aws_subnet.PublicSubnet1.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "PublicSubnetRouteTableAssociation2" {
  subnet_id      = aws_subnet.PublicSubnet2.id
  route_table_id = aws_route_table.PublicRouteTable.id
}
#---------------------Create Security Group For Load Balancer----------------------
resource "aws_security_group" "elb_sg" {
  name        = "allow_http_elb"
  description = "Allow http inbound traffic for elb"
  vpc_id      = aws_vpc.CustomVPC.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "terraform-elb-security-group"
  }
}
#---------------------Create Load Balancer----------------------
resource "aws_alb" "CustomELB" {
  name            = "CustomELB"
  security_groups = [aws_security_group.elb_sg.id]
  subnets         = data.aws_subnet_ids.GetSubnet_Ids.ids
  tags = {
    Name = "CustomELB"
  }
}
#---------------------Create Target Group----------------------
resource "aws_lb_target_group" "CustomTG" {
  name        = "CustomTG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.CustomVPC.id
  target_type = "instance"
}
#---------------------Create Load Balancer Listener----------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.CustomELB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.CustomTG.arn
      }
      stickiness {
        enabled  = true
        duration = 28800
      }
    }
  }
}

#---------------------Create Security Group For EC2----------------------
resource "aws_security_group" "ec2_sg" {
  name        = "allow_http_elb"
  description = "Allow http inbound traffic for elb"
  vpc_id      = aws_vpc.CustomVPC.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb_sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "terraform-elb-security-group"
  }
}

#---------------------Create ASG Launch Configuration----------------------
resource "aws_launch_configuration" "webteir_launch_config" {
  name_prefix                 = "webteir"
  image_id                    = "ami-0742b4e673072066f"
  instance_type               = var.instance_type
  key_name                    = var.aws_key_pair
  security_groups             = ["${aws_security_group.ec2_sg.id}"]
  associate_public_ip_address = true
  user_data                   = <<EOF
    #! /bin/bash
    sudo su
    sudo yum update
    sudo yum install -y httpd
    sudo chkconfig httpd on
    sudo service httpd start
    echo "<h1>Deployed EC2 Using ASG</h1>" | sudo tee /var/www/html/index.html
    EOF
  lifecycle {
    create_before_destroy = true
  }
}
#---------------------Create Autoscaling Group----------------------
resource "aws_autoscaling_group" "autoscaling_group_webteir" {
  launch_configuration = aws_launch_configuration.webteir_launch_config.id
  min_size             = var.autoscaling_group_min_size
  max_size             = var.autoscaling_group_max_size
  target_group_arns    = ["${aws_lb_target_group.CustomTG.arn}"]
  vpc_zone_identifier  = data.aws_subnet_ids.GetSubnet_Ids.ids

  tag {
    key                 = "Name"
    value               = "autoscaling-group-webteir"
    propagate_at_launch = true
  }
}
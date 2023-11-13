# Create a target group
resource "aws_lb_target_group" "CustomTG" {
  name        = "CustomTG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.GetVPC.id
  target_type = "instance"
}
# Associate the EC2 instances with the target group
resource "aws_lb_target_group_attachment" "CustomTGAttach" {
  count            = length(data.aws_instances.ec2_list.ids)
  target_group_arn = aws_lb_target_group.CustomTG.arn
  target_id        = data.aws_instances.ec2_list.ids[count.index]
  port             = 80
}
# Create security group for elastic load balancer
resource "aws_security_group" "elb_sg" {
  name        = "allow_http_elb"
  description = "Allow http inbound traffic for elb"
  vpc_id      = data.aws_vpc.GetVPC.id

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
# Create Elastic load balancer
resource "aws_lb" "CustomELB" {
  name            = "CustomELB"
  subnets         = data.aws_subnets.GetSubnet.ids
  security_groups = [aws_security_group.elb_sg.id]
  tags = {
    Name = "CustomELB"
  }
}
# Create listener for ELB to associate to the target group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.CustomELB.arn
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

resource "aws_lb" "CustomELB" {
  name = "CustomELB"
  subnets = data.aws_subnet_ids.GetSubnet_Ids.ids
  security_groups = [aws_security_group.elb_sg.id]
  tags = {
    Name = "CustomELB"
  }
}

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
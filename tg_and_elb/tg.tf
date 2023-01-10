resource "aws_lb_target_group" "CustomTG" {
  name     = "CustomTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.GetVPC.id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "CustomTGAttach" {
  count = "${length(data.aws_instances.ec2_list.ids)}"
  target_group_arn = aws_lb_target_group.CustomTG.arn
  target_id        = "${data.aws_instances.ec2_list.ids[count.index]}"
  port             = 80
}
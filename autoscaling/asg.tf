# Create a new EC2 launch configuration. This will be used with our auto scaling group.
resource "aws_launch_configuration" "launch_config_dev" {
  name_prefix                 = "webteir_dev"
  image_id                    = "ami-0742b4e673072066f"
  instance_type               = "${var.instance_type}"
  #key_name                    = "${var.aws_key_pair}"
  security_groups             = ["${aws_security_group.asg_sg.id}"]
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

# Create the auto scaling group
resource "aws_autoscaling_group" "autoscaling_group_dev" {
  launch_configuration = "${aws_launch_configuration.launch_config_dev.id}"
  min_size             = "${var.autoscaling_group_min_size}"
  max_size             = "${var.autoscaling_group_max_size}"
  target_group_arns    = ["${data.aws_lb_target_group.elb_tg.arn}"]
  vpc_zone_identifier  = "${data.aws_subnet.GetSubnet.*.id}"

  tag {
    key                 = "Name"
    value               = "autoscaling-group-dev"
    propagate_at_launch = true
  }
}

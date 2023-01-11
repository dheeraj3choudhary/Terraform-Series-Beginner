data "aws_vpc" "GetVPC" {
filter {
    name   = "tag:Name"
    values = ["CustomVPC"]
  }
}

#-------------------------Fetch Public Subnets List---------------------------------
data "aws_subnet_ids" "GetSubnet_Ids" {
  vpc_id = data.aws_vpc.GetVPC.id
  filter {
    name   = "tag:Type"
    values = ["Public"]
  }
}

data "aws_subnet" "GetSubnet" {
  count = "${length(data.aws_subnet_ids.GetSubnet_Ids.ids)}"
  id    = "${tolist(data.aws_subnet_ids.GetSubnet_Ids.ids)[count.index]}"
}

output "subnet_list" {
  value = "${data.aws_subnet.GetSubnet.*.id}"
}

#-------------------------Fetch Target Group ARN---------------------------------
variable "elb_tg_arn" {
  type    = string
  default = ""
}
data "aws_lb_target_group" "elb_tg" {
  arn  = var.elb_tg_arn
}

output "tg_arn" {
  value = var.elb_tg_arn
}

#-------------------------Variables For Autoscaling---------------------------------

variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "autoscaling_group_min_size" {
  type = number
  default = 2
}
variable "autoscaling_group_max_size" {
  type = number
  default = 3
}

variable "aws_key_pair" {
  type = string
  default = "<File Path>"
}

output "subnet_list1" {
  value = "${data.aws_subnet.GetSubnet.*.availability_zone_id}"
}

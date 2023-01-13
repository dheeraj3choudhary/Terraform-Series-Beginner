#-------------------------Variables For Autoscaling---------------------
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "autoscaling_group_min_size" {
  type    = number
  default = 2
}
variable "autoscaling_group_max_size" {
  type    = number
  default = 3
}
variable "aws_key_pair" {
  type    = string
  default = "D:/Intellipath/AWS/CustomVPC.pem"
}
#-------------------------Data Block to fetch subnet ids---------------------
data "aws_subnet_ids" "GetSubnet_Ids" {
  vpc_id = aws_vpc.CustomVPC.id
  filter {
    name   = "tag:Type"
    values = ["Public"]
  }
}
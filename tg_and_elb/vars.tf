variable "AWS_REGION" {
  default = "us-east-1"
}
data "aws_vpc" "GetVPC" {
filter {
    name   = "tag:Name"
    values = ["CustomVPC"]
          }
}

data "aws_instances" "ec2_list" {
  instance_state_names = ["running"]
}

data "aws_subnet_ids" "GetSubnet_Ids" {
  vpc_id = data.aws_vpc.GetVPC.id
  filter {
    name   = "tag:Type"
    values = ["Public"]
  }
}
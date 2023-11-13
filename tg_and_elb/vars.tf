variable "AWS_REGION" {
  default = "us-west-2"
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

#-------------------------Fetch Public Subnets List---------------------------------
data "aws_subnets" "GetSubnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.GetVPC.id]
  }
  filter {
    name   = "tag:Type"
    values = ["Public"]
  }
}

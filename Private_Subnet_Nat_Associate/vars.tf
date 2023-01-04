data "aws_vpc" "GetVPC" {
filter {
    name   = "tag:Name"
    values = ["CustomVPC"]
  }
}

data "aws_internet_gateway" "GetIGW" {

filter {
    name   = "tag:Name"
    values = ["IGW"]
  }
}

data "aws_subnet" "GetPublicSubnet" {

filter {
    name   = "tag:Name"
    values = ["PublicSubnet1"]
  }
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-04505e74c0741db8d"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-0d729a60"
  }
}
variable "AWS_REGION" { 
default = "us-east-1" 
} 
data "aws_vpc" "GetVPC" { 
filter { 
    name = "tag:Name" 
    values = ["CustomVPC"] 
    } 
} 
data "aws_subnet" "GetPublicSubnet" { 
filter { 
    name = "tag:Name" 
    values = ["PublicSubnet1"] 
    } 
}


variable "ami" { 
type = map 
default = { 
    "us-east-1" = "ami-04169656fea786776" 
    "us-west-1" = "ami-006fce2a9625b177f" 
    } 
}
variable "AWS_REGION" {
  default = "us-east-1"
}
data "aws_vpc" "GetVPC" {
filter {
    name   = "tag:Name"
    values = ["CustomVPC"]
          }
}
data "aws_subnet" "GetPublicSubnet" {
filter {
    name   = "tag:Name"
    values = ["PublicSubnet1"]
          }
}
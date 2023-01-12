#-------------------------Data Block to fetch vpc id---------------------
data "aws_vpc" "GetVPC" {
filter {
    name   = "tag:Name"
    values = ["CustomVPC"]
  }
}
#-------------------------Variable for RDS Configuration---------------------
variable "rds_instance_identifier" {
    type = string
    default  = "terraform-mysql"
}
variable "db_name" {
    type = string
    default  = "terraform_test_db"
}
variable "db_password" {
    type = string
    default  = "<input your password>"
}
variable "db_user" {
    type = string
    default  = "terraform"
}

#-------------------------Data Block to fetch subnet ids---------------------
data "aws_subnet_ids" "GetSubnet_Ids" {
vpc_id = data.aws_vpc.GetVPC.id
filter {
 name   = "tag:Type"
 values = ["Public"]
       }
}

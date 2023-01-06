resource "aws_instance" "webservers" {
	ami = "ami-0742b4e673072066f"
	instance_type = "t2.micro"
	security_groups = [aws_security_group.ec2_sg.id]
	subnet_id = [data.aws_subnet.GetSubnet]
    key_name = aws_key_pair.key_pair.key_name
	tags = {
	  Name = "Linux"
	  Env = "Dev"
	}
}
resource "aws_network_acl" "aws_nacl" {
  vpc_id = data.aws_vpc.GetVPC.id
  subnet_ids = [ data.aws_subnet.GetPublicSubnet.id ]
# allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = data.aws_subnet.GetPublicSubnet.cidr_block 
    from_port  = 22
    to_port    = 22
  }
  
  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = data.aws_subnet.GetPublicSubnet.cidr_block
    from_port  = 80
    to_port    = 80
  }
  
  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = data.aws_subnet.GetPublicSubnet.cidr_block
    from_port  = 1024
    to_port    = 65535
  }
  
  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = data.aws_subnet.GetPublicSubnet.cidr_block
    from_port  = 22 
    to_port    = 22
  }
  
  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = data.aws_subnet.GetPublicSubnet.cidr_block
    from_port  = 80  
    to_port    = 80 
  }
 
  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = data.aws_subnet.GetPublicSubnet.cidr_block
    from_port  = 1024
    to_port    = 65535
  }
    tags = {
        Name = "Custom_NACL"
            }
}
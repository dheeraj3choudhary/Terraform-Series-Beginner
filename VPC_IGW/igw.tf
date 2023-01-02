# Author :- Dheeraj Choudhary

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.CustomVPC.id

  tags = {
    Name = "IGW"
  }
}
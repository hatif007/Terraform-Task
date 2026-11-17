resource "aws_security_group" "allow_inbound" {
  name        = "allow_inbound"
  description = "Allow inbound traffic on specific ports"
  vpc_id      = "vpc-0d859c220661ce168"


  tags = {
    Name = "allow_inbound"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_inbound.id
  cidr_ipv4         = "84.229.81.109/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}



resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.allow_inbound.id
  cidr_ipv4         = "84.229.81.109/32"
  from_port         = 5001
  ip_protocol       = "tcp"
  to_port           = 5001
}
resource "aws_vpc_security_group_egress_rule" "allow_egress_ipv4" {
  security_group_id = aws_security_group.allow_inbound.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
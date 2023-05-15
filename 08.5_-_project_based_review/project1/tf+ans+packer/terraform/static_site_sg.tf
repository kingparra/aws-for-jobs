resource "aws_security_group" "static_site" {
  name = "EnergymInstanceSg"
  description = "Sg for the static site instances."
}

# Unlike aws_security_group_rule or in-line rules, this supports security group rule unique ids.
resource "aws_vpc_security_group_ingress_rule" "allowhttp" {
  security_group_id = aws_security_group.static_site.id
  description = "Allow ssh ingress for the instance used to create our goledn image"
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
}

resource "aws_vpc_security_group_egress_rule" "allowall" {
  security_group_id = aws_security_group.static_site.id
  ip_protocol = -1
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_security_group" "alb_sg" {
  name = "EnergymAlbSg"
  description = "Sg for the instance used to create the golden image."
}

resource "aws_vpc_security_group_egress_rule" "allowhealthcheck" {
  security_group_id = aws_security_group.alb_sg.id
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_ipv4 = "0.0.0.0/0"
}

# https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_LoadBalancer.html
resource "aws_lb" "site_alb" {
  name = "EnergymAlb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets =  data.aws_subnets.default_vpc_subnets.ids
}

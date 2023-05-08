resource "aws_security_group" "elb_sg" {
  name = "web"
  description = "ELB for a webserver cluster"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "elb" {
  name = "web"
  availability_zones = [ "us-east-1a"
                       , "us-east-1b"
                       , "us-east-1c"
                       , "us-east-1d"
                       , "us-east-1e"
                       , "us-east-1f"
                       ]
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }
}

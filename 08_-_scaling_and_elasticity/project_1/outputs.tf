output "load_blancer_fqdn" {
  value = aws_elb.elb.dns_name
}

output "asg_instances" {
  value = data.aws_instances.ins
}

resource "aws_vpc_peering_connection" "a_to_b_px" {
  peer_vpc_id = module.vpc_a.vpc_id
  vpc_id      = module.vpc_b.vpc_id
  auto_accept = true
}

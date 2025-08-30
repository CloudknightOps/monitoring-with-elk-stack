# Security Group for K8s Nodes (Master + Workers)
resource "aws_security_group" "sg_main" {
  name        = "k8s_node_sg"
  description = "K8s node security group"
  vpc_id      = aws_vpc.aws_rke2_vpc.id

  tags = {
    Name = "k8s_node_sg"
  }
}

# -------------------------------
# Publicly accessible ports
# -------------------------------

# Allow SSH (recommend restrict to your IP instead of 0.0.0.0/0)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.sg_main.id
  cidr_ipv4         = "0.0.0.0/0" # <-- change to your IP
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# Allow kube-api (workers + kubectl)
resource "aws_vpc_security_group_ingress_rule" "allow_6443_ipv4" {
  security_group_id = aws_security_group.sg_main.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 6443
  to_port           = 6443
  ip_protocol       = "tcp"
}

# -------------------------------
# Internal cluster-only ports
# -------------------------------
# Restrict to same SG (node-to-node)

# etcd (2379–2380)
resource "aws_vpc_security_group_ingress_rule" "allow_etcd_internal" {
  security_group_id            = aws_security_group.sg_main.id
  referenced_security_group_id = aws_security_group.sg_main.id
  from_port                    = 2379
  to_port                      = 2380
  ip_protocol                  = "tcp"
}

# RKE2 Supervisor (9345)
resource "aws_vpc_security_group_ingress_rule" "allow_9345_internal" {
  security_group_id            = aws_security_group.sg_main.id
  referenced_security_group_id = aws_security_group.sg_main.id
  from_port                    = 9345
  to_port                      = 9345
  ip_protocol                  = "tcp"
}

# Kubelet / Controller Manager / Scheduler (10250–10255)
resource "aws_vpc_security_group_ingress_rule" "allow_kubelet_internal" {
  security_group_id            = aws_security_group.sg_main.id
  referenced_security_group_id = aws_security_group.sg_main.id
  from_port                    = 10250
  to_port                      = 10255
  ip_protocol                  = "tcp"
}

# Kube-Proxy (10256)
resource "aws_vpc_security_group_ingress_rule" "allow_kubeproxy_internal" {
  security_group_id            = aws_security_group.sg_main.id
  referenced_security_group_id = aws_security_group.sg_main.id
  from_port                    = 10256
  to_port                      = 10256
  ip_protocol                  = "tcp"
}

# Flannel VXLAN (UDP 8472)
resource "aws_vpc_security_group_ingress_rule" "allow_flannel_vxlan_internal" {
  security_group_id            = aws_security_group.sg_main.id
  referenced_security_group_id = aws_security_group.sg_main.id
  from_port                    = 8472
  to_port                      = 8472
  ip_protocol                  = "udp"
}

# Calico VXLAN (UDP 4789)
resource "aws_vpc_security_group_ingress_rule" "allow_calico_vxlan_internal" {
  security_group_id            = aws_security_group.sg_main.id
  referenced_security_group_id = aws_security_group.sg_main.id
  from_port                    = 4789
  to_port                      = 4789
  ip_protocol                  = "udp"
}

# Calico Typha / BGP (TCP 5473)
resource "aws_vpc_security_group_ingress_rule" "allow_calico_tcp_internal" {
  security_group_id            = aws_security_group.sg_main.id
  referenced_security_group_id = aws_security_group.sg_main.id
  from_port                    = 5473
  to_port                      = 5473
  ip_protocol                  = "tcp"
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_main.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ------------------------------------------------------------------
# Security Group for ELK Node
resource "aws_security_group" "sg_elk" {
  name        = "elk_node_sg"
  description = "Security group for ELK node"
  vpc_id      = aws_vpc.aws_rke2_vpc.id

  tags = {
    Name = "elk_node_sg"
  }
}

# Allow SSH (22)
resource "aws_vpc_security_group_ingress_rule" "elk_allow_ssh_ipv4" {
  security_group_id = aws_security_group.sg_elk.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Allow Elasticsearch (9200)
resource "aws_vpc_security_group_ingress_rule" "elk_allow_9200_ipv4" {
  security_group_id = aws_security_group.sg_elk.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 9200
  ip_protocol       = "tcp"
  to_port           = 9200
}

# Allow Kibana (5601)
resource "aws_vpc_security_group_ingress_rule" "elk_allow_5601_ipv4" {
  security_group_id = aws_security_group.sg_elk.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5601
  ip_protocol       = "tcp"
  to_port           = 5601
}


# Allow Filebeat (workers) -> Logstash (5044)
resource "aws_vpc_security_group_ingress_rule" "elk_allow_5044_workers" {
  security_group_id            = aws_security_group.sg_elk.id
  referenced_security_group_id = aws_security_group.sg_main.id
  from_port                    = 5044
  to_port                      = 5044
  ip_protocol                  = "tcp"
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "elk_allow_all_outbound" {
  security_group_id = aws_security_group.sg_elk.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

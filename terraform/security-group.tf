# Security Group for K8s Nodes (Master + Workers)
resource "aws_security_group" "sg_main" {
  name        = "k8s_node_sg"
  description = "K8s node security group"
  vpc_id      = aws_vpc.aws_rke2_vpc.id

  tags = {
    Name = "k8s_node_sg"
  }
}

# Allow SSH access (port 22)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.sg_main.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "allow_ssh_ipv4"
  }
}

# Allow kube-api (6443)
resource "aws_vpc_security_group_ingress_rule" "allow_6443_ipv4" {
  security_group_id = aws_security_group.sg_main.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 6443
  ip_protocol       = "tcp"
  to_port           = 6443

  tags = {
    Name = "allow_6443_ipv4"
  }
}

# Allow etcd (2379)
resource "aws_vpc_security_group_ingress_rule" "allow_2379_ipv4" {
  security_group_id = aws_security_group.sg_main.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 2379
  ip_protocol       = "tcp"
  to_port           = 2379

  tags = {
    Name = "allow_2379_ipv4"
  }
}

# Allow etcd (2380)
resource "aws_vpc_security_group_ingress_rule" "allow_2380_ipv4" {
  security_group_id = aws_security_group.sg_main.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 2380
  ip_protocol       = "tcp"
  to_port           = 2380

  tags = {
    Name = "allow_2380_ipv4"
  }
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_main.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "allow_all_traffic_ipv4"
  }
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

resource "aws_vpc_security_group_ingress_rule" "elk_allow_5044_workers" {
  security_group_id = aws_security_group.sg_elk.id
  cidr_ipv4         =  "0.0.0.0/0"
  from_port         = 5044
  ip_protocol       = "tcp"
  to_port           = 5044
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "elk_allow_all_outbound" {
  security_group_id = aws_security_group.sg_elk.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

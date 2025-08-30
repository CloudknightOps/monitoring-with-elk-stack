
locals {
  cluster_domain = var.domain != "" ? var.domain : aws_instance.master_server.private_dns
}

resource "aws_instance" "master_server" {
  ami           = var.ami_id
  instance_type = var.master_server
  vpc_security_group_ids = [aws_security_group.sg_main.id]
  subnet_id              = aws_subnet.aws_rke2_public_subnet1.id
  associate_public_ip_address = true   
  iam_instance_profile   = aws_iam_instance_profile.aws_iam_profile_master.name
  key_name               = var.key_pair_name
  user_data = templatefile("${path.module}/scripts/master-server.sh", {
#    DOMAIN = var.domain
    TOKEN  = var.token
    vRKE2  = var.vRKE2
  })
  tags = {
    Name = "${var.prefix}-master"
  }

  root_block_device {
    volume_size           = var.volume_size_master
    volume_type           = var.volume_type_master
    encrypted             = var.encrypted
    delete_on_termination = var.delete_on_termination
    tags = {
      Name = "${var.prefix}-master-volume"
    }
  }
}

resource "aws_instance" "agent_node" {
  ami           = var.ami_id
  instance_type = var.agent_node
  count         = var.number_of_agent_nodes
  vpc_security_group_ids = [aws_security_group.sg_main.id]
  subnet_id              = element([aws_subnet.aws_rke2_public_subnet1.id, aws_subnet.aws_rke2_public_subnet2.id], count.index % 2)
  associate_public_ip_address = false  
  iam_instance_profile   = aws_iam_instance_profile.aws_iam_profile_worker.name
  key_name               = var.key_pair_name
  depends_on             = [aws_instance.master_server]
  user_data = templatefile("${path.module}/scripts/agent-nodes.sh", {
    DOMAIN = local.cluster_domain
    TOKEN  = var.token
    vRKE2  = var.vRKE2
  })
  tags = {
    Name = "${var.prefix}-agent-0${count.index + 1}"
  }
  root_block_device {
    volume_size           = var.volume_size_worker
    volume_type           = var.volume_type_worker
    encrypted             = var.encrypted
    delete_on_termination = var.delete_on_termination
    tags = {
      Name = "${var.prefix}-agent-volume-0${count.index + 1}"
    }
  }
}

resource "aws_instance" "elk_node" {
  ami           = var.ami_elk_id
  instance_type = var.elk_node_instance_type 
  vpc_security_group_ids = [aws_security_group.sg_elk.id]
  subnet_id              = aws_subnet.aws_rke2_public_subnet2.id
  associate_public_ip_address = true  
  key_name               = var.key_pair_name
  user_data = templatefile("${path.module}/scripts/elk-node.sh", {})
  tags = {
    Name = "${var.prefix}-elk-01"
  }

  root_block_device {
    volume_size           = var.volume_size_elk   
    volume_type           = var.volume_type_elk   
    encrypted             = var.encrypted
    delete_on_termination = var.delete_on_termination
    tags = {
      Name = "${var.prefix}-elk-volume-01"
    }
  }
}

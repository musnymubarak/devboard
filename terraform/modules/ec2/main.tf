# Upload your local SSH public key to AWS
resource "aws_key_pair" "devboard" {
  key_name   = "${var.project}-key-${var.environment}"
  public_key = file("~/.ssh/devboard.pub")
}

# Find latest Ubuntu 22.04 LTS AMI from Canonical
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Control Plane Node — t3.medium (needs more CPU for etcd + API server)
resource "aws_instance" "control_plane" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_1_id
  vpc_security_group_ids = [var.k8s_nodes_sg_id]
  key_name               = aws_key_pair.devboard.key_name
  iam_instance_profile   = var.iam_instance_profile_name
  monitoring             = true

  metadata_options {               
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = { Name = "${var.project}-control-plane-${var.environment}" }
}

# Launch Template for Worker Nodes
resource "aws_launch_template" "worker" {
  name_prefix   = "${var.project}-worker-${var.environment}-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name      = aws_key_pair.devboard.key_name

  metadata_options {               
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  network_interfaces {
    security_groups = [var.k8s_nodes_sg_id]
    subnet_id       = var.private_subnet_1_id
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 8
      volume_type = "gp3"
      encrypted   = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project}-worker-${var.environment}"
    }
  }
}

# Auto Scaling Group for Worker Nodes
resource "aws_autoscaling_group" "workers" {
  name                = "${var.project}-workers-${var.environment}"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = [var.private_subnet_1_id]

  launch_template {
    id      = aws_launch_template.worker.id
    version = "$Latest"
  }

  # Required tags for Cluster Autoscaler discovery
  tag {
    key                 = "kubernetes.io/cluster/devboard"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/devboard"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-worker-${var.environment}"
    propagate_at_launch = true
  }
}
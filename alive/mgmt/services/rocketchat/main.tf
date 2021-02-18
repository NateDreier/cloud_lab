terraform {
  required_version = ">=0.14.0"
  backend "s3" {
    key    = "stage/vpc/terraform.state"
    bucket = "nates-terraform-state"
    region = "us-west-1"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

data "terraform_remote_state" "global_outputs" {
    backend = "s3"
    config = {
        bucket = "nates-terraform-state"
        key = "global/s3/terraform.state"
        region = "us-west-1"
    }
}

data "terraform_remote_state" "mgmt_vpc_outputs" {
    backend = "s3"
    config = {
        bucket = "nates-terraform-state"
        key = "mgmt/vpc/terraform.state"
        region = "us-west-1"
    }
}

data "aws_ssm_parameter" "linuxAmiWest" {
  provider = aws.region_west_primary
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "linuxAmiEast" {
  provider = aws.region_east_primary
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_key_pair" "key" {
  provider   = aws.region_west_primary
  key_name   = "key"
  public_key = file("~/.ssh/aws_id_rsa.pub")
}

resource "aws_key_pair" "key" {
  provider   = aws.region_east_primary
  key_name   = "key"
  public_key = file("~/.ssh/aws_id_rsa.pub")
}

resource "aws_security_group" "rocketchat_sg" {
  provider    = aws.region_west_primary
  name        = "rocketchat_sg"
  description = "Allow TCP/8080 & TCP/22"
  vpc_id      = aws_vpc.vpc_east_primary.id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  # add sg for cross vpc comms, turn to module
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "rocketchat_node_1" {
  provider                    = aws.region_west_primary
  ami                         = data.aws_ssm_parameter.linuxAmiWest.value
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = terraform_remote_state.mgmt_vpc_outputs.outputs.subnet_west_1

  tags = {
    Name = "rocketchat_node_west"
  }

#  provisioner "local-exec" {
#    command = <<EOF
#aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region_west_primary} --instance-ids ${self.id} 
#ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/gitlab-master.yml
#EOF
#  }
}

resource "aws_instance" "rocketchat_node_2" {
  provider                    = aws.region_west_primary
  ami                         = data.aws_ssm_parameter.linuxAmiEast.value
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.worker-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg-east.id]
  subnet_id                   = terraform_remote_state.mgmt_vpc_outputs.outputs.subnet_west_2

#  provisioner "local-exec" {
#    command = <<EOF
#aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region_east_primary} --instance-ids ${self.id}
#ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/gitlab-runner.yml
#EOF
#  }
}
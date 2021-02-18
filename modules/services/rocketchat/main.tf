data "terraform_remote_state" "global-outputs" {
    backend = "s3"
    config = {
        bucket = "nates-terraform-state"
        key = "global/s3/terraform.state"
        region = "us-west-1"
    }
}

data "aws_ssm_parameter" "linuxAmiWest" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "linuxAmiEast" {
  provider = aws.region-worker
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_key_pair" "master-key" {
  provider   = aws.region-master
  key_name   = "master-key"
  public_key = file("~/.ssh/aws_id_rsa.pub")
}

resource "aws_key_pair" "worker-key" {
  provider   = aws.region-worker
  key_name   = "master-key"
  public_key = file("~/.ssh/aws_id_rsa.pub")
}

resource "aws_instance" "gitlab-master-west" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAmiWest.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id

  tags = {
    Name = "gitlab_master_west_tf"
  }
  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]

  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id} 
ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/gitlab-master.yml
EOF
  }
}

resource "aws_instance" "gitlab-runner-east" {
  provider                    = aws.region-worker
  count                       = var.runners-count
  ami                         = data.aws_ssm_parameter.linuxAmiEast.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.worker-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg-east.id]
  subnet_id                   = aws_subnet.subnet_1_east.id

  tags = {
    Name = join("_", ["gitlab_runner_tf", count.index + 1])
  }
  depends_on = [aws_main_route_table_association.set-worker-default-rt-assoc, aws_instance.gitlab-master-west]

  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-worker} --instance-ids ${self.id}
ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/gitlab-runner.yml
EOF
  }
}
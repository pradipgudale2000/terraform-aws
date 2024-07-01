resource "aws_instance" "app_server" {
  ami                    = "ami-07caf09b362be10b8"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  iam_instance_profile = "${aws_iam_instance_profile.pradip_profile.name}"
  key_name               = "swarupagudalegmail"
  vpc_security_group_ids = ["${aws_security_group.allow_web.id}"]
  subnet_id              = aws_subnet.PG-PrivateSubnet-1.id

  user_data     = <<-EOF
		#!/bin/bash
		sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
		sudo systemctl enable amazon-ssm-agent
		sudo systemctl start amazon-ssm-agent
                  EOF
  tags = {
    Name = "Webserver-1"
  }
}

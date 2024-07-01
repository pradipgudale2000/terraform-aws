resource "aws_vpc" "PG-VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Pradip-vpc"
  }
}

resource "aws_subnet" "PG-PrivateSubnet-1" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.PG-VPC.id
  availability_zone = "us-east-1a"

  tags = {
    Name = "PG-PrivateSubnet-1"
  }
}

resource "aws_subnet" "PG-PrivateSubnet-2" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.PG-VPC.id
  availability_zone = "us-east-1b"

  tags = {
    Name = "PG-PrivateSubnet-2"
  }

}

resource "aws_subnet" "PG-PublicSubnet-1" {
  cidr_block              = "10.0.3.0/24"
  vpc_id                  = aws_vpc.PG-VPC.id
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "PG-PublicSubnet-1"
  }
}

resource "aws_subnet" "PG-PublicSubnet-2" {
  cidr_block              = "10.0.4.0/24"
  vpc_id                  = aws_vpc.PG-VPC.id
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "PG-PublicSubnet-2"
  }
}

resource "aws_route_table" "PG-Private-Route-Table" {
  vpc_id = aws_vpc.PG-VPC.id

    tags = {
    Name = "PG-Private-Route-Table"
  }
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.PG-PrivateSubnet-1.id
  route_table_id = aws_route_table.PG-Private-Route-Table.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.PG-PrivateSubnet-2.id
  route_table_id = aws_route_table.PG-Private-Route-Table.id
}

resource "aws_route_table" "PG-Public-Route-Table" {
  vpc_id = aws_vpc.PG-VPC.id

   tags = {
    Name = "PG-Public-Route-Table"
  }
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.PG-PublicSubnet-1.id
  route_table_id = aws_route_table.PG-Public-Route-Table.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.PG-PublicSubnet-2.id
  route_table_id = aws_route_table.PG-Public-Route-Table.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow-web-traffic"
  description = "Allow all inbound/outbound traffic on 80 443"
  vpc_id      = aws_vpc.PG-VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.PG-VPC.cidr_block]
    description = "Allow HTTPS traffic from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
   egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  
      egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
   
}

locals {
  endpoints = {
    "endpoint-ssm" = {
      name = "ssm"
    },
    "endpoint-ssmm-essages" = {
      name = "ssmmessages"
    },
    "endpoint-ec2-messages" = {
      name = "ec2messages"
    }
  }
}
 
resource "aws_vpc_endpoint" "pradip_endpoints" {
  vpc_id            = aws_vpc.PG-VPC.id
  for_each          = local.endpoints
  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.us-east-1.ec2"
  # Add a security group to the VPC endpoint
  security_group_ids = [aws_security_group.allow_web.id]
}

resource "aws_internet_gateway" "PG-IGW" {
  vpc_id = aws_vpc.PG-VPC.id

  tags = {
    Name = "PG-IGW"
  }
}

resource "aws_eip" "PG-EIP" {
  #vpc      = true
  domain   = "vpc"
}

resource "aws_nat_gateway" "PG-NAT-GW" {
  allocation_id = aws_eip.PG-EIP.id
  connectivity_type = "public"
  subnet_id     = aws_subnet.PG-PublicSubnet-1.id

  tags = {
    Name = "NAT gw"
  }
}

resource "aws_route" "private_nat_routes" {
  route_table_id         = aws_route_table.PG-Private-Route-Table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.PG-NAT-GW.id

}

resource "aws_route" "public_IGW_routes" {
  route_table_id         = aws_route_table.PG-Public-Route-Table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.PG-IGW.id
  }

resource "aws_ec2_instance_connect_endpoint" "pradip_endpoint_ec2_connect" {
  subnet_id = aws_subnet.PG-PrivateSubnet-1.id
}


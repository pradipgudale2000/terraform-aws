resource "aws_iam_role" "pradip_ec2_role" {
  name = "pradip_ec2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "pradip_ec2_role_attachment" {
  role       = aws_iam_role.pradip_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "pradip_s3_role_attachment" {
  role       = aws_iam_role.pradip_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "pradip_ssm_role_attachment" {
  role       = aws_iam_role.pradip_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "pradip_ec2conn_role_attachment" {
  role       = aws_iam_role.pradip_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
}

resource "aws_iam_instance_profile" "pradip_profile" {
  name = "pradip_profile"
  role = aws_iam_role.pradip_ec2_role.name
}

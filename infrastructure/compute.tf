resource "aws_launch_template" "ec2_template" {
  name_prefix = "ec2-launch-template"

  image_id          = data.aws_ami.aws_latest.id
  instance_type = "t2.micro"


  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.ec2_sg.id]
  }

  tags = merge(local.tags, { Name = "${local.tags.Environment}-ec2-launch-template" })


  user_data = base64encode(file("${path.module}/user-data.sh"))

  lifecycle {
    create_before_destroy = true
  }
}



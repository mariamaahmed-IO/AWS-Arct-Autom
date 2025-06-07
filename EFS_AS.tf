## EFS Setup
resource "aws_efs_file_system" "app_data" {
  creation_token = "utc-app-efs"
  tags = {
    Name = "utc-app-efs"
    team = "config management"
    env  = "dev"
  }
}

resource "aws_efs_mount_target" "mount" {
  count = 3
  file_system_id  = aws_efs_file_system.app_data.id
  subnet_id       = element([
    module.vpc.private_subnets[0], # AZ a
    module.vpc.private_subnets[2], # AZ b
    module.vpc.private_subnets[4]  # AZ c
  ], count.index)
  security_groups = [module.app_sg.security_group_id]
}


## Launch Template for auto scaling 
resource "aws_launch_template" "utc_template" {
  name_prefix   = "utc-launch-template"
  image_id      = aws_ami_from_instance.utc_ami.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.utc_key.key_name
  vpc_security_group_ids = [module.app_sg.security_group_id]
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_s3_profile.name
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      team = "config management"
      env  = "dev"
    }
  }
}

## Auto Scaling Group
resource "aws_autoscaling_group" "utc_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = module.vpc.private_subnets
  launch_template {
    id      = aws_launch_template.utc_template.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.app_tg.arn]

  tag {
    key                 = "Name"
    value               = "utc-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.utc_asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.utc_asg.name
}


## SNS Topic & Subscription
resource "aws_sns_topic" "asg_topic" {
  name = "utc-auto-scaling"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.asg_topic.arn
  protocol  = "email"
  endpoint  = "team@example.com" # replace with your team email
}

resource "aws_autoscaling_notification" "utc_asg_notify" {
  group_names = [aws_autoscaling_group.utc_asg.name]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
  topic_arn = aws_sns_topic.asg_topic.arn
}


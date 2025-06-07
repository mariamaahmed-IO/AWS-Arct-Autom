resource "aws_lb" "app_lb" {
    name = "utc-alb"
    load_balancer_type = "application"
    subnets = module.vpc.public_subnets
    security_groups = [module.alb_sg.security_group_id]

    tags = {
      Name = "utc-alb"
      env = "dev"
      team = "config mangement"
    }
  
  
}
# --- Target Group ---
resource "aws_lb_target_group" "app_tg" {
name = "utc-target-group"
port = 80
protocol = "HTTP"
vpc_id = module.vpc.vpc_id

 health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"

}
tags = {
      Name = "utc-target-group"
      env = "dev"
      team = "config mangement"
      }
}

# --- Listener ---
# resource "aws_lb_listener" "app_listener" {
 # load_balancer_arn = aws_lb.app_lb.arn
  #port              = 80
  #protocol          = "HTTP"

  #default_action {
   # type             = "forward"
    #target_group_arn = aws_lb_target_group.app_tg.arn
#  }
#}

# --- ALB Target Group Attachment for EC2s ---
resource "aws_lb_target_group_attachment" "ec2_attachment" {
  count            = length(aws_instance.app_server)
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server[count.index].id
  port             = 80
}
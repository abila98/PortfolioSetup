# Create a new launch template
resource "aws_launch_template" "lt_1" {
  name_prefix   = "${var.tag_name}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  
  network_interfaces {
    subnet_id       = var.public_subnet_ids[0] # Selecting the first public subnet
    security_groups = [var.security_group_id]
  }
}

# Define a target group for load balancing
resource "aws_lb_target_group" "tg_1" {
  name     = "${var.tag_name}-tg"
  port     = 8080
  protocol = "HTTP" # Adjust protocol according to your application
  vpc_id   = var.vpc_id
  
  health_check {
    protocol            = "HTTP"
    port                = "8080"
    path                = "/portfolio/index.html"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Create a new Auto Scaling Group
resource "aws_autoscaling_group" "asg_1" {
  name                      = "${var.tag_name}-asg"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  health_check_type         = "ELB"
  health_check_grace_period = 60
  
  launch_template {
    id = aws_launch_template.lt_1.id
  }
  
  vpc_zone_identifier = var.private_subnet_ids
  
  target_group_arns = ["${aws_lb_target_group.tg_1.arn}"]
}

# Create Load Balancer
resource "aws_lb" "lb_1" {
  name               = "${var.tag_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false
}

# Create Listener Rule
resource "aws_lb_listener_rule" "lr_1" {
  listener_arn = aws_lb_listener.listener_1.arn
  priority     = 100
  
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_1.arn
  }
  
  condition {
    path_pattern {
      values = ["/portfolio/index.html"]
    }
  }
}

# Create Listener
resource "aws_lb_listener" "listener_1" {
  load_balancer_arn = aws_lb.lb_1.arn
  port              = "8080"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = "arn:aws:acm:us-west-1:481030671750:certificate/4eed5a2f-7d48-4a9f-bc18-c24428e489b8" 
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_1.arn
  }
}

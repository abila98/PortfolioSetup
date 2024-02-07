# Create a new launch template
resource "aws_launch_template" "lt_1" {
  name_prefix   = "kohee-lt"
  image_id      = "ami-0f9ae14ada80b3929"
  instance_type = "t2.micro"
  key_name      = "aws-key"
  network_interfaces {
    #associate_public_ip_address = true #if public setup
    subnet_id       = aws_subnet.private_1.id
    security_groups = [aws_security_group.sg_1.id]
  }
}

# Define a target group for load balancing
resource "aws_lb_target_group" "tg_1" {
  name     = "kohee-tg"
  port     = 8080
  protocol = "HTTP" # Adjust protocol according to your application
  vpc_id   = aws_vpc.vpc_1.id

  health_check {
    protocol            = "HTTP"                  # Protocol used for health checks
    port                = "8080"                  # Port to perform the health check on
    path                = "/coffeeapp/index.html" # Path to the health check endpoint on your application
    timeout             = 5                       # Timeout for health check in seconds
    interval            = 30                      # Interval between health checks in seconds
    healthy_threshold   = 2                       # Number of consecutive successful health checks required to consider the target healthy
    unhealthy_threshold = 2                       # Number of consecutive failed health checks required to consider the target unhealthy
    matcher             = "200"                   # HTTP response code expected from the health check endpoint
  }
}

# Create a new Auto Scaling Group
resource "aws_autoscaling_group" "asg_1" {
  name                      = "kohee-asg"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  health_check_type         = "ELB"
  health_check_grace_period = 60
  # enable_http2               = true
  launch_template {
    id = aws_launch_template.lt_1.id
  }

  vpc_zone_identifier = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  # Attach the ASG to a target group for load balancing
  target_group_arns = ["${aws_lb_target_group.tg_1.arn}"]
}

# Create Load Balancer
resource "aws_lb" "lb_1" {
  name               = "kohee-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_1.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

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
      values = ["/coffeeapp/index.html"]
    }
  }
}

# Create Listener
resource "aws_lb_listener" "listener_1" {
  load_balancer_arn = aws_lb.lb_1.arn
  port              = "8080"
  protocol          = "HTTP" # Adjust protocol according to your application

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_1.arn
  }
}

output "load_balancer_arn" {
  value = aws_lb.lb_1.arn 
}

output "alb_dns_name" {
  value = aws_lb.lb_1.dns_name
}

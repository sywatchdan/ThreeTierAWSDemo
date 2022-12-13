output "external_lb_hostname" {
  description = "The hostname of the external load balancer"
  value       = aws_lb.tt_external_alb.dns_name
}
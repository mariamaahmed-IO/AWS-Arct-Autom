# Route 53 and ACM Setup for UTC Project


## Route 53 Hosted Zone (Custom DNS Domain)

resource "aws_route53_zone" "utc_zone" {
  name = "StackedSoul.com"  # Replace with your actual registered domain
}


## ACM Certificate for HTTPS (Issued by AWS)
resource "aws_acm_certificate" "utc_cert" {
  domain_name       = "StackedSoul.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

### Step 6: DNS Validation Records 
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.utc_cert.domain_validation_options : dvo.domain_name => {
      record_name  = dvo.resource_record_name
      record_type  = dvo.resource_record_type
      record_value = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.utc_zone.zone_id
  name    = each.value.record_name
  type    = each.value.record_type
  ttl     = 60
  records = [each.value.record_value]

  depends_on = [aws_acm_certificate.utc_cert]
}

resource "aws_acm_certificate_validation" "utc_cert_validation" {
  certificate_arn         = aws_acm_certificate.utc_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}


## Listener for ALB (HTTPS Redirect)

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.utc_cert_validation.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

## Optional: HTTP Redirect to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

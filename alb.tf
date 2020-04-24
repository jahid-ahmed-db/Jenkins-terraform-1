#TG
# refer: https://www.terraform.io/docs/providers/aws/r/lb_target_group.html
resource "aws_lb_target_group" "maagc_target" {
  name     = "${var.ag_target}"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  health_check {
      interval = 30
      timeout  = 5
      healthy_threshold  = 3
      unhealthy_threshold  = 5
	
  }
  
}

resource "aws_lb" "maagc_alb_app" {
  name   = "${var.maagc_alb_app_name}"
  subnets     = "${compact(split(",", var.vpc_subnets_ids["subnets_ids"]))}"
  internal = true
  security_groups = "${compact(split(",", var.security_groups["security_groups"]))}"
}

resource "aws_lb_listener" "front_end_80" {
  load_balancer_arn = "${aws_lb.maagc_alb_app.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.maagc_target.arn}"
    type             = "forward"
  }
}


provider "aws" {
  region  = "us-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"

}

data "template_file" "init"{
  template = "${file("${var.user_data_path}")}"
}


resource "aws_launch_configuration" "launch_config" {
  name_prefix   = "jenkins-"
  image_id = "${var.image_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  security_groups = "${compact(split(",", var.security_groups["security_groups"]))}"
  root_block_device {
    volume_size = "30"
    delete_on_termination = true
  }
  associate_public_ip_address = true 
  user_data = "${data.template_file.init.rendered}"
  
  lifecycle              { 
	create_before_destroy = true 
	}
}
# refer : https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html
resource "aws_autoscaling_group" "maagc_asg" {
  name  = "${var.asg_name}"

  tag {
    key                 = "Name"
    value               = "${var.lc_name}"
    propagate_at_launch = false
  }

  dynamic "tag" {
    for_each = local.standard_tags

  content {
    key = tag.key
    value = tag.value
    propagate_at_launch = true
  }
  }

  # Uses the ID from the launch config created above or it can be launch_config.name
  launch_configuration = "${aws_launch_configuration.launch_config.id}"

  vpc_zone_identifier  = "${compact(split(",", var.vpc_subnets_ids["subnets_ids"]))}"

  max_size = "${var.asg_max_number_of_instances}"
  min_size = "${var.asg_minimum_number_of_instances}"
  desired_capacity     = "${var.desired_capacity}"

  target_group_arns = ["${aws_lb_target_group.maagc_target.arn}"]
  # force_delete = true

}

output "jenkins_ip_address" {
  value = "${aws_lb.maagc_alb_app.dns_name}"
}

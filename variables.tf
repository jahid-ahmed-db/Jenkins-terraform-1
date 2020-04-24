
variable "aws_access_key" {
  description = "Access key"
  default = "xxxxxxxxxxxxxxxxxxxxx"
}

variable "aws_secret_key" {
  description = "Secret key"
  default = "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

# Launch config

variable "vpc_id" {
  description = "The Vpc id"
  default = "vpc-023abxxxxxxxxxxxxxx"
}

variable "lc_name" {
  description = "name of the instance launched"
  default = "Jenkins"
}

variable "image_id" {
  description = "ID of AMI to use for the instance"
  default = "ami-0c322300a1dd5dc79"
}

variable "instance_type" {
  description = "The type of instance to start"
  default = "t2.large"
}

variable "key_name" {
  description = "The key name to use for the instance"
  default     = "maagc"
}

variable "user_data_path" {
  default = "./install_jenkins.sh"
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the launch configuration"
  type        = "map"
  default = { security_groups = "sg-0884dxxxxxxxxxx,sg-0707e8xxxxxxxxxxxxx" }
}

variable "vpc_subnets_ids" {
  type = "map"
  description = "A list of subnet IDs to associate with"
  default = {
    subnets_ids         = "subnet-0de41bxxxxxxxxxxxx,subnet-033e3e3xxxxxxxxxxx"
  }
}

# ASG

variable "asg_name" {
  description = "name of the ASG"
  default = "maagc-asg"
}

variable "asg_max_number_of_instances" {
  description = "Maximum number of instance in ASG"
  default = 2
}

variable "asg_minimum_number_of_instances" {
  description = "Minimum number of instances in ASG"
  default = 1
}

variable "desired_capacity" {
  description = "Minimum number of instances in ASG"
  default = 1
}


variable "ag_target" {
  default = "jenkins-target"
}

variable "maagc_alb_app_name" {
  default = "jenkins-ALB"
}

locals {
    standard_tags = {
        Application = "jenkins"
        ResorceOwner = "doppalapudisaikumar@gmail.com"
    }
}

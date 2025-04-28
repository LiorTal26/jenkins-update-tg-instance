provider "aws" {
  region = "il-central-1"
}
data "aws_subnets" "private" {
  
  filter {
    name   = "availability-zone"
    values = ["il-central-1a", "il-central-1b"]
  }

}
locals{
  ami_id = "ami-0ae7e1e8fb8251940"
  subnets = [
    "subnet-01e6348062924d048",
    "subnet-0a1cbd99dd27a5307",
    "subnet-2p3q4r5s6t7u8v9w0",
    "subnet-3x4y5z6a7b8c9d0e1"
  ]
}

data "aws_lb_target_group" "app_tg" {
  name = "tg-lior"
}

# single launch_template for all ASG
resource "aws_launch_template" "example" {
  name_prefix   = "asg-lior-terraform-"
  image_id      = local.ami_id
  instance_type = "t2.micro"
}

# create number of ASG with index counter name
resource "aws_autoscaling_group" "lior" {
  count                = 3
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier  = local.subnets
  health_check_type    = "EC2"
  name               = "asg-lior-terraform-${count.index + 1}"

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "lior-${count.index +1}"
    propagate_at_launch = true
  }
}

output "launch_template_id" {
  value = aws_launch_template.example.id
}

output "asg_names"{
  description = "List of ASG names"
  value      = aws_autoscaling_group.lior[*].name
}

output "tg_arn" {
  description = "ARN of ALB Target Group by name"
  value      = data.aws_lb_target_group.app_tg.arn
}
resource "aws_launch_template" "lior" {
  name_prefix   = "asg-lior-terra"
  image_id      = "ami-0ae7e1e8fb8251940"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "bar" {
  availability_zones = ["il-central-1a", "il-central-1b"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }
}
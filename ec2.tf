
# Presentation Launch Template
resource "aws_launch_template" "tt_presentation_launchtemplate" {
  name                   = "${var.naming_prefix}-Presentation-Template"
  image_id               = var.ec2_presentation_ami_id
  instance_type          = "t2.micro"
  user_data              = base64encode(file("presentation_userdata.sh"))
  vpc_security_group_ids = [aws_security_group.tt_presentation_sg.id]
}

# Presentation Autoscaling Group
resource "aws_autoscaling_group" "tt_presentation_asg" {
  name                = "${var.naming_prefix}-Presentation-ASG"
  vpc_zone_identifier = [aws_subnet.tt_public_subnet_1.id, aws_subnet.tt_public_subnet_2.id]
  desired_capacity    = var.ec2_presentation_instances_desired
  max_size            = var.ec2_presentation_instances_max
  min_size            = var.ec2_presentation_instances_min

  launch_template {
    id      = aws_launch_template.tt_presentation_launchtemplate.id
    version = "$Latest"
  }
}

#External Load Balancer
resource "aws_lb" "tt_external_alb" {
  name               = "${var.naming_prefix}-External-Load-Balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tt_presentation_sg.id]
  subnets            = [aws_subnet.tt_public_subnet_1.id, aws_subnet.tt_public_subnet_2.id]
}

resource "aws_lb_target_group" "tt_external_alb_tg" {
  name     = "${var.naming_prefix}-External-ALB-Target-Group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tt_vpc.id
}

resource "aws_autoscaling_attachment" "tt_external_alb_attachment" {
  autoscaling_group_name = aws_autoscaling_group.tt_presentation_asg.id
  lb_target_group_arn    = aws_lb_target_group.tt_external_alb_tg.arn
}

resource "aws_lb_listener" "tt_external_alb_listener" {
  load_balancer_arn = aws_lb.tt_external_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tt_external_alb_tg.arn
  }
}

# Application Launch Template
resource "aws_launch_template" "tt_application_launchtemplate" {
  name                   = "${var.naming_prefix}-Application-Template"
  image_id               = var.ec2_application_ami_id
  instance_type          = "t2.micro"
  user_data              = base64encode(file("application_userdata.sh"))
  vpc_security_group_ids = [aws_security_group.tt_application_sg.id]
}

# Application Autoscaling Group
resource "aws_autoscaling_group" "tt_application_asg" {
  name                = "${var.naming_prefix}-Application-ASG"
  vpc_zone_identifier = [aws_subnet.tt_application_subnet_1.id, aws_subnet.tt_application_subnet_2.id]
  desired_capacity    = var.ec2_application_instances_desired
  max_size            = var.ec2_application_instances_max
  min_size            = var.ec2_application_instances_min

  launch_template {
    id      = aws_launch_template.tt_application_launchtemplate.id
    version = "$Latest"
  }
}

#Internal Load Balancer
resource "aws_lb" "tt_internal_alb" {
  name               = "${var.naming_prefix}-Internal-Load-Balancer"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tt_application_sg.id]
  subnets            = [aws_subnet.tt_application_subnet_1.id, aws_subnet.tt_application_subnet_2.id]
}

resource "aws_lb_target_group" "tt_internal_alb_tg" {
  name     = "${var.naming_prefix}-Internal-ALB-Target-Group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tt_vpc.id
}

resource "aws_autoscaling_attachment" "tt_internal_alb_attachment" {
  autoscaling_group_name = aws_autoscaling_group.tt_application_asg.id
  lb_target_group_arn    = aws_lb_target_group.tt_internal_alb_tg.arn
}

resource "aws_lb_listener" "tt_internal_alb_listener" {
  load_balancer_arn = aws_lb.tt_internal_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tt_internal_alb_tg.arn
  }
}

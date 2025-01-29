resource "aws_lb" "main" {
  name               = "balanceador mean"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.node_security_id, var.mongo_security_id]
  subnets            = var.subnet_ids

  tags = {
    Name = "NodeLoadBalancer"
  }
}

resource "aws_lb_target_group" "node" {
  name     = "node-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.node.arn
  }
}

resource "aws_lb_target_group_attachment" "node" {
  target_group_arn = aws_lb_target_group.node.arn
  target_id        = var.node_instance_id
  port             = 80
}

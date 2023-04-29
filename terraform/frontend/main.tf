resource "aws_security_group" "security_group_svc_sg_frontend" {
  name        = format("%v-%v-svc-sg-frontend", var.project_name, var.environment)
  description = "Security group attached to service"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow Traffic from internal alb"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = format("%v-%v-svc-sg-frontend", var.project_name, var.environment)
  }
}

resource "aws_cloudwatch_log_group" "svc_log_group_frontend" {
  name              = format("/ecs/%v-%v-frontend", var.project_name, var.environment)
  retention_in_days = var.retention_in_days
}

resource "aws_ecs_task_definition" "task_definition_frontend" {
  family = format("%v-%v-task-frontend", var.project_name, var.environment)

  container_definitions = jsonencode([
    {
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = var.aws_region
          awslogs-group         = format("/ecs/%v-%v-frontend", var.project_name, var.environment)
          awslogs-stream-prefix = "ecs"
        }
      }

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]

      image = var.frontend_image_uri

      linuxParameters = {
        initProcessEnabled = true
      }

      essential = true
      name      = format("%v-%v-frontend", var.project_name, var.environment)

    }
  ])

  execution_role_arn       = aws_iam_role.task_execution_role.arn
  memory                   = var.memory
  task_role_arn            = aws_iam_role.task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu

  depends_on = [aws_cloudwatch_log_group.svc_log_group_frontend]
}

resource "aws_ecs_service" "service_frontend" {
  name            = format("%v-%v-service-frontend", var.project_name, var.environment)
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.task_definition_frontend.arn

  desired_count = var.desired_count

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = "1"
  }

  enable_ecs_managed_tags = true
  enable_execute_command  = true

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_3000.arn
    container_name   = format("%v-%v-frontend", var.project_name, var.environment)
    container_port   = 3000
  }

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = [aws_security_group.security_group_svc_sg_frontend.id]
    assign_public_ip = true
  }

  propagate_tags = "SERVICE"

  wait_for_steady_state = false

  depends_on = [aws_ecs_task_definition.task_definition_frontend, aws_lb.internet_facing_alb_frontend]
}


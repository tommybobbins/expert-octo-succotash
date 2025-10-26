[
    {
      "name": "ecs-efs",
      "image": "${image}",
      "cpu": ${cpu},
      "memory": ${memory},
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${container_port},
          "hostPort": ${container_port},
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "TEST_DB",
          "value": "foo"
        }
      ],
      "secrets": [
      ],
      "mountPoints": [
        {
          "containerPath": "/var/lib/grafana",
          "sourceVolume": "grafana-storage"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${log_group}",
          "awslogs-region": "${region}",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
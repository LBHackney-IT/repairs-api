[
  {
    "name": "repairs-api",
    "image": "${aws_account}.dkr.ecr.${aws_region}.amazonaws.com/repairs-api/${environment}:latest",
    "command": ["bundle", "exec", "rails", "server"],
    "portMappings": [
      {
        "containerPort": 3000,
        "protocol": "tcp",
        "hostPort": 3000
      }
    ],
    "memory": 300,
    "networkMode": "awsvpc",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "repairs-api-web-${environment}",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "web"
      }
    },
    "environment": [
      {
        "name": "RAILS_ENV",
        "value": "production"
      },
      {
        "name": "RACK_ENV",
        "value": "production"
      },
      {
        "name": "NODE_ENV",
        "value": "production"
      },
      {
        "name": "PORT",
        "value": "3000"
      },
      {
        "name": "RAILS_LOG_TO_STDOUT",
        "value": "true"
      },
      {
        "name": "RAILS_SERVE_STATIC_FILES",
        "value": "true"
      }
    ],
    "secrets": [
      {
        "name": "DATABASE_URL",
        "valueFrom": "arn:aws:ssm:${aws_region}:${aws_account}:parameter/repairs-api/${environment}/DATABASE_URL"
      },
      {
        "name": "RAILS_MASTER_KEY",
        "valueFrom": "arn:aws:ssm:${aws_region}:${aws_account}:parameter/repairs-api/${environment}/RAILS_MASTER_KEY"
      }
    ]
  }
]

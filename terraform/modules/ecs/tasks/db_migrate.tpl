[
  {
    "name": "repairs-api",
    "image": "${aws_account}.dkr.ecr.${aws_region}.amazonaws.com/repairs-api/${environment}:latest",
    "command": ["bundle", "exec", "rails", "db:migrate"],
    "memory": 300,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "repairs-api-db-migrate-${environment}",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "db_migrate"
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
      },
      {
        "name": "DISABLE_DATABASE_ENVIRONMENT_CHECK",
        "value": "1"
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

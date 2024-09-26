### First we create a dummy secret;

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "dbCredentials"
  description = "Credentials for DynamoDB access"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "compie",
    password = "technologies"
  })
}

resource "aws_secretsmanager_secret_policy" "secret_policy" {
  secret_arn = aws_secretsmanager_secret.db_credentials.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Sid:       "AllowReadOnlyAccess",
        Effect:    "Allow",
        Principal: {
          AWS: "arn:aws:iam::730335278872:root" # This is a dummy AWS account ID, replace with a real one to test the policy
        },
        Action: [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource: "*"
      }
    ]
  })
}

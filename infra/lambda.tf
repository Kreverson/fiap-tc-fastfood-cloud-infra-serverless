# IAM Role para a Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, { "Environment" = var.environment })
}

# Lambda Function
resource "aws_lambda_function" "fastfood_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"  # Pode ser ajustado conforme necessário

  filename = "lambda_function.zip"  # Código da Lambda zipado

  environment {
    variables = {
      COGNITO_USER_POOL_ID = aws_cognito_user_pool.fastfood_user_pool.id
    }
  }

  tags = merge(var.tags, { "Environment" = var.environment })
}

# Permissão para o API Gateway invocar a Lambda
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fastfood_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

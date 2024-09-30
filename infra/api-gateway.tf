# Criação do API Gateway
resource "aws_api_gateway_rest_api" "fastfood_api" {
  name = var.api_gateway_name

  tags = merge(var.tags, { "Environment" = var.environment })
}

# Criação do recurso /api
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.fastfood_api.id
  parent_id   = aws_api_gateway_rest_api.fastfood_api.root_resource_id
  path_part   = "api"
}

# Método GET para o API Gateway (pode ser integrado ao EKS ou Lambda)
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.fastfood_api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

# Integração com Lambda
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.fastfood_api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.fastfood_lambda.invoke_arn
}

# Cognito Authorizer para o API Gateway
resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  rest_api_id = aws_api_gateway_rest_api.fastfood_api.id
  name        = "CognitoAuthorizer"
  type        = "COGNITO_USER_POOLS"
  provider_arns = [
    aws_cognito_user_pool.fastfood_user_pool.arn
  ]
}

# Deploy do API Gateway
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [aws_api_gateway_method.get_method]
  rest_api_id = aws_api_gateway_rest_api.fastfood_api.id
  stage_name  = var.environment
}

output "api_gateway_id" {
  description = "ID do API Gateway"
  value       = aws_api_gateway_rest_api.fastfood_api.id
}

output "lambda_function_arn" {
  description = "ARN da função Lambda"
  value       = aws_lambda_function.fastfood_lambda.arn
}

output "cognito_user_pool_id" {
  description = "ID do Cognito User Pool"
  value       = aws_cognito_user_pool.fastfood_user_pool.id
}

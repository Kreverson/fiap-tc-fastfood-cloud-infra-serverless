aws_region  = "us-east-2"
state_file   = "kreverson-us-east-2-terraform-statefile"
environment          = "prod"
api_gateway_name     = "FastfoodAPIGatewayProd"
lambda_function_name = "FastfoodLambdaProd"
lambda_role_name     = "FastfoodLambdaRoleProd"
user_pool_name       = "FastfoodUserPoolProd"
identity_pool_name   = "FastfoodIdentityPoolProd"
client_name          = "FastfoodUserPoolClientProd"

tags = {
  Environment = "prod"
  Project     = "fastfood"
}

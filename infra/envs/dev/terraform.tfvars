aws_region  = "us-east-2"
state_file   = "kreverson-us-east-2-terraform-statefile"
environment          = "dev"
api_gateway_name     = "FastfoodAPIGatewayDev"
lambda_function_name = "FastfoodLambdaDev"
lambda_role_name     = "FastfoodLambdaRoleDev"
user_pool_name       = "FastfoodUserPoolDev"
identity_pool_name   = "FastfoodIdentityPoolDev"
client_name          = "FastfoodUserPoolClientDev"

tags = {
  Environment = "dev"
  Project     = "fastfood"
}

variable "aws_region" {
  description = "AWS região"
  type = string
}

variable "state_file" {
  description = "S3 Bucket state file"
  type = string
}

variable "environment" {
  description = "Ambiente (dev ou prod)"
  type        = string
}

# Variáveis para o API Gateway
variable "api_gateway_name" {
  description = "Nome do API Gateway"
  type        = string
}

# Variáveis para Lambda
variable "lambda_function_name" {
  description = "Nome da função Lambda"
  type        = string
}

variable "lambda_role_name" {
  description = "Nome da role para a Lambda"
  type        = string
}

# Cognito (se precisar reutilizar)
variable "user_pool_name" {
  description = "Nome do Cognito User Pool"
  type        = string
}

variable "identity_pool_name" {
  description = "Nome do Cognito Identity Pool"
  type        = string
}

variable "client_name" {
  description = "Nome do Cognito User Pool Client"
  type        = string
}

# Tags
variable "tags" {
  description = "Tags padrão para os recursos"
  type        = map(string)
  default     = {
    Project = "fastfood"
  }
}

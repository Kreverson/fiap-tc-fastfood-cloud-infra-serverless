# Cognito User Pool
resource "aws_cognito_user_pool" "fastfood_user_pool" {
  name = var.user_pool_name

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
  }

  username_attributes = ["phone_number"]
  auto_verified_attributes = ["phone_number"]

  tags = merge(var.tags, { "Environment" = var.environment })
}

# Cognito User Pool Client
resource "aws_cognito_user_pool_client" "fastfood_user_pool_client" {
  name         = var.client_name
  user_pool_id = aws_cognito_user_pool.fastfood_user_pool.id
  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

# Cognito Identity Pool
resource "aws_cognito_identity_pool" "fastfood_identity_pool" {
  identity_pool_name               = var.identity_pool_name
  allow_unauthenticated_identities = true

  cognito_identity_providers {
    client_id   = aws_cognito_user_pool_client.fastfood_user_pool_client.id
    provider_name = aws_cognito_user_pool.fastfood_user_pool.endpoint
  }

  tags = merge(var.tags, { "Environment" = var.environment })
}

# IAM Role para usuários autenticados
resource "aws_iam_role" "cognito_authenticated_role" {
  name = var.auth_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          "StringEquals": {
            "cognito-identity.amazonaws.com:aud": aws_cognito_identity_pool.fastfood_identity_pool.id
          },
          "ForAnyValue:StringLike": {
            "cognito-identity.amazonaws.com:amr": "authenticated"
          }
        }
      }
    ]
  })

  inline_policy {
    name = "authenticated_policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect   = "Allow",
          Action   = "execute-api:Invoke",
          Resource = "*"
        }
      ]
    })
  }

  tags = merge(var.tags, { "Environment" = var.environment })
}

# IAM Role para usuários anônimos
resource "aws_iam_role" "cognito_unauthenticated_role" {
  name = var.unauth_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          "StringEquals": {
            "cognito-identity.amazonaws.com:aud": aws_cognito_identity_pool.fastfood_identity_pool.id
          },
          "ForAnyValue:StringLike": {
            "cognito-identity.amazonaws.com:amr": "unauthenticated"
          }
        }
      }
    ]
  })

  inline_policy {
    name = "unauthenticated_policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect   = "Allow",
          Action   = "execute-api:Invoke",
          Resource = "*"
        }
      ]
    })
  }

  tags = merge(var.tags, { "Environment" = var.environment })
}

# Associando Roles ao Identity Pool
resource "aws_cognito_identity_pool_roles_attachment" "identity_pool_roles" {
  identity_pool_id = aws_cognito_identity_pool.fastfood_identity_pool.id

  roles = {
    authenticated   = aws_iam_role.cognito_authenticated_role.arn
    unauthenticated = aws_iam_role.cognito_unauthenticated_role.arn
  }
}

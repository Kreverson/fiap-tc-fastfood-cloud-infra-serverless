terraform {
  backend "s3" {
    bucket = var.state_file
    key    = "${var.environment}/api-gateway-lambda/terraform.tfstate"
    region = var.aws_region
  }
}

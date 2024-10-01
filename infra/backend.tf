terraform {
  backend "s3" {
    bucket = var.state_file
    key    = "${var.environment}/serverless/terraform.tfstate"
    region = var.aws_region
  }
}

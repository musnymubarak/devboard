terraform {
  backend "s3" {
    bucket         = "devboard-terraform-state-322725461163"
    key            = "devboard/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "devboard-terraform-locks"
    encrypt        = true
  }
}
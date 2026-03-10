terraform {
  backend "s3" {
    bucket       = "devboard-terraform-state-322725461163"
    key          = "devboard/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

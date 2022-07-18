terraform {
  backend "s3" {
    bucket = "talent-academy-sudha-lab-tfstates"
    key = "talent-academy/backend/terraform.tfstates"
    region = "eu-west-1"
  }
}
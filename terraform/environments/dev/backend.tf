terraform {
  backend "s3" {
    bucket = "sre-kata1"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_s3_bucket" "test" {
  bucket = "sre-kata1"
}

resource "aws_ecrpublic_repository" "kata" {
  provider = aws.us_east_1

  repository_name = "kata"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

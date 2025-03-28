terraform {
  backend "s3" {
    bucket = "ascbackendstate"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

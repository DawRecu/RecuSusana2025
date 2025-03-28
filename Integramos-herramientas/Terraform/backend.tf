terraform {
  backend "s3" {
    bucket = var.nameS3
    key    = "terraform.tfstate"
    region = var.region
  }
}

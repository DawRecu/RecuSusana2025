terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}


#? Creación del bucket para hacerlo servidor web
resource "aws_s3_bucket" "ParisIA" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name        = "Paris-IA-Despliegue"
    Environment = "Dev"
  }
}

#? Para hacer el bucket público
resource "aws_s3_bucket_public_access_block" "bucket-public-access" {
  bucket = aws_s3_bucket.ParisIA.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#? Creación de la política
resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.ParisIA.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "s3:GetObject",
          "Effect" : "Allow",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.ParisIA.bucket}/*",
          "Principal" : "*"
        }
      ]
    }
  )
}

#? Hacerlo servidor web
resource "aws_s3_bucket_website_configuration" "bucket-web-config" {
  bucket = aws_s3_bucket.ParisIA.id

  index_document {
    suffix = "index.html"
  }
}

#? Soy el propietario del bucket
resource "aws_s3_bucket_ownership_controls" "bucket-owner" {
  bucket = aws_s3_bucket.ParisIA.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#? Deshabilito la seguridad por defecto del Bucket S3 para hacer los objetos publicos
resource "aws_s3_bucket_acl" "bucket-acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket-owner,
    aws_s3_bucket_public_access_block.bucket-public-access,
  ]

  bucket = aws_s3_bucket.ParisIA.id
  acl    = "public-read"
}

#? Leer el archivo JSON generado por el script
# data "local_file" "file_list" {
#   filename = "files_list.json"
# }

#? Añado los archivos al bucket
# resource "aws_s3_object" "upload_files" {
#   for_each = { for idx, file in jsondecode(data.local_file.file_list.content) : idx => file }
# 
#   bucket       = aws_s3_bucket.ParisIA.bucket
#   key          = each.value.key
#   source       = each.value.source
#   content_type = each.value.content_type
# }


# Output para la URL del bucket S3
output "s3_bucket_website_url" {
  value = "http://${aws_s3_bucket.ParisIA.bucket}.s3-website-us-east-1.amazonaws.com"
}

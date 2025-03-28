#? Crear el Bucket S3 para almacenar el estado de Terraform
resource "aws_s3_bucket" "BackendTerraformState" {
  bucket        = var.nameS3
  force_destroy = true

  tags = {
    Name        = var.nameS3
    Environment = "Dev"
  }
}

#? Crear la política de acceso para el Bucket (para el archivo terraform.tfstate)
resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.BackendTerraformState.id

  policy = jsonencode(
    {
      "Id" : "PolicyTerraformStateAccess",
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowTerraformAccess",
          "Action" : [
            "s3:GetObject",
          ],
          "Effect" : "Allow",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.BackendTerraformState.bucket}/*",
          "Principal" : "*"
        }
      ]
    }
  )
}

# Bloquear el acceso público para el bucket de estado de terraform
resource "aws_s3_bucket_public_access_block" "bucket-public-access" {
  bucket = aws_s3_bucket.BackendTerraformState.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Propietario del Bucket para tener control sobre los objetos subidos
resource "aws_s3_bucket_ownership_controls" "bucket-owner" {
  bucket = aws_s3_bucket.BackendTerraformState.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

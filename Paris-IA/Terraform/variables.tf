variable "region" {
  description = "Variable que indica la región en la que estaremos con AWS"
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  description = "Nombre del bucket S3"
  type = string
}

variable "file_path" {
	description = "Directorio de archivos a subir"
	type        = string
}
variable "region" {
  description = "La región de AWS que usamos."
  default     = "us-east-1" #? El valor por defecto
}

variable "imagenEc2" {
  description = "El id de la imagen usada para la EC2"
  type = string
}

variable "name" {
  description = "El nombre que se le pondra a los tag de los recursos"
  type = string
  default     = "MyResource"
}
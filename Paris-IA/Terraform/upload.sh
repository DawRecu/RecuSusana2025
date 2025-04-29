#!/bin/bash

# Directorio local que quieres subir
local_dir=$1
output_file=$2

# Asociaciones de tipos MIME según la extensión de archivo
declare -A mime_types
mime_types=(
  [".html"]="text/html"
  [".css"]="text/css"
  [".js"]="application/javascript"
  [".jpg"]="image/jpeg"
  [".jpeg"]="image/jpeg"
  [".png"]="image/png"
  [".webp"]="image/webp"
)

# Crear un array para almacenar los archivos y sus tipos MIME
file_list="["

# Recorrer los archivos del directorio y obtener el tipo MIME
for file in $(find "$local_dir" -type f); do
  extension="${file##*.}"
  mime_type="${mime_types[.$extension]}"
  
  # Si el archivo tiene un tipo MIME, lo agregamos a la lista
  if [ ! -z "$mime_type" ]; then
    file_list+="{\"source\": \"$file\", \"key\": \"${file#"$local_dir"/}\", \"content_type\": \"$mime_type\"},"
  fi
done

# Eliminar la última coma
file_list="${file_list%,}"

# Cerrar el array y escribir en el archivo JSON
file_list+="]"

echo $file_list > $output_file

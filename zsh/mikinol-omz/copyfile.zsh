# Копирование файла в буфер как объект для вставки
copyfile() {
  if [[ -z "$1" ]]; then
    echo "Usage: copyfile <file>"
    return 1
  fi

  local file_path
  file_path=$(realpath "$1")

  if [[ ! -f "$file_path" ]]; then
    echo "Error: File '$1' does not exist"
    return 1
  fi

  # Создаём URI и копируем в буфер
  printf "file://%s\n" "$file_path" | wl-copy -t text/uri-list
  echo "File '$1' copied to clipboard as a file"
}


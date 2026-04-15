#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BUF_SIZE 64

const char letters[53] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
const char numbers[10] = "0123456789";
const char symbols[25] = "!@#$%^&*()_+[]{}|;:',.<>?";

int main(int argc, char **argv) {
  if (argc < 3) {
    fprintf(stderr,
            "Недостаточно агрументов, ./a.out <длинна пароля> <количество "
            "паролей> (+s включает специальные символы) (-c выключает символы) "
            "(-n выключает цифры)\n");
    return 1;
  }

  char *end;
  unsigned long long length = strtoull(argv[1], &end, 10);

  if (end == argv[1] || *end != '\0') {
    fprintf(stderr, "Ошибка парсинга аргументов: длинна пароля не число\n");
    return 1;
  }

  unsigned long long count = strtoull(argv[2], &end, 10);

  if (end == argv[1] || *end != '\0') {
    fprintf(stderr,
            "Ошибка парсинга аргументов: количество паролей не число\n");
    return 1;
  }

  bool contains_chars = true;
  bool contains_symbols = false;
  bool contains_numbers = true;

  for (int i = 3; i < argc; i++) {
    char *arg = argv[i];

    if (strlen(arg) != 2 || (arg[0] != '+' && arg[0] != '-')) {
      fprintf(stderr, "Проигнорирован неверный флаг: %s\n", arg);
      continue;
    }

    bool state = (arg[0] == '+');

    switch (arg[1]) {
    case 'c':
      contains_chars = state;
      break;
    case 's':
      contains_symbols = state;
      break;
    case 'n':
      contains_numbers = state;
      break;
    default:
      fprintf(stderr, "Неизвестный тип флага: %c\n", arg[1]);
    }
  }

  char pool[256];
  unsigned char pool_size = 0;

  if (contains_chars) {
    memcpy(pool + pool_size, letters, strlen(letters));
    pool_size += strlen(letters);
  }
  if (contains_numbers) {
    memcpy(pool + pool_size, numbers, strlen(numbers));
    pool_size += strlen(numbers);
  }
  if (contains_symbols) {
    memcpy(pool + pool_size, symbols, strlen(symbols));
    pool_size += strlen(symbols);
  }

  unsigned char buffer[BUF_SIZE];
  int bytes_read = 0;
  int current_byte = 0;

  int urandom_fd = open("/dev/urandom", O_RDONLY);
  if (urandom_fd < 0) {
    perror("Ошибка открытия /dev/urandom");
    return 1;
  }

  for (int i = 0; i < count; i++) {
    for (int j = 0; j < length; j++) {
      unsigned char byte;
      while (1) {
        if (current_byte >= bytes_read) {
          bytes_read = read(urandom_fd, buffer, BUF_SIZE);
          if (bytes_read <= 0)
            exit(1);
          current_byte = 0;
        }

        byte = buffer[current_byte++];
        if (byte < pool_size - 1)
          break;
      }
      putchar(pool[byte % pool_size]);
    }
    putchar('\n');
  }

  close(urandom_fd);
  return 0;
}

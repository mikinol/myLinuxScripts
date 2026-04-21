#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/random.h>
#include <sys/syscall.h>
#include <unistd.h>

#define BUF_SIZE 64

const char letters[53] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
const char numbers[10] = "0123456789";
const char symbols[25] = "!@#$%^&*()_+[]{}|;:',.<>?";

const char *dicts[3] = {
    "0123456789ABCDEF", // HEX с большими  буквами
    "0123456789abcdef", // HEX с маленькими буквами
};

enum dictionaries { HEX_UPPER = 0, HEX_LOWER = 1, IPv6 = 1, UNKNOWN = -1 };

enum dictionaries parse_dict(const char *arg) {
  if (strcmp(arg, "hexupper") == 0)
    return HEX_UPPER;
  if (strcmp(arg, "hexlower") == 0)
    return HEX_LOWER;
  return UNKNOWN;
}

int main(int argc, char **argv) {
  if (argc < 3) {
    fprintf(stderr,
            "Недостаточно агрументов, password_gen <длинна пароля> <количество "
            "паролей> (+s включает специальные символы) (-c выключает символы) "
            "(-n выключает цифры)\nИли можно password_gen <длинна пароля> "
            "<количество паролей> <список доступных символов>\nИ ещё можно "
            "использовать другие словари password_gen <длинна пароля> "
            "<количество паролей> @<название словаря>\nСловари:\n- hexupper — "
            "HEX с большими буквами\n- hexlower — HEX с маленькими буквами");
    return 1;
  }

  char *end;
  unsigned long long length = strtoull(argv[1], &end, 10);

  if (end == argv[1] || *end != '\0') {
    fprintf(stderr, "Ошибка парсинга аргументов: длинна пароля не число\n");
    return 1;
  }

  unsigned long long count = strtoull(argv[2], &end, 10);

  if (end == argv[2] || *end != '\0') {
    fprintf(stderr,
            "Ошибка парсинга аргументов: количество паролей не число\n");
    return 1;
  }

  bool contains_chars = true;
  bool contains_symbols = false;
  bool contains_numbers = true;

  if (argc > 3 && (*argv[3] == '-' || *argv[3] == '+')) {
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
  }

  char pool[256];
  enum dictionaries dict = UNKNOWN;
  int pool_size = 0;

  if (argc > 3 && *argv[3] == '@') {
    dict = parse_dict(argv[3] + 1);

    if (dict == UNKNOWN) {
      fprintf(stderr, "Неизвестный словарь: %s\n", argv[3] + 1);
      exit(1);
    }

    pool_size = strlen(dicts[dict]);
    memcpy(pool, dicts[dict], pool_size);
  } else if (argc > 3 && *argv[3] != '-' && *argv[3] != '+') {
    char *src = argv[3];
    pool_size = strlen(src);

    if (pool_size > sizeof(pool)) {
      fprintf(stderr, "Ошибка парсинга аргументов: словарь, имеет больше чем "
                      "256 символов\n");
      return 1;
    }

    memcpy(pool, src, pool_size);
  } else {
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
  }

  if (pool_size == 0) {
    fprintf(stderr, "Ошибка: количество доступных символов = 0\n");
    return 1;
  }

  unsigned char buffer[BUF_SIZE];
  bool is_four = pool_size <= 16;
  int limit = (is_four ? 16 : 256) - ((is_four ? 16 : 256) % pool_size);
  int bytes_read = 0;
  int current_byte = 0;

  for (int i = 0; i < count; i++) {
    for (int j = 0; j < length; j++) {
      unsigned char byte;
      while (1) {
        if (current_byte >= bytes_read) {
          bytes_read = syscall(SYS_getrandom, buffer, BUF_SIZE, 0);
          if (bytes_read <= 0) {
            perror("getrandom failed");
            exit(1);
          }

          if (is_four)
            bytes_read = bytes_read * 2;
          current_byte = 0;
        }

        if (is_four) {
          byte = buffer[current_byte >> 1];
          byte = (byte >> ((1 - (current_byte & 1)) << 2)) & 0x0F;
          current_byte++;
        } else {
          byte = buffer[current_byte++];
        }

        if (byte < limit)
          break;
      }
      putchar(pool[byte % pool_size]);
    }
    putchar('\n');
  }

  return 0;
}

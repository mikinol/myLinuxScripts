#include "../nolibc/nolibc.h"

#define BUF_SIZE 64

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

void help() {
  fprintf(
      stderr,
      "Недостаточно агрументов, "
      "password_gen <длинна пароля> <количество паролей> (+s включает специальные символы) (-c выключает символы) (-n выключает цифры)\n"
      "Или можно password_gen <длинна пароля> <количество паролей> <список доступных символов>\n"
      "И ещё можно использовать другие словари "
      "password_gen <длинна пароля> <количество паролей> @<название словаря>\n"
      "Словари:\n"
      "- hexupper — HEX с большими буквами\n"
      "- hexlower — HEX с маленькими буквами\n");
  exit(1);
}

void parse_length_and_count(unsigned long long *length, unsigned long long *count, char **argv) {
  char *end;

  *length = strtoull(argv[1], &end, 10);

  if (end == argv[1] || *end != '\0') {
    fprintf(stderr, "Ошибка парсинга аргументов: длинна пароля не число\n");
    exit(1);
  }

  *count = strtoull(argv[2], &end, 10);

  if (end == argv[2] || *end != '\0') {
    fprintf(stderr, "Ошибка парсинга аргументов: количество паролей не число\n");
    exit(1);
  }
}

void parse_predefined_dictionary_from_argv(enum dictionaries *dict, int *pool_size, char *pool, char **argv) {
  *dict = parse_dict(argv[3] + 1);

  if (*dict == UNKNOWN) {
    fprintf(stderr, "Неизвестный словарь: %s\n", argv[3] + 1);
    exit(1);
  }

  *pool_size = strlen(dicts[*dict]);
  memcpy(pool, dicts[*dict], *pool_size);
}

void parse_dictionary_from_argv(int *pool_size, char *pool, char **argv) {
  char *src = argv[3];
  *pool_size = strlen(src);

  if (*pool_size > 256) {
    fprintf(stderr, "Ошибка парсинга аргументов: словарь, имеет больше чем "
                    "256 символов\n");
    exit(1);
  }

  memcpy(pool, src, *pool_size);
}

void parse_contains_dictionary_from_argv(int *pool_size, char *pool, const int argc, char **argv) {
  const char letters[52] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  const char numbers[10] = "0123456789";
  const char symbols[25] = "!@#$%^&*()_+[]{}|;:',.<>?";

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

  if (contains_chars) {
    memcpy(pool + *pool_size, letters, sizeof(letters));
    *pool_size += sizeof(letters);
  }
  if (contains_numbers) {
    memcpy(pool + *pool_size, numbers, sizeof(numbers));
    *pool_size += sizeof(numbers);
  }
  if (contains_symbols) {
    memcpy(pool + *pool_size, symbols, sizeof(symbols));
    *pool_size += sizeof(symbols);
  }
}

int main(int argc, char **argv) {
  if (argc < 3) {
    help();
  }

  unsigned long long length, count;
  parse_length_and_count(&length, &count, argv);

  char pool[256];
  int pool_size = 0;

  enum dictionaries dict = UNKNOWN;

  if (argc > 3 && *argv[3] == '@') {
    parse_predefined_dictionary_from_argv(&dict, &pool_size, pool, argv);
  } else if (argc > 3 && *argv[3] != '-' && *argv[3] != '+') {
    parse_dictionary_from_argv(&pool_size, pool, argv);
  } else if (argc == 3 || (argc > 3 && (*argv[3] == '-' || *argv[3] == '+'))) {
    parse_contains_dictionary_from_argv(&pool_size, pool, argc, argv);
  }

  if (pool_size == 0) {
    fprintf(stderr, "Ошибка: количество доступных символов = 0\n");
    return 1;
  }

  unsigned char buffer[BUF_SIZE];
  const bool is_four = pool_size <= 16;

  int limit = (is_four ? 16 : 256) - ((is_four ? 16 : 256) % pool_size);

  int bytes_read = 0;
  int current_byte = 0;

  char writebuffer[16384];
  int current_write_byte = 0;

  int current_password = 0;
  int current_password_char = 0;

  unsigned char byte;
  while (true) {
    if (current_byte >= bytes_read) {
      current_byte = 0;
      bytes_read = getrandom(buffer, BUF_SIZE, 0);
      if (bytes_read <= 0) {
        perror("getrandom failed");
        exit(1);
      }
    }

    if (is_four) {
      byte = buffer[current_byte] >> 4;
      if (byte < limit) {
        writebuffer[current_write_byte++] = pool[byte % pool_size];
        current_password_char++;

        if (current_password_char == length) {
          writebuffer[current_write_byte++] = '\n';
          current_password_char = 0;
          current_password++;
        }

        if (current_write_byte > sizeof(writebuffer) - 2) {
          write(1, writebuffer, current_write_byte);
          current_write_byte = 0;
        }
      }

      byte = buffer[current_byte++] & 0x0F;
      if (byte < limit) {
        writebuffer[current_write_byte++] = pool[byte % pool_size];
        current_password_char++;

        if (current_password_char == length) {
          writebuffer[current_write_byte++] = '\n';
          current_password_char = 0;
          current_password++;
        }

        if (current_write_byte > sizeof(writebuffer) - 2) {
          write(1, writebuffer, current_write_byte);
          current_write_byte = 0;
        }
      }
    } else {
      byte = buffer[current_byte++];

      if (byte >= limit)
        continue;

      writebuffer[current_write_byte++] = pool[byte % pool_size];
      current_password_char++;

      if (current_password_char == length) {
        writebuffer[current_write_byte++] = '\n';
        current_password_char = 0;
        current_password++;
      }

      if (current_write_byte > sizeof(writebuffer) - 2) {
        write(1, writebuffer, current_write_byte);
        current_write_byte = 0;
      }
    }

    if (current_password == count) {
      break;
    }
  }

  if (current_write_byte > 0)
    write(1, writebuffer, current_write_byte);

  exit(0);
}

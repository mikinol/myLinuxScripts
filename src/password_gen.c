#ifdef __ANDROID__
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#else
#include "../nolibc/nolibc.h"
#endif

#include <sys/syscall.h>

#define MAX_READBUF_SIZE 16384
#define WRITEBUFFER_SIZE 16384

const char *dicts[2] = {
    "0123456789ABCDEF", // HEX с большими  буквами
    "0123456789abcdef", // HEX с маленькими буквами
};

enum dictionaries { HEX_UPPER = 0, HEX_LOWER = 1, UNKNOWN = -1 };

static enum dictionaries parse_dict(const char *arg) {
  if (strcmp(arg, "hexupper") == 0)
    return HEX_UPPER;
  if (strcmp(arg, "hexlower") == 0)
    return HEX_LOWER;
  return UNKNOWN;
}

static void help() {
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

static void parse_length_and_count(uint64_t *length, uint64_t *count, char **argv) {
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

static void parse_predefined_dictionary_from_argv(enum dictionaries *dict, int *pool_size, char *pool, char **argv) {
  *dict = parse_dict(argv[3] + 1);

  if (*dict == UNKNOWN) {
    fprintf(stderr, "Неизвестный словарь: %s\n", argv[3] + 1);
    exit(1);
  }

  *pool_size = strlen(dicts[*dict]);
  memcpy(pool, dicts[*dict], *pool_size);
}

static void parse_dictionary_from_argv(int *pool_size, char *pool, char **argv) {
  char *src = argv[3];
  *pool_size = strlen(src);

  if (*pool_size > 256) {
    fprintf(stderr, "Ошибка парсинга аргументов: словарь, имеет больше чем "
                    "256 символов\n");
    exit(1);
  }

  memcpy(pool, src, *pool_size);
}

static void parse_contains_dictionary_from_argv(int *pool_size, char *pool, const int argc, char **argv) {
  static const char letters[52] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static const char numbers[10] = "0123456789";
  static const char symbols[25] = "!@#$%^&*()_+[]{}|;:',.<>?";

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

static int64_t recalc_bufsize(double success_percent, double needbytes) {
  double result = needbytes / success_percent;

  if (result > MAX_READBUF_SIZE) {
    return MAX_READBUF_SIZE;
  }

  if (success_percent != 1.0 && result < 16) {
    return 16;
  }

  int64_t truncated = result;
  return truncated + (truncated < result);
}

static char readbuffer[MAX_READBUF_SIZE];
static char writebuffer[WRITEBUFFER_SIZE];
int main(int argc, char **argv) {
  if (argc < 3) {
    help();
  }

  uint64_t length, count;
  parse_length_and_count(&length, &count, argv);

  size_t password_size = length * count;

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

  const bool is_four = pool_size <= 16;
  int maxsize = (is_four ? 16 : 256);
  int limit = maxsize - (maxsize % pool_size);
  double success_percent = (double)limit / maxsize;

  int64_t buf_size;

  int bytes_read = 0;
  int current_byte = 0;

  int current_write_byte = 0;

  int current_password = 0;
  int current_password_char = 0;

  unsigned char byte;
  unsigned char current_read_byte;
  while (true) {
    if (current_byte >= bytes_read) {
      current_byte = 0;

      buf_size =
          recalc_bufsize(success_percent, (password_size - (current_password * length) - current_password_char) / (is_four ? 2.0 : 1.0));
      bytes_read = syscall(SYS_getrandom, readbuffer, buf_size, 0);
      if (bytes_read <= 0) {
        perror("getrandom failed");
        exit(1);
      }
    }

    current_read_byte = readbuffer[current_byte];
    if (is_four) {
      byte = current_read_byte >> 4;
      if (byte < limit) {
        writebuffer[current_write_byte++] = pool[byte % pool_size];
        current_password_char++;

        if (current_password_char == length) {
          writebuffer[current_write_byte++] = '\n';
          current_password_char = 0;
          current_password++;
        }

        if (current_write_byte > WRITEBUFFER_SIZE - 3) {
          write(1, writebuffer, current_write_byte);
          current_write_byte = 0;
        }

        if (current_password == count) {
          break;
        }
      }

      byte = current_read_byte & 0x0F;
      if (byte < limit) {
        writebuffer[current_write_byte++] = pool[byte % pool_size];
        current_password_char++;

        if (current_password_char == length) {
          writebuffer[current_write_byte++] = '\n';
          current_password_char = 0;
          current_password++;
        }

        if (current_write_byte > WRITEBUFFER_SIZE - 3) {
          write(1, writebuffer, current_write_byte);
          current_write_byte = 0;
        }
      }
    } else {
      byte = current_read_byte;

      if (byte >= limit)
        continue;

      writebuffer[current_write_byte++] = pool[byte % pool_size];
      current_password_char++;

      if (current_password_char == length) {
        writebuffer[current_write_byte++] = '\n';
        current_password_char = 0;
        current_password++;
      }

      if (current_write_byte > WRITEBUFFER_SIZE - 3) {
        write(1, writebuffer, current_write_byte);
        current_write_byte = 0;
      }
    }

    if (current_password == count) {
      break;
    }

    current_byte++;
  }

  if (current_write_byte > 0)
    write(1, writebuffer, current_write_byte);

  exit(0);
}

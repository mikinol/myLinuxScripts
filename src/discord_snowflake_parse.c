#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Эпоха Discord: 1 января 2015 года (в миллисекундах)
#define DISCORD_EPOCH 1420070400000ULL

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Использование: %s <snowflake_id>\n", argv[0]);
    return 1;
  }

  // Превращаем строку в 64-битное число (unsigned long long)
  uint64_t snowflake = strtoull(argv[1], NULL, 10);

  if (snowflake == 0) {
    printf("Ошибка: неверный ID.\n");
    return 1;
  }

  uint64_t timestamp = (snowflake >> 22) + DISCORD_EPOCH;

  uint8_t worker_id = (snowflake >> 17) & 0x1F;

  uint8_t process_id = (snowflake >> 12) & 0x1F;

  uint16_t increment = snowflake & 0xFFF;

  time_t seconds = timestamp / 1000;
  int milliseconds = timestamp % 1000;
  struct tm *info = gmtime(&seconds);

  printf("Дата (UTC): %04d-%02d-%02d %02d:%02d:%02d.%03d\n",
         info->tm_year + 1900, info->tm_mon + 1, info->tm_mday, info->tm_hour,
         info->tm_min, info->tm_sec, milliseconds);
  printf("Process ID: %u\n", process_id);
  printf("Worker ID:  %u\n", worker_id);
  printf("Increment:  %u\n", increment);

  return 0;
}

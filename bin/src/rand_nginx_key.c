#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
  int length = 8;
  if (argc > 1) {
    length = atoi(argv[1]);
    if (length < 1)
      length = 1;
  }

  int fd = open("/dev/urandom", O_RDONLY);
  if (fd < 0) {
    perror("open /dev/urandom");
    return 1;
  }

  unsigned char buf[length - 1];
  if (read(fd, buf, length - 1) != length - 1) {
    perror("read /dev/urandom");
    close(fd);
    return 1;
  }
  close(fd);

  // Первый символ 0
  putchar('0');

  // Остальные случайные цифры
  for (int i = 0; i < length - 1; i++) {
    putchar('0' + (buf[i] % 10));
  }
  putchar('\n');

  return 0;
}

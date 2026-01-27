#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

void memdump(char *fmt, char *data);
int hexval(char c);

int main(int argc, char *argv[])
{
  if (argc == 1)
  {
    printf("Example 1:\n");
    int a[2] = {61810, 2025};
    memdump("ii", (char *)a);

    printf("Example 2:\n");
    memdump("S", "a string");

    printf("Example 3:\n");
    char *s = "another";
    memdump("s", (char *)&s);

    struct sss
    {
      char *ptr;
      int num1;
      short num2;
      char byte;
      char bytes[8];
    } example;

    example.ptr = "hello";
    example.num1 = 1819438967;
    example.num2 = 100;
    example.byte = 'z';
    strcpy(example.bytes, "xyzzy");

    printf("Example 4:\n");
    memdump("pihcS", (char *)&example);

    printf("Example 5:\n");
    memdump("sccccc", (char *)&example);
  }
  else if (argc == 2)
  {
    // format in argv[1], up to 512 bytes of data from standard input.
    char data[512];
    int n = 0;
    memset(data, '\0', sizeof(data));
    while (n < sizeof(data))
    {
      int nn = read(0, data + n, sizeof(data) - n);
      if (nn <= 0)
        break;
      n += nn;
    }
    memdump(argv[1], data);
  }
  else
  {
    printf("Usage: memdump [format]\n");
    exit(1);
  }
  exit(0);
}

void memdump(char *fmt, char *data)
{
  for (int i = 0; fmt[i] != '\0'; i++)
  {
    switch (fmt[i])
    {
    case 'i':                         // print next 4 bytes of data as 32-bit int, in decimal
      printf("%d\n", *((int *)data)); // since data is char*, we need to cast it to int* to dereference as int
      data += sizeof(int);            // adds 4 bytes into data buffer, since data is a char*, when we do data + sizeof(int), it moves forward by 4 in the array
      break;
    case 'p':                                       // print next 8 bytes of data as 64-bit integer, in hex
      for (int j = sizeof(void *) - 1; j >= 0; j--) // loop backwards to print in big-endian format
      {
        printf("%x", *((unsigned char *)data + j)); // + j ensures that it loops through 8 bytes of data (hex)
      }
      printf("\n");
      data += sizeof(void *); // void* is 8 bytes, and p requires us to move data pointer by 8 bytes
      break;
    case 'h': // print next 2 bytes of data as 16-bit int, in decimal
      printf("%d\n", *((short *)data));
      data += sizeof(short);
      break;
    case 'c': // print next 1 byte of data as char
      printf("%c\n", *((char *)data));
      data += sizeof(char);
      break;
    case 's': // print next 8 bytes of data as string
      printf("%s\n", *((char **)data));
      data += sizeof(char *);
      break;
    case 'S': // print the rest of the data as a string until null terminator
      printf("%s\n", data);
      while (*data != '\0') // this is essentially the same as when we did data +=sizeof(***), since the "data" variable needs to be moved
      {
        data++;
      }
      data++; // move past the null terminator
      break;
    case 'q':
      for (int j = 0; j < 16; j += 2)
      {
        int hi = hexval(data[j]);
        int lo = hexval(data[j + 1]);

        if (hi < 0 || lo < 0)
        {
          continue;
        }

        int v = (hi * 16) + lo;

        if (v >= 32 && v <= 126)
        {
          printf("%c", v);
        }
      }
      printf("\n");
      data += 16;
      break;
    default:
      printf("memdump: unknown format character '%c'\n", fmt[i]);
      return;
    }
  }
}

int hexval(char c)
{
  if (c >= '0' && c <= '9')
    return c - '0';
  if (c >= 'a' && c <= 'f')
    return c - 'a' + 10;
  if (c >= 'A' && c <= 'F')
    return c - 'A' + 10;
  return -1; // invalid character
}
#include "kernel/types.h"
#include "user/user.h"

long htoi(char *s) // method to convert hex string to integer, very important to remember
{
    long val = 0;

    if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X'))
    {
        s += 2;
    }

    for (int i = 0; s[i] != '\0'; i++)
    {
        char c = s[i];
        int digit;

        if (c >= '0' && c <= '9') // if character is a digit
        {
            digit = c - '0'; 
        }
        else if (c >= 'a' && c <= 'f') // if character is a-f
        {
            digit = c - 'a' + 10;
        }
        else if (c >= 'A' && c <= 'F') // if character is A-F
        {
            digit = c - 'A' + 10;
        }
        else
        {
            return -1; // Invalid character
        }

        val = val * 16 + digit;
    }
    return val;
}

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Usage: swap32_sys <32-bit hex>\n");
        exit(1);
    }

    long input = htoi(argv[1]);

    if (input == -1)
    {
        printf("Input:  %s\n", argv[1]);
        printf("Invalid argument\n");
        exit(1);
    }

    uint x = (uint)input;

    uint swapped = endianswap(x); // Call the system call

    printf("Input:  0x%x\n", x);
    printf("Output: 0x%x\n", swapped);

    exit(0);
}
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    uint val;
    if (argc != 2)
    {
        printf("Usage: swap32_sys <32-bit hex>\n");
        exit(1);

        printf("Input:  %s", argv[1]);
        int outcome = endianswap(argv[1]);
        printf("Output: %d", outcome);
    }
}
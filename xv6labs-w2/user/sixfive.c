#include "kernel/types.h" // types definition
#include "kernel/stat.h"  // file status structure
#include "user/user.h"    // system calls, utility functions
#include "kernel/fcntl.h" // file control options, O_RDONLY
#include "kernel/param.h" // system parameters, MAXARG (32)
#include "kernel/fs.h"    // file system structures

// int isalpha(char c)
// {
//     return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z'); // if c is between A-Z or a-z, it's an alphabetic character, return true
// }

// int ishexchar(char c)
// {
//     return (c >= '0' && c <= '9') || (c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f'); // if c is between 0-9, A-F, or a-f, it's a hex character, return true
// }

int isdigit(char c)
{
    return c >= '0' && c <= '9'; // if c is between '0' and '9', it's a digit, return true
}

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("Usage: sixfive <txt file>\n");
        exit(1);
    }

    char *delims = "-\r\t\n./,";
    char c; // current character being read
    int sum;
    char buffer[100];
    int i;
    int flag;

    for (int k = 1; k < argc; k++) // loop through all provided files
    {
        int fd = open(argv[k], O_RDONLY); // open given file in read-only mode
        if (fd < 0)                       // if fd is negative, file open failed
        {
            printf("Error: Could not open file %s\n", argv[k]);
            continue;
        }

        // reset variables for each file
        i = 0;
        sum = 0;
        flag = 1; // indicates if we are ready to read a new number

        while (read(fd, &c, 1) != 0) // read one character at a time until end of file
        {
            if (isdigit(c) && flag) // if current char is digit and we are ready to read a new number
            {
                buffer[i] = c;
                i++;
                flag = 0; // set flag to 0 to indicate we are in the middle of reading a number
            }
            else // if current char is not a digit
            {
                if (i > 0) // if we have read some digits into buffer, that means the number has ended and the current char is a new line or delimiter
                {
                    buffer[i] = '\0';
                    sum += atoi(buffer);
                    i = 0;
                }
                if ((sum % 6 == 0 || sum % 5 == 0) && sum != 0) // if sum is multiple of 5 or 6 and not zero
                {
                    printf("%d\n", sum);
                }
                sum = 0;  // reset sum for next number
                flag = 0; // set flag to 0, this makes sure we don't read a new number until we see a digit or delimiter
            }
            if ((strchr(delims, c)) || isdigit(c)) // if current char is a delimiter or digit
            {
                flag = 1;
            }
        }

        if (i > 0) // if there are remaining digits in buffer after EOF
        {
            buffer[i] = '\0';
            sum += atoi(buffer);
            if ((sum % 6 == 0 || sum % 5 == 0) && sum != 0)
            {
                printf("%d\n", sum);
            }
        }

        close(fd);
    }
    exit(0);
}
#include "kernel/types.h" // types definition
#include "kernel/stat.h"  // file status structure
#include "user/user.h"    // system calls, utility functions
#include "kernel/fcntl.h" // file control options, O_RDONLY
#include "kernel/param.h" // system parameters, MAXARG (32)
#include "kernel/fs.h"    // file system structures

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
    char buffer[100];
    int i;
    int flag;
    int sixorfiveflag;
    int final;
    int notfivesixflag;

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
        flag = 1; // indicates if we are ready to read a new number
        sixorfiveflag = 0;
        final = 0;
        notfivesixflag = 0;

        while (read(fd, &c, 1) != 0) // read one character at a time until end of file
        {
            if (isdigit(c) && flag && (c == '5' || c == '6') && notfivesixflag == 0) // if current char is digit and we are ready to read a new number and it is 5 or 6
            {
                buffer[i] = c;
                i++;
                flag = 0; // set flag to 0 to indicate we are in the middle of reading a number
                sixorfiveflag = 1;
            }
            else // if current char is not a digit and not 5 or 6
            {
                if (i > 0) // if we have read some digits into buffer, that means the number has ended and the current char is a new line or delimiter
                {
                    buffer[i] = '\0';
                    final = atoi(buffer);
                }
                if (sixorfiveflag == 1 && i < 4) // if sum is multiple of 5 or 6 and not zero
                {
                    printf("%d\n", final);
                }
                flag = 0; // set flag to 0, this makes sure we don't read a new number until we see a digit or delimiter
                sixorfiveflag = 0;
                i = 0;
            }
            if ((strchr(delims, c)) || isdigit(c)) // if current char is a delimiter or digit
            {
                flag = 1;
            }
            if (isdigit(c) && (c == '5' || c == '6'))
            {
            }
            else
            {
                notfivesixflag = 1;
            }
            if (notfivesixflag == 1 && c == '\n')
            {
                notfivesixflag = 0;
            }
        }

        if (i > 0) // if there are remaining digits in buffer after EOF
        {
            buffer[i] = '\0';
            final = atoi(buffer);
            if (sixorfiveflag)
            {
                printf("%d\n", final);
            }
        }

        close(fd);
    }
    exit(0);
}
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

// Helper: Returns 1 if s contains ONLY '5' or '6'. Returns 0 otherwise.
int is_valid_sixfive(char *s)
{
    if (strlen(s) == 0) return 0; // Empty string is not a valid number, it shouldnt even get here because i > 0 checks if there is at least one char

    for (int i = 0; s[i] != 0; i++)
    {
        if (s[i] != '5' && s[i] != '6')
        {
            return 0; // Found a bad digit (like '7' or 'a')
        }
    }
    return 1; // All checks passed
}

// Helper: Checks if a character is a separator
int is_delim(char c)
{
    // You can add more delimiters here if needed
    return (c == ' ' || c == '\n' || c == '\t' || c == '\r' || c == ',' || c == '.');
}

void process(int fd)
{
    char buf[128];
    int i = 0;
    char c;
    
    // Loop through the file one char at a time
    while (read(fd, &c, 1) == 1)
    {
        if (is_delim(c))
        {
            // DELIMITER FOUND: Process the accumulated word
            if (i > 0) 
            {
                buf[i] = 0; // Null-terminate string
                
                if (is_valid_sixfive(buf))
                {
                    printf("%s\n", buf);
                }
                
                i = 0; // Reset buffer for the next word
            }
        }
        else
        {
            // NOT A DELIMITER: Add to buffer
            if (i < 127) // Protect against Buffer Overflow
            {
                buf[i++] = c;
            }
            // If word is too long, we just stop adding (truncate), 
            // or you could ignore the rest of the word.
        }
    }

    // CHECK LAST WORD: Logic to handle file ending without a newline
    if (i > 0)
    {
        buf[i] = 0;
        if (is_valid_sixfive(buf))
        {
            printf("%s\n", buf);
        }
    }
}

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("Usage: sixfive <filename>\n");
        exit(1);
    }

    for (int k = 1; k < argc; k++)
    {
        int fd = open(argv[k], O_RDONLY);
        if (fd < 0)
        {
            printf("sixfive: cannot open %s\n", argv[k]);
            continue;
        }
        process(fd);
        close(fd);
    }
    exit(0);
}
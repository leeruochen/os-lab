#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    if (argc < 2) // user didnt enter time
    {
        fprintf(2, "Usage: sleep <ticks>\n");
        exit(1);
    }

    int arg = atoi(argv[1]); // converts argument into integer

    fprintf(1, "Sleeping for %d ticks...\n", arg);

    pause(arg);

    exit(0);
}

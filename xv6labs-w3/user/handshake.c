#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("Usage: handshake <message>\n");
        exit(1);
    }

    // get the byte from the argument to send from parent to child
    char byte = argv[1][0];

    int p2c[2]; // pipe from parent to child
    int c2p[2]; // pipe from child to parent

    pipe(p2c);
    pipe(c2p);

    int pid = fork(); // duplicates the process into a "child" process, child will hold be given 0 from fork while the "parent" will be given the pid of the child

    if (pid == 0) // child
    {
        // close unused pipes for best practice
        close(p2c[1]);
        close(c2p[0]);

        read(p2c[0], &byte, 1); // read the byte from pipe that was passed in from parent, step 2
        printf("%d: received %c from parent\n", getpid(), byte);
        write(c2p[1], &byte, 1); // pass the byte read from the pipe back to the parent via a different pipe as it is, step 3

        close(p2c[0]);
        close(c2p[1]);

        exit(0);
    }
    else // parent
    {
        // close unused pipes for best practice
        close(p2c[0]);
        close(c2p[1]);

        write(p2c[1], &byte, 1); // pass the original argument into the pipe, step 1
        wait(0);                 // waits for child process to execute exit(0)
        read(c2p[0], &byte, 1);  // read the byte from argv
        printf("%d: received %c from child\n", getpid(), byte);

        close(p2c[1]);
        close(c2p[0]);

        exit(0);
    }
}
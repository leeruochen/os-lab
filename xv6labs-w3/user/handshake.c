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

    // we declare two empty integer arrays
    int p2c[2]; // pipe from parent to child
    int c2p[2]; // pipe from child to parent

    // this initializes the arrays to become pipes.
    pipe(p2c);
    pipe(c2p);

    int pid = fork(); // duplicates the process into a "child" process, child will hold be given 0 from fork while the "parent" will be given the pid of the child
    // when we fork(), the child is created to be an exact clone of the parent, both child and parent are marked as RUNNABLE as tossed into the OS scheduler
    // there is no guarantee who runs first, in the scenario that parent runs first, it writes into the p2c pipe then waits
    // the child then reads the p2c pipe and writes back into the c2p pipe, then parent reads from c2p pipe and exits.
    // however, if child runs first, it tries to read from the p2c pipe but its empty, since its empty, the OS forces the child to sleep until parent writes into the p2c pipe.
    // os then switches to parent and the same process happens.

    if (pid == 0) // this part will only be executed by the child process since it is given 0 from fork, while the parent process will skip this part and execute the else block instead
    {
        // close unused pipes for best practice
        // first index of pipe, 0, is for reading and second index of pipe, 1, is for writing, so we close the writing end of the parent to child pipe and the reading end of the child to parent pipe
        close(p2c[1]);
        close(c2p[0]);

        // this process reads the byte from the parent to child pipe
        // then writes the byte back to the parent through the child to parent pipe without modifying it, so the parent can read the same byte back from the child

        // how read and write works
        // for read, we take the pipe and store the data into the 2nd argument, the 2nd arg must be an address
        // the third argument is the size to push through the pipe, 1 is for char, 4 for int.
        // to be safe we can use sizeof

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
        // wait(int *status) expects a pointer, uses this pointer to write down the exit status of the child process
        // when we pass in 0, essentiall its null, so we are telling the os to wait for child process to complete but we dont care about the exit status.
        // if we want this child status, we create an int variable named stauts, then pass &status into wait.
        wait(0);                 // waits for child process to execute exit(0)
        read(c2p[0], &byte, 1);  // read the byte from argv
        printf("%d: received %c from child\n", getpid(), byte);

        close(p2c[1]);
        close(c2p[0]);

        exit(0);
    }
}
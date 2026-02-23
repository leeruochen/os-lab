#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    int five = 5;
    int res;

    int p2c[2];
    int c2p[2];

    pipe(p2c);
    pipe(c2p);

    int pid = fork();

    if (pid == 0)
    {
        close(p2c[1]);
        close(c2p[0]);

        read(p2c[0], &res, sizeof(int));
        res = res * 10;
        write(c2p[1], &res, sizeof(int));

        close(p2c[0]);
        close(c2p[1]);
        exit(0);
    }
    else
    {
        close(p2c[0]);
        close(c2p[1]);

        write(p2c[1], &five , sizeof(int));
        close(p2c[1]);

        wait(0);
        read(c2p[0], &res, sizeof(int));
        close(c2p[0]);

        printf("result = %d\n", res);
        exit(0);
    }
}
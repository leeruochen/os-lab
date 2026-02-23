#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    int initial = 100;
    int res;

    int p2a[2];
    int a2b[2];
    int b2p[2];

    pipe(p2a);
    pipe(a2b);
    pipe(b2p);

    int pid_a = fork();

    if (pid_a == 0){
        close(b2p[0]);
        close(b2p[1]);
        close(p2a[1]);
        close(a2b[0]);

        read(p2a[0], &res, sizeof(int));
        res = res + 25;
        write(a2b[1], &res, sizeof(int));

        close(a2b[1]);
        close(p2a[0]);
        
        exit(0);
    }

    int pid_b = fork();

    if (pid_b == 0){
        close(p2a[0]);
        close(p2a[1]);
        close(a2b[1]);
        close(b2p[0]);

        read(a2b[0], &res, sizeof(int));
        res = res * 2;
        write(b2p[1], &res, sizeof(int));

        close(a2b[0]);
        close(b2p[1]);
        
        exit(0);
    }
    close(b2p[1]);
    close(p2a[0]);
    close(a2b[1]);
    close(a2b[0]);

    write(p2a[1], &initial, sizeof(int));
    close(p2a[1]);
    wait(0);
    wait(0);
    read(b2p[0], &res, sizeof(int));

    printf("result = %d\n", res);
    close(b2p[0]);
    exit(0);
}
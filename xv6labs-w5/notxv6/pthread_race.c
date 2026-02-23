#include <stdio.h>
#include <pthread.h>

int x = 0;   // global variable

// this shows a race condition where two threads are incrementing the same global variable without any synchronization, which can lead to unpredictable results due to interleaving of instructions.
// if the os interrupts when a thread is in the middle of incrementing x, the other thread can also read the same value of x and increment it, resulting in lost updates and incorrect final value of x.

void* fun(void* in)
{
    int i;
    for ( i = 0; i < 10000000; i++ )
        x++;
}

int main()
{
    pthread_t t1, t2;
    printf("Start >> X is: %d\n", x);

    pthread_create(&t1, NULL, fun, NULL);
    pthread_create(&t2, NULL, fun, NULL);
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    printf("End >> X is: %d\n", x);
    return 0;
}
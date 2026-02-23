#include <stdio.h>
#include <pthread.h>

// this shows how we can use an integer into a thread that accepts a void pointer, and how it type casts.
// threads only accept void pointers as an argument.

void *thread_func(void *arg)                    //correct syntax
//void *thread_func(int *arg)                   //incorrect syntax - will result in compile error
{
    printf("I am thread #%d\n", *(int *)arg);   //correct syntax
    //printf("I am thread #%d\n", *arg);        //incorrect syntax - will result in compile error
    return NULL;
}

int main(int argc, char *argv[])
{
    pthread_t t1, t2;
    int i = 1;
    int j = 2;

    /* Create 2 threads t1 and t2 with default attributes which will execute
    function "thread_func()" in their own contexts with specified arguments. */
    pthread_create(&t1, NULL, &thread_func, &i);
    pthread_create(&t2, NULL, &thread_func, &j);

    // This makes the main thread wait on the termination of t1 and t2.
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    printf("In main thread\n");
    return 0;
}

// // pthread_create()'s first argument is a pointer to a pthread_t variable where the thread ID will be stored.
// // the second argument is a pointer to a pthread_attr_t structure that specifies the thread's attributes. usually just pass NULL to get default.
// // the third argument is a pointer to the **function** that the thread will execute. this function must have the signature void *function(void *arg).
// // the fourth argument is a pointer to the **arguments** that will be passed to the thread function. this can be NULL if the thread function does not require any arguments.
// int retcode = pthread_create(&thread, NULL, threadfunction, NULL);

// // pthread_join() is used to wait for a thread to terminate. 
// //it takes two arguments: the thread ID of the thread to wait for, and a pointer to a void* variable where the return value of the thread function will be stored. 
// //if the thread function does not return a value, you can pass NULL as the second argument.
// pthread_join_demo show cases how we can get the return value of a thread function.
// int retval = pthread_join(thread, NULL); /*wait until the created thread terminates*/

// pthread_exit() is used to terminate the calling thread. the argument it takes is returned to the thread that called pthread_join().
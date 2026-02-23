#include <pthread.h>
#include <stdio.h>
#include <string.h>

/* function to be run as a thread always must have the same signature:
   it has one void* parameter and returns void */
void *threadfunction(void *arg)
{
    printf("Inside Thread\n"); 
    printf("Hello, World!\n");      /*printf() is specified as thread-safe as of C11*/
    return NULL;
}

int main(void)
{
    /*create a new thread with default attributes and NULL passed as the argument to the start routine*/    
    pthread_t thread;
    // pthread_create()'s first argument is a pointer to a pthread_t variable where the thread ID will be stored.
    // the second argument is a pointer to a pthread_attr_t structure that specifies the thread's attributes. usually just pass NULL to get default.
    // the third argument is a pointer to the function that the thread will execute. this function must have the signature void *function(void *arg).
    // the fourth argument is a pointer to the argument that will be passed to the thread function. this can be NULL if the thread function does not require any arguments.
    int retcode = pthread_create(&thread, NULL, threadfunction, NULL);

    if (!retcode) /*check whether the thread creation was successful*/
    {
        // pthread_join() is used to wait for a thread to terminate. 
        //it takes two arguments: the thread ID of the thread to wait for, and a pointer to a void* variable where the return value of the thread function will be stored. 
        //if the thread function does not return a value, you can pass NULL as the second argument.
        int retval = pthread_join(thread, NULL); /*wait until the created thread terminates*/
        printf("return value = %d\n", retval);
        return 0;
    }
    fprintf(stderr, "%s\n", strerror(retcode));
    return 1;
}
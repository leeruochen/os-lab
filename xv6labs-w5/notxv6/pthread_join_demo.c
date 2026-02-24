#include <stdio.h>
#include <stdlib.h> // calloc
#include <pthread.h>
#include <unistd.h> // pause and sleep

void *thread_func_callback(void *arg) // callback
{
    // reads the argument passed which is *sleep_p, then frees the memory allocated for it.
    int input = *(int *)arg;
    free(arg);

    // calloc is used as this provides a memory block in RAM.
    // if a normal local variable is used, since it is stored in the thread's stack, when the thread exits, it will be destroyed.
    int *result = calloc(1, sizeof(int));
    *result = input * input;
    printf("inside thread: thread result = %d\n", *result);

    printf("inside thread: sleep arg = #%d\n", input);
    sleep(*result);

    // to get back the value of the thread function, remember to use malloc or calloc to allocate memory for the result
    // then when returing, type cast the pointer to void* and return it.
    // we can also use pthread_exit((void *) result) to return the result, it is the exact same as using return.
    return (void *)result; // return void pointer
}

void thread_create(pthread_t *thread_p, int input)
{

    pthread_attr_t attr;

    int *sleep_p = calloc(1, sizeof(int));
    *sleep_p = input;
    printf("To pass sleep arg to thread = %d\n", *sleep_p);

    // this section shows how we can set the thread attributes to be custom
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE); // defaulte
    // thiscan be used to set custom stack size.
    // size_t customStackSize = 1024*1024; // 1MB
    // pthread_attr_setstacksize(&attr, customStackSize);              // set custom stack size
    // pthread_attr_setschedpolicy(&attr, SCHED_RR); // set custom scheduling policy such as SCHED_RR, SCHED_FIFO, SCHED_OTHER (default)

    int rc = pthread_create(thread_p, &attr, &thread_func_callback, sleep_p);
    if (rc != 0)
    {
        printf("Error occurred, thread could not be created, errno = %d\n", rc);
        exit(0);
    }
}

int main(int argc, char *argv[])
{
    pthread_t t1, t2, t3;

    thread_create(&t1, 2); // sleep 2sec
    thread_create(&t2, 3); // sleep 3sec
    thread_create(&t3, 1); // sleep 1sec

    void *res1_p = NULL, *res2_p = NULL, *res3_p = NULL; // pointer to return result

    printf("wait on thread#3 to join first...\n");
    // pthread_join() is used to wait for a thread to terminate., the second argument is used to retrieve the return value of the thread function
    // this is where the magic of synchronization happens, since the code calls to wait for t3 first, the whole program freezes until t3 returns the value
    pthread_join(t3, &res3_p); // blocking call
    printf("result3 = %d\n", *(int *)res3_p);
    free(res3_p);

    printf("wait on thread#1 to join next...\n");
    pthread_join(t1, &res1_p); // blocking call
    printf("result1 = %d\n", *(int *)res1_p);
    free(res1_p);

    printf("wait on thread#2 to join last...\n");
    pthread_join(t2, &res2_p); // blocking call
    printf("result2 = %d\n", *(int *)res2_p);
    free(res2_p);

    printf("return to main thread\n");
    return 0;
}

// void *thread_func_callback(void *arg)
// {
//     int input = *(int *)arg;
//     free(arg);

//     // 1. Allocate space for a string up to 49 characters long (+1 for '\0')
//     char *result_str = calloc(50, sizeof(char));

//     // 2. Write formatted text directly into our heap memory
//     // (Notice we don't use *result_str here, because result_str IS the array address)
//     sprintf(result_str, "Thread finished with input %d", input);

//     printf("inside thread: string ready = %s\n", result_str);

//     // 3. Cast to void* and return the heap pointer
//     return (void *)result_str;
// }

// in main
// void *res_void;
// pthread_join(t1, &res_void);

// // Unbox it back into a character pointer.
// // No need for a '*' at the front, because %s expects a memory address!
// printf("Thread returned: %s\n", (char *)res_void);

// free(res_void);

// int main(int argc, char *argv[])
// {
//     pthread_t threads[3];

//     // 1. Create an array of 3 string pointers!
//     // Right now, these are just 3 empty slots waiting for memory addresses.
//     char *thread_results[3];

//     // (Assume we created 3 threads here using a loop...)
//     // ...

//     void *res_void;

//     // 2. The Collection Loop
//     for (int i = 0; i < 3; i++) {
//         // Wait for the thread to finish and give us its generic pointer
//         pthread_join(threads[i], &res_void);

//         // Cast the generic pointer to a string pointer, and save it in our array!
//         thread_results[i] = (char *)res_void;
//     }

//     // ==========================================
//     // All threads are dead. We now have an array full of strings!
//     // ==========================================

//     printf("\n--- Final Results in Main ---\n");
//     for (int i = 0; i < 3; i++) {
//         // We can now print or use the strings anytime we want
//         printf("Slot %d: %s\n", i, thread_results[i]);
//     }

//     // 3. The Cleanup Loop (Crucial!)
//     for (int i = 0; i < 3; i++) {
//         // Because the threads used calloc, main is now responsible for freeing them.
//         free(thread_results[i]);
//     }

//     return 0;
// }
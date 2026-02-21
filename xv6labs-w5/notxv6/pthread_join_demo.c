#include <stdio.h>
#include <stdlib.h>     // calloc
#include <pthread.h>
#include <unistd.h>     // pause and sleep

void *thread_func_callback(void *arg)           //callback 
{
    int input = *(int *)arg;
    free(arg);
    
    int *result= calloc(1, sizeof(int));
    *result = input * input;
    printf("inside thread: thread result = %d\n", *result);    

    printf("inside thread: sleep arg = #%d\n", input);    
    sleep(*result);

    return (void *)result;  // return void pointer
}

void thread_create(pthread_t *thread_p, int input){

    pthread_attr_t attr;

    int *sleep_p = calloc(1, sizeof(int));
    *sleep_p = input;
    printf("To pass sleep arg to thread = %d\n", *sleep_p);

    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);    // default

    int rc = pthread_create(thread_p, &attr, &thread_func_callback, (void *)sleep_p);
	if(rc != 0) {
		printf("Error occurred, thread could not be created, errno = %d\n", rc);
		exit(0);
	}
}

int main(int argc, char *argv[])
{
    pthread_t t1, t2, t3;

    thread_create(&t1, 2);   // sleep 2sec       
    thread_create(&t2, 3);   // sleep 3sec
    thread_create(&t3, 1);   // sleep 1sec        

    void *res1_p=NULL, *res2_p=NULL, *res3_p=NULL;  // pointer to return result

    printf("wait on thread#3 to join first...\n");
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
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct { // this is how we pass an array, a pointer to the start
    int *array;
    int start;
    int end;
} args;

void *thread_func(void *args_void){
    // always type cast the args received first
    args *func_args = (args *)args_void;

    int *array = func_args->array;
    int start = func_args->start;
    int end = func_args->end;

    int *sum = calloc(1, sizeof(int));

    for(int i = start; i <= end; i++){
        *sum += array[i];
    }

    return (void *)sum;
}

int main(){

    int numbers[20];

    for (int i = 0; i < 20; i++){
        numbers[i] = i + 1;
    }
    
    args in1 = { .array = numbers, .start = 0, .end = 4} ;
    args in2 = { .array = numbers, .start = 5, .end = 9} ;
    args in3 = { .array = numbers, .start = 10, .end = 14} ;
    args in4 = { .array = numbers, .start = 15, .end = 19} ;

    pthread_t t1, t2, t3, t4;
    void *result = NULL;
    int total = 0;
    pthread_create(&t1, NULL, &thread_func, &in1);
    pthread_create(&t2, NULL, &thread_func, &in2);
    pthread_create(&t3, NULL, &thread_func, &in3);
    pthread_create(&t4, NULL, &thread_func, &in4);

    pthread_join(t1, &result);
    total += *(int *)result;
    free(result);

    pthread_join(t2, &result);
    total += *(int *)result;
    free(result);

    pthread_join(t3, &result);
    total += *(int *)result;
    free(result);

    pthread_join(t4, &result);
    total += *(int *)result;
    free(result);

    printf("results = %d\n", total);
    return 0;
}
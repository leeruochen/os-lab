#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct { // this is how we pass an array, a pointer to the start
    int *array;
    int start;
    int end;
} args;

pthread_mutex_t mutex;
int total = 0;

void *thread_func(void *args_void){
    // always type cast the args received first
    args *func_args = (args *)args_void;

    int *array = func_args->array;
    int start = func_args->start;
    int end = func_args->end;

    int local_total = 0;
    for(int i = start; i <= end; i++){
        local_total += array[i];
    }

    pthread_mutex_lock(&mutex);
    total += local_total;
    pthread_mutex_unlock(&mutex);

    return 0;
}

int main(){
    pthread_mutex_init(&mutex, NULL);

    int numbers[20];

    for (int i = 0; i < 20; i++){
        numbers[i] = i + 1;
    }
    
    args in1 = { .array = numbers, .start = 0, .end = 4} ;
    args in2 = { .array = numbers, .start = 5, .end = 9} ;
    args in3 = { .array = numbers, .start = 10, .end = 14} ;
    args in4 = { .array = numbers, .start = 15, .end = 19} ;

    pthread_t t1,t2,t3,t4;
    pthread_create(&t1, NULL, &thread_func, &in1);
    pthread_create(&t2, NULL, &thread_func, &in2);
    pthread_create(&t3, NULL, &thread_func, &in3);
    pthread_create(&t4, NULL, &thread_func, &in4);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    pthread_join(t3, NULL);
    pthread_join(t4, NULL);

    printf("results = %d\n", total);
    pthread_mutex_destroy(&mutex);
    return 0;
}



// #define NUM_THREADS 4
// #define ARRAY_SIZE 20
// int main(){
//     pthread_mutex_init(&mutex, NULL);

//     int numbers[ARRAY_SIZE];
//     for (int i = 0; i < ARRAY_SIZE; i++){
//         numbers[i] = i + 1;
//     }
    
//     // 1. Create arrays to hold our threads and their specific arguments
//     pthread_t threads[NUM_THREADS];
//     args thread_args[NUM_THREADS];
    
//     // 2. Calculate how many elements each thread should process
//     int chunk_size = ARRAY_SIZE / NUM_THREADS;

//     // 3. Setup and Create all threads in a single loop
//     for (int i = 0; i < NUM_THREADS; i++) {
//         thread_args[i].array = numbers;
//         thread_args[i].start = i * chunk_size;
        
//         // The last thread handles any leftover elements just in case 
//         // the array size doesn't divide perfectly by the thread count
//         if (i == NUM_THREADS - 1) {
//             thread_args[i].end = ARRAY_SIZE - 1;
//         } else {
//             thread_args[i].end = (i * chunk_size) + chunk_size - 1;
//         }

//         pthread_create(&threads[i], NULL, thread_func, &thread_args[i]);
//     }

//     // 4. Join all threads in a single loop
//     for (int i = 0; i < NUM_THREADS; i++) {
//         pthread_join(threads[i], NULL);
//     }

//     printf("results = %d\n", total);
//     pthread_mutex_destroy(&mutex);
//     return 0;
// }
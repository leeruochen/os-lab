#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>     // sleep

// Resource structure:
// Each resource has:
// - an ID
// - a mutex lock
typedef struct {
    int res_id;
    pthread_mutex_t mutex;
} res_t;

static res_t r1, r2;    // Global shared resources

// Thread 1
// Lock order: r1 → r2
static void *thread1_fn(void *arg) {
    while (1) {

        pthread_mutex_lock(&r1.mutex);  // Lock resource 1
        pthread_mutex_lock(&r2.mutex);  // Lock resource 2

        // Critical section
        printf("thread1_fn():%d\n", r1.res_id * r2.res_id);
        sleep(0.5);

        // Unlock in reverse order (good practice)
        pthread_mutex_unlock(&r2.mutex);
        pthread_mutex_unlock(&r1.mutex);
    }
    return NULL;
}

// Thread 2
// Lock order: r2 → r1
// Opposite order → possible DEADLOCK
static void *thread2_fn(void *arg) {
    while (1) {

        pthread_mutex_lock(&r2.mutex);
        pthread_mutex_lock(&r1.mutex);

        // Critical section
        printf("thread2_fn():%d\n", r1.res_id + r2.res_id);
        sleep(0.5);

        pthread_mutex_unlock(&r1.mutex);
        pthread_mutex_unlock(&r2.mutex);
    }
    return NULL;
}

int main() {
    r1.res_id = 20; // Initialize resource 1
    r2.res_id = 30; // Initialize resource 2

    pthread_mutex_init(&r1.mutex, NULL);
    pthread_mutex_init(&r2.mutex, NULL);

    pthread_t th1, th2;
    pthread_create(&th1, NULL, thread1_fn, NULL);
    pthread_create(&th2, NULL, thread2_fn, NULL);

    pthread_exit(0);    // Keep process alive

    return 0;
}

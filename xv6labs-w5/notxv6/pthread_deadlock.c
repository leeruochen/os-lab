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
// this shows us how a deadlock can occur when two threads lock resources in different orders.
// the proper way to prevent deadlocks is to lock them in the same order.
// eventually, the OS's timer will go off at the worst possible timing which is thread1 locking r1 and then it context switches to thread2.
// thread 2 then locks r2 and tries to lock r1 but it is already locked by thread1, so thread2 is blocked waiting for r1 to be unlocked.
// this causes thread 2 to be blocked waiting for thread 1 to release r1, and thread 1 is blocked waiting for thread 2 to release r2, resulting in a deadlock.
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

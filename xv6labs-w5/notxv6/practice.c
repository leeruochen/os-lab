#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

int accounts[100];
pthread_mutex_t account_locks[100];

struct transfer_args {
    int from_acc;
    int to_acc;
    int amount;
};

void transfer(int from_acc, int to_acc, int amount) {
    // this prevents deadlocks by always locking accounts in a consistent order (e.g., by account number). By locking the lower-numbered account first, we ensure that if two threads are trying to transfer between the same two accounts, they will both lock the accounts in the same order, thus avoiding a deadlock situation where one thread locks account A and waits for account B, while another thread locks account B and waits for account A.
    // deadlocks can occur if the time quantum expires after the first lock is acquired but before the second lock is acquired, allowing another thread to acquire the second lock and create a circular wait condition. By always locking in a consistent order, we eliminate the possibility of circular wait and thus prevent deadlocks.
    // this would be an extremely unlucky scenario.
    int first_lock;
    int second_lock;
    if (from_acc < to_acc){
        first_lock = from_acc;
        second_lock = to_acc;
    } else {
        first_lock = to_acc;
        second_lock = from_acc;
    }

    pthread_mutex_lock(&account_locks[first_lock]);
    pthread_mutex_lock(&account_locks[second_lock]);
    if (accounts[from_acc] >= amount) {
        accounts[from_acc] -= amount;
        accounts[to_acc] += amount;
    }
    pthread_mutex_unlock(&account_locks[second_lock]);
    pthread_mutex_unlock(&account_locks[first_lock]);
}

void *thread_worker(void *arg) {
    // Unpack the backpack
    struct transfer_args *args = (struct transfer_args *)arg;
    
    // To ACTUALLY test concurrency, we run it in a massive loop. 
    // If we only run it once, it finishes so fast the OS might not preempt it.
    for(int i = 0; i < 10000; i++) {
        transfer(args->from_acc, args->to_acc, args->amount);
    }
    
    return NULL;
}

int main(int argc, char *argv[]) {
    for (int i = 0; i < 100; i++) {
        pthread_mutex_init(&account_locks[i], NULL); // initialize mutex locks for each account
    }

    for (int i = 0; i < 100; i++) {
        accounts[i] = 1000; // initialize each account with $1000
    }

    pthread_t thread1, thread2;

    // 1. Setup the competing transfers (Alice to Bob, and Bob to Alice)
    struct transfer_args t1_args = {0, 1, 10}; // Transfer $10 from Acc 0 to 1
    struct transfer_args t2_args = {1, 0, 10}; // Transfer $10 from Acc 1 to 0

    // 2. Start the threads AT THE SAME TIME
    // The moment these functions execute, the OS starts preempting them
    pthread_create(&thread1, NULL, thread_worker, &t1_args);
    pthread_create(&thread2, NULL, thread_worker, &t2_args);

    // 3. Wait for both to finish completely
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    // 4. Print the result to verify no money was lost!
    printf("Account 0 Balance: $%d\n", accounts[0]); // Should be 1000
    printf("Account 1 Balance: $%d\n", accounts[1]); // Should be 1000

    for (int i = 0; i < 100; i++) {
        pthread_mutex_destroy(&account_locks[i]); // destroy mutex locks after use
    }

    return 0;
}
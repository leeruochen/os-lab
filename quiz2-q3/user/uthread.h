// uthread.c
/* Possible states of a thread: */
/* You can add more states if you need. */

void thread_init(void);
void thread_sleep();
int  thread_wakeup(int thread_id);
void thread_schedule(void);
void thread_create(void (*func)());
void thread_yield(void);

#define FREE        0x0
#define RUNNING     0x1
#define RUNNABLE    0x2
#define SLEEPING    0x3


#define STACK_SIZE  8192
#define MAX_THREAD  4


struct context {
  uint64 ra; // return address
  uint64 sp; // stack pointer

  // callee-saved
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};

struct thread {
  char       stack[STACK_SIZE]; /* the thread's stack */
  int        state;             /* FREE, RUNNING, RUNNABLE, ... */
  struct context context; // register context
};
extern struct thread all_thread[MAX_THREAD];
extern struct thread *current_thread;
extern void thread_switch(struct context *old, struct context *new);

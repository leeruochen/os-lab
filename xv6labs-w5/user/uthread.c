#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

/* Possible states of a thread: */
#define FREE        0x0
#define RUNNING     0x1
#define RUNNABLE    0x2

#define STACK_SIZE  8192
#define MAX_THREAD  4

struct thread_context { // use uint64 to store the register values, since they are 64-bit values in RISC-V architecture
  // uint64 means unsigned long, which is a 64-bit unsigned integer. This is used to store the values of the registers, which are 64 bits in RISC-V architecture.
  // unsigned means that the value can only be positive, which is appropriate for register values, as they represent memory addresses or data values that are typically non-negative.
  uint64 ra;
  uint64 sp;
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
  int        state;             /* FREE, RUNNING, RUNNABLE */
  struct thread_context *context;
};
struct thread all_thread[MAX_THREAD];
struct thread *current_thread;
extern void thread_switch(uint64, uint64);
              
void 
thread_init(void)
{
  // main() is thread 0, which will make the first invocation to
  // thread_schedule(). It needs a stack so that the first thread_switch() can
  // save thread 0's state.
  current_thread = &all_thread[0]; // this sets current_thread to point to the first thread in the all_thread array, which is the main thread.
  current_thread->state = RUNNING;

  current_thread->context = (struct thread_context*)(current_thread->stack + STACK_SIZE - sizeof(struct thread_context)); // this sets the context of the main thread to the top of its stack, minus the size of the thread context. This is because the thread context will be stored at the top of the stack, and we need to make space for it.
}

void 
thread_schedule(void) // MAIN CHANGES
{
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1; // this sets t to point to the next thread in the all_thread array after the current thread. 
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD) // end of thread array, loop back to the beginning
      {t = all_thread;} // all_thread is the base address of the thread array, so this sets t to the first thread in the array
                        // this actually creates a loop that loops through threads a to c, as those threads usually dont end in one iteration before they yield the cpu
                        // eventually, when all threads become FREE, the loop will find that there are no RUNNABLE threads and will print the error message and exit.
    if(t->state == RUNNABLE) {
      next_thread = t;
      break;
    }
    t = t + 1; // this moves t to the next thread in the array, so that it can check if the next thread is RUNNABLE in the next iteration of the loop. this is the loop mover
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
    exit(-1);
  }

  if (current_thread != next_thread) {         /* switch threads?  */
    next_thread->state = RUNNING;
    t = current_thread;
    current_thread = next_thread;
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    // when thread_switch is called, the first arg is stored in a0, the second in a1.
    // in uthread_switch.S, sd ra, 0(a0) stores the return address of the first argument (which is current thread) in RAM, and does so for all registers.
    // then, ld ra, 0(a1) loads the previously stored ra of the second argument (which is next thread) from RAM, and does so for all registers.
    // how was it previously stored? it was stored in previous iterations of thread_schedule. when ld ra, 0(a1) is called, if a1 is thread_b, it will load ra of previous stored thread_b's ra.
    // how about the first time thread_schedule is called? back in thread_create, specifically t->context->ra and t->context->sp, this stores the registers into the RAM.
    // so when it is first called, it loads the sp and ra stored by thread_create, and in subsequent calls, it loads the sp and ra stored by previous iterations of thread_schedule.
    thread_switch((uint64)t->context, (uint64)next_thread->context);
  } else
    next_thread = 0;
}

// void thread_yield_custom(){
//   current_thread->state = RUNNABLE;

//   current_thread->context->pc = (uint64)__builtin_return_address(0);// this sets the pc to the exact program counter of the curren thread.

//   thread_schedule();
// }

void 
thread_create(void (*func)()) // MAIN CHANGES
{
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) { // since t = all_thread, when it loops through, it will essentially add the threads into the all_thread array.
    if (t->state == FREE) break;
  }
  t->state = RUNNABLE; // this is the line that adds the threads into the queue which is all_thread.
  // since main() takes up all_thread[0], the first thread created will be all_thread[1], the second will be all_thread[2], and the third will be all_thread[3]. If we try to create a fourth thread, it will find that all threads are in use and will not create a new thread.
  // YOUR CODE HERE
  // the stack pointer points to the top of the stack, the stack holds the data and variable for the thread,
  // this is continuously being updated as the thread executes. for example in thread_a, int i is created and stored in the stack.
  // the thread_context we created to store the registers are used whenever the thread is switched out and context switch happens.

  // the thread context helps the cpu perform context switch from one thread to another.
  // the sp points to the top of the stack of the thread that owns that thread context. this helps the cpu switch from one thread to another. the sp never changes, it always points to the top.
  // ra stores the memory address where the thread will resume execution when it is switch back in.
  // s0 to s11 are registers used to store long-term variables etc.

  // take the pointer to the starting address of the thread's stack, add STACK_SIZE to it to get the top of the stack, and store it in sp. This is because stacks grow downwards, so the top of the stack is at the highest address.
  uint64 sp = (uint64)t->stack + STACK_SIZE; // this sets sp to the top of the stack
  sp -= sizeof(struct thread_context); // make space for the thread context

  // this makes the struct thread_context use the reserved space created by the previous line, and sets t->context to point to that space
  // this is stored in the computer's RAM.
  t->context = (struct thread_context*)sp;

  // the name of the function, func, is a pointer to the memory address where the function's machine code starts. So we can set the return address (ra) to func, so that when the thread is switched to, it will start executing func.
  t->context->ra = (uint64)func;

  // this sets the sp to the start line, when threads are created, they will start executing func, and func will use the stack for its local variables and function calls. it stores the local variables downwards to not overwrite the thread context, which is stored at the top of the stack. So we set sp to the top of the stack, and the thread context will be above it, and func will use the rest of the stack for its execution.
  t->context->sp = sp;
}

void 
thread_yield(void)
{
  current_thread->state = RUNNABLE;
  thread_schedule();
}

volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
  int i;
  printf("thread_a started\n");
  a_started = 1;
  while(b_started == 0 || c_started == 0)
    thread_yield();
  
  for (i = 0; i < 100; i++) {
    printf("thread_a %d\n", i);
    a_n += 1;
    thread_yield();
  }
  printf("thread_a: exit after %d\n", a_n);

  current_thread->state = FREE;
  thread_schedule();
}

void 
thread_b(void)
{
  int i;
  printf("thread_b started\n");
  b_started = 1;
  while(a_started == 0 || c_started == 0)
    thread_yield();
  
  for (i = 0; i < 100; i++) {
    printf("thread_b %d\n", i);
    b_n += 1;
    thread_yield();
  }
  printf("thread_b: exit after %d\n", b_n);

  current_thread->state = FREE;
  thread_schedule();
}

void 
thread_c(void)
{
  int i;
  printf("thread_c started\n");
  c_started = 1;
  while(a_started == 0 || b_started == 0)
    thread_yield();
  
  for (i = 0; i < 100; i++) {
    printf("thread_c %d\n", i);
    c_n += 1;
    thread_yield();
  }
  printf("thread_c: exit after %d\n", c_n);

  current_thread->state = FREE;
  thread_schedule();
}

int 
main(int argc, char *argv[]) 
{
  a_started = b_started = c_started = 0;
  a_n = b_n = c_n = 0;
  thread_init();
  thread_create(thread_a);
  thread_create(thread_b);
  thread_create(thread_c);
  current_thread->state = FREE; // sets state to free indicating that the main thread has finished its work and can be scheduled out
  thread_schedule(); // this will switch to one of the runnable threads (thread_a, thread_b, or thread_c) and start executing it. The main thread will not execute any further code after this point, as it has been marked as FREE and will not be scheduled again.
  exit(0);
}

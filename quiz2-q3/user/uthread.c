#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/proc.h"
#include "user/user.h"
#include "user/uthread.h"

struct thread all_thread[MAX_THREAD];
struct thread *current_thread;

void thread_init(void)
{
  // main() is thread 0, which will make the first invocation to
  // thread_schedule(). It needs a stack so that the first thread_switch() can
  // save thread 0's state.
  current_thread = &all_thread[0];
  current_thread->state = RUNNING;
}

void thread_sleep()
{
  // add your code here
}

int thread_wakeup(int thread_id)
{
  // add your code here
  struct thread *t;
  t = thread_id;
  if (t->state == SLEEPING && (thread_id < MAX_THREAD))
  {
  }

  return 0;
}

void thread_schedule(void)
{
  struct thread *t, *next_thread;
  int sleeping_thread = 0;
  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  for (int i = 0; i < MAX_THREAD; i++)
  {
    if (t >= all_thread + MAX_THREAD)
      t = all_thread;
    if (t->state == RUNNABLE)
    {
      next_thread = t;
      break;
    }
    // add code to identify that there are sleeping threads
    if (t->state == SLEEPING)
    {
      sleeping_thread = 1;
    }
    t = t + 1;
  }

  if (next_thread == 0)
  {
    // No runnable thread. If there is a sleeping thread, wake it up. Otherwise, panic.
    if (sleeping_thread == 1)
    {
      printf("only thread sleepings, wake them all\n");
      // we use first_sleep to make sure only the first sleeping thread is set to RUNNING, and the rest are set to RUNNABLE, so that they can be scheduled in the future.
      int first_sleep = 0;
      for (int i = 0; i < MAX_THREAD; i++)
      {
        // add the code to wake up sleeping threads here. use the first conditional branching to see if the thread i is sleeping. Use the second conditional branching to set the first sleeping thread the next to be executed.
        // any other thread will be woken up (not sleeping anymore)
        if (1)
        {
          if (first_sleep == 0)
          {
            // put your code here
            if (t->state == SLEEPING)
            {
              first_sleep = 1;
              t->state = RUNNING;
            }
          }
          if (t->state == SLEEPING)
          {
            t->state = RUNNABLE;
          }
          // anything else to add?
          t = t + 1;
        }
      }
    }
    else
    {
      printf("thread_schedule: no runnable threads\n");
      exit(-1);
    }
  }

  if (current_thread != next_thread)
  { /* switch threads?  */
    next_thread->state = RUNNING;
    t = current_thread;
    current_thread = next_thread;
    thread_switch(&t->context, &current_thread->context);
  }
  else
    next_thread = 0;
}

void thread_create(void (*func)())
{
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++)
  {
    if (t->state == FREE)
      break;
  }
  t->state = RUNNABLE;
  t->context.sp = (uint64)&t->stack[STACK_SIZE - 1];
  t->context.ra = (uint64)(*func);
}

void thread_yield(void)
{
  current_thread->state = RUNNABLE;
  thread_schedule();
}

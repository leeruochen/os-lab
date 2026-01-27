#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  kexit(n);
  return 0; // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return kfork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return kwait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
  argint(1, &t);
  addr = myproc()->sz;

  if (t == SBRK_EAGER || n < 0)
  {
    if (growproc(n) < 0)
    {
      return -1;
    }
  }
  else
  {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
      return -1;
    myproc()->sz += n;
  }
  return addr;
}

uint64
sys_pause(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if (n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kkill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_endianswap(void)
{
  int n;
  uint result;

  argint(0, &n); // since only one argument is passed in, it will be in register a0. if more arguments are passed, they will be in a1, a2, etc.
                 // first parameter of argint represents the registers, so 0 will be a0

  uint x = (uint)n;

  // when we do 0xFF, we get the last 8 bits of x
  // we use | to combine the bits together, it is an OR operation, so if 0x78000000 | 0x00670000 = 0x78670000, it does this for all 4 bytes
  result = ((x & 0xFF) << 24) | // we first do x & 0xFF to get the last 8 bits, then we shift it left by 24 bits to put it in the first 8 bits position
           ((x >> 8) & 0xFF) << 16 | // we first shift x right by 8 bits to get rid of the last 8 bits, then we do & 0xFF to get the next 8 bits, then we shift it left by 16 bits to put it in the second 8 bits position
           ((x >> 16) & 0xFF) << 8 | // we first shift x right by 16 bits to get rid of the last 16 bits, then we do & 0xFF to get the next 8 bits, then we shift it left by 8 bits to put it in the third 8 bits position
           ((x >> 24) & 0xFF); // we first shift x right by 24 bits to get rid of the last 24 bits, then we do & 0xFF to get the first 8 bits, which is now in the last 8 bits position

  return result;
}
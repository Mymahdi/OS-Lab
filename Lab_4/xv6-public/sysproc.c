#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
// #include "cpu.h"  // Include cpu.h to access 'struct cpu'

// Declare totalSysCalls as an external variable (defined in trap.c)
extern uint totalSysCalls;

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// Return how many clock tick interrupts have occurred since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// New system call to return the total number of system calls executed across all CPUs
int
sys_getsyscalls(void)
{
  uint total = 0;
  int i;

  // Iterate over all CPUs and sum up the SysCallCounter
  for (i = 0; i < ncpu; i++) {
    struct cpu *cpu = &cpus[i];  // Accessing the current CPU
    total += cpu->SysCallCounter;  // Adding up the SysCallCounter from each CPU
  }

  // Compare with the global totalSysCalls variable
  if (total != totalSysCalls) {
    cprintf("Error: Total system calls mismatch!\n");
  } else {
    cprintf("Total system calls across all CPUs: %d\n", total);
  }

  return total;  // Return the total system calls
}

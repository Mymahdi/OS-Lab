#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "vm.c"
#include <stdint.h>


uint64_t sys_open_sharedmem(void) {
    int id;
    if (argint(0, &id) < 0)
        return -1;

    acquire(&sharedmem_table[id].lock);
    if (sharedmem_table[id].ref_count == 0) {
        sharedmem_table[id].frame = kalloc(); // Allocate physical memory
        if (!sharedmem_table[id].frame) {
            release(&sharedmem_table[id].lock);
            return -1;
        }
        sharedmem_table[id].id = id;
    }
    sharedmem_table[id].ref_count++;
    release(&sharedmem_table[id].lock);

    return (uint64_t)sharedmem_table[id].frame;
}

uint64_t sys_close_sharedmem(void) {
    int id;
    if (argint(0, &id) < 0)
        return -1;

    acquire(&sharedmem_table[id].lock);
    if (sharedmem_table[id].ref_count > 0)
        sharedmem_table[id].ref_count--;
    release(&sharedmem_table[id].lock);

    return 0;
}


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

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

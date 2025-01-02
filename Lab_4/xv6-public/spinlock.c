// Mutual exclusion spin locks.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#define NULL ((void *)0)

// Spinlock functions remain unchanged

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
  lk->locked = 0;
  lk->cpu = 0;
}

void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if (holding(lk))
    panic("acquire");

  while (xchg(&lk->locked, 1) != 0)
    ;

  __sync_synchronize();
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}

void
release(struct spinlock *lk)
{
  if (!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
  lk->cpu = 0;

  __sync_synchronize();

  asm volatile("movl $0, %0" : "+m"(lk->locked) :);
  popcli();
}

int
holding(struct spinlock *lock)
{
  int r;
  pushcli();
  r = lock->locked && lock->cpu == mycpu();
  popcli();
  return r;
}

// Reentrant lock implementation

void
initreentrantlock(struct reentrantlock *lk, char *name)
{
  initlock(&lk->lock, name); // Initialize underlying spinlock
  lk->owner = 0;            // No owner initially
  lk->recursion = 0;        // Recursion depth is 0
}

void
acquirereentrantlock(struct reentrantlock *lk)
{
  struct proc *current = myproc();

  // If current process already owns the lock, increment recursion depth
  if (lk->owner == current)
  {
    lk->recursion++;
    return;
  }

  // Acquire the underlying spinlock
  acquire(&lk->lock);

  // Set the owner to the current process and initialize recursion depth
  lk->owner = current;
  lk->recursion = 1;
}

void
releasereentrantlock(struct reentrantlock *lk)
{
  // Ensure current process owns the lock
  if (lk->owner != myproc())
    panic("releasereentrantlock: not the owner");

  // Decrease recursion depth
  lk->recursion--;

  // If recursion depth is 0, release the underlying spinlock
  if (lk->recursion == 0)
  {
    lk->owner = 0; // Clear the owner
    release(&lk->lock);
  }
}


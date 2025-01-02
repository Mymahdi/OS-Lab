#ifndef REENTRANTLOCK_H
#define REENTRANTLOCK_H

#include "types.h"
#include "spinlock.h"
#include "proc.h"

// Function prototypes
void initreentrantlock(struct reentrantlock *lock, const char *name);
void acquirereentrantlock(struct reentrantlock *lock);
void releasereentrantlock(struct reentrantlock *lock);

#endif // REENTRANTLOCK_H

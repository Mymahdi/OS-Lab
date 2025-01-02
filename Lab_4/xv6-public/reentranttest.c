#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "reentrantlock.h"

struct reentrantlock lock;

// A recursive function that acquires and releases the reentrant lock
void recursive_function(int depth) {
  if (depth == 0)
    return;

  acquirereentrantlock(&lock);
  printf(1, "Lock acquired at depth %d\n", depth);

  // Recursive call
  recursive_function(depth - 1);

  printf(1, "Releasing lock at depth %d\n", depth);
  releasereentrantlock(&lock);
}

int main(void) {
  // Initialize the reentrant lock
  initreentrantlock(&lock, "testlock");

  printf(1, "Starting recursive function\n");
  recursive_function(3);
  printf(1, "Finished recursive function\n");

  exit();
}

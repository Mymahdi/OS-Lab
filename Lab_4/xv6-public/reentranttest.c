#include "types.h"
#include "stat.h"
#include "user.h"

struct reentrantlock lock;

void recursive_function(int depth) {
  if (depth <= 0)
    return;

  printf(1, "Process %d acquiring lock at depth %d\n", getpid(), depth);
  acquirereentrantlock(&lock);

  printf(1, "Process %d acquired lock at depth %d\n", getpid(), depth);

  // Recursive call
  recursive_function(depth - 1);

  printf(1, "Process %d releasing lock at depth %d\n", getpid(), depth);
  releasereentrantlock(&lock);
}

int main() {
  printf(1, "Initializing reentrant lock...\n");
  initreentrantlock(&lock, "testlock");

  printf(1, "Starting recursive lock test...\n");
  recursive_function(5);

  printf(1, "Reentrant lock test completed.\n");
  exit();
}

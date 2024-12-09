#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  int Pid = getpid();
  
  // Test setting process info
  if(set_proc_info(Pid, 1000, 80) < 0) {
    printf(1, "Failed to set process info\n");
  }
  
  // Test changing queue
  if(change_queue(Pid, 1) < 0) {
    printf(1, "Failed to change queue\n");
  }
  
  exit();
}
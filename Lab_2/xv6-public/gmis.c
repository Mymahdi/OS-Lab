#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"


int main(int argc, char *argv[]) 
{
    int pid = getpid();
    printf(1, "Current PID: %d\n", pid);
    int most_invoked = get_most_invoked_syscall(pid);
    printf(1, "Most invoked syscall : %d\n", most_invoked);
    exit();
}
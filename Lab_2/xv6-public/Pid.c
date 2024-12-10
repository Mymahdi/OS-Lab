#include "types.h"
#include "user.h"

int main(void)
{
    int CurrentProcessId = getpid();
    printf(1, "current process ID : %d\n", CurrentProcessId);
    exit();
}
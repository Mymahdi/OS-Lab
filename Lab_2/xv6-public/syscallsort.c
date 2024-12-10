#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc,char* argv[]) 
{
    if(argc != 2)
    {
        printf(2, "Error Usage\n");
    }
    int pid = atoi(argv[1]);

    if(sort_syscalls(pid) == -1){
        printf(2, "process not found\n");
    } 
    exit();
}
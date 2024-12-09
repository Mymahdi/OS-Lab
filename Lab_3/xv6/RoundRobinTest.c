#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int main(int argc, char* argv[])
{
    int Pid = fork();

    if(Pid < 0)
    {
        printf(1, "Failed to create child process!\n");
    }
    else if(Pid == 0)
    {
        for(int i = 0; i < 100; i++)
        {
            printf(1, "Child_1 : %d \n", i);
        }
        exit();
    }
    Pid = fork();
    if (Pid < 0)
    {
        return 1;
    }
    if (Pid == 0)
    {
        for (int i = 0; i < 100; i++)
        {
            printf(1, "Child_2 : %d \n", i);
        }
        exit();
    }
    for (int i = 0; i < 500; i++)
    {
        printf(1, "Parent : %d \n", i);
    }
    wait();
    wait();
    exit();

    return 0;
}

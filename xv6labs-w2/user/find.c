#include "kernel/types.h" // types definition
#include "kernel/stat.h"  // file status structure, fstat()
#include "user/user.h"    // system calls, utility functions
#include "kernel/fs.h"    // file system structures
#include "kernel/fcntl.h" // file control options, O_RDONLY
#include "kernel/param.h" // system parameters, MAXARG (32)

char *nameWithoutDir(char *path) // this loops from the back of the string given which will be like a/b/c
                                 // it will detect the first / found from the back and then it will return c
{
    char *p;

    for (p = path + strlen(path); p >= path && *p != '/'; p--)
        ;

    p++;
    return p;
}

void find(char *path, char *target)
{
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(path, 0)) < 0)
    {
        printf("find: cannot open %s\n", path);
        return;
    }

    if (fstat(fd, &st) < 0)
    {
        printf("find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch (st.type)
    {
    case T_FILE: // if path is a file
        if (strcmp(nameWithoutDir(path), target) == 0)
        {
            printf("%s\n", path);
        }
        break;
    case T_DIR: // if path is a directory, we need to recurse
        strcpy(buf, path);
        p = buf + strlen(buf);
        *p++ = '/'; // Add the slash: "path/"

        while (read(fd, &de, sizeof(de)) == sizeof(de)) // reads the files in the directory in a loop
        {
            if (de.inum == 0) // directory is empty, skip while loop
                continue;

            // CRITICAL: Stop infinite recursion
            if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
                continue;

            // Append the new file name to the path
            memmove(p, de.name, DIRSIZ);
            p[DIRSIZ] = 0; // Null terminate manually just in case

            // RECURSIVE CALL
            find(buf, target);
        }
        break;
    default:
        break;
    }
}

int main(int argc, char *argv[])
{
    if (argc > 3)
    {
        printf("Usage: sixfive <dir name> <file name>\n");
        exit(1);
    }
    else if (argc == 3)
    {
        find(argv[1], argv[2]);
    }
    else
    {
        find(".", argv[1]);
    }
    exit(0);
}

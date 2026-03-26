#include "kernel/param.h"
#include "kernel/fcntl.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/riscv.h"
#include "kernel/fs.h"
#include "user/user.h"

void test1(void);

void remove_recursive(char *path);

int main(int argc, char *argv[]) {
    int fd;
    if((fd = open("ICT1012", 0)) >= 0) {
        close(fd);
        remove_recursive("ICT1012");
    }

    printf("Testing test1()...\n");
    test1();
    printf("test1(): OK!\n");

    printf("pwd_test: all tests succeeded\n");

    if((fd = open("ICT1012", 0)) >= 0) {
        close(fd);
        remove_recursive("ICT1012");
    }

    exit(0);
}

void
err(char *why)
{
  printf("pwd_test failure: %s, pid=%d\n", why, getpid());
  exit(1);
}


void test1(){
    int p[2];
    char buf[128];
    char *argv[] = { "/pwd", 0 };
    
    memset(buf, 0, sizeof(buf));

    int r_mkdir = mkdir("ICT1012");

    if (r_mkdir == -1)
        err("test1 mkdir 1");
  
    int r_chdir = chdir("ICT1012");

    if (r_chdir == -1)
        err("test1 chdir 1");

    r_mkdir = mkdir("Quiz-3");

    if (r_mkdir == -1)
        err("test1 mkdir 2");
    
    r_chdir = chdir("Quiz-3");

    if (r_chdir == -1)
        err("test1 chdir 2");

    
    if(pipe(p) < 0)
        err("findtest1 pipe");


    if(fork() == 0) {   // child process to execute "find"
        
        close(p[0]);       // close the read side in child process
        close(1);          // close current stdout (fd 1)
        dup(p[1]);         // redirect stdout to p[1]
        close(p[1]);       // close p[1], as it is referenced by stdout now.

        exec("/pwd", argv);  // execute "find" and its output will be in the pipe
        err("test1 exec failed\n");
        exit(1);
    }


    close(p[1]);         // parent process must close the write side; otherwise, read will stuck

    const char * const testString = "/ICT1012/Quiz-3\n";
  
    int n;
    int totalBytes = 0;
    while((totalBytes < sizeof(buf) - 1) && (n = read(p[0], &buf[totalBytes], sizeof(buf) - totalBytes -1)) > 0) {
        totalBytes += n;
        // fprintf(2, "n:%d\n", n);  
    }
    // fprintf(2, "testString: %s",testString);
    // fprintf(2, "buf: %s", buf);
    
    if(n < 0){
        err("test1 pipe read");
    }

    if(strcmp(testString, buf) != 0)
        err("test1 pwd");

    close(p[0]);
    wait(0);             // wait until child process finishes
}


void remove_recursive(char *path) {
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    fprintf(2, "rm: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "rm: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  case T_DEVICE:
  case T_FILE:
    close(fd);
    if(unlink(path) < 0){
      fprintf(2, "rm: %s failed to delete\n", path);
    }
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)){
      printf("rm: path too long\n");
      close(fd);
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      // Key point: Never recursively enter . and ..
      if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
        continue;
      
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      remove_recursive(buf); // recursively remove the sub directories.
    }
    close(fd);
    if(unlink(path) < 0){
      fprintf(2, "rm: %s directory not empty or permission denied\n", path);
    }
    break;
  }
}
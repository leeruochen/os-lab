#include "kernel/param.h"
#include "kernel/fcntl.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/riscv.h"
#include "kernel/fs.h"
#include "user/user.h"

void findtest1(void);

void remove_recursive(char *path);

int main(int argc, char *argv[]) {
  int fd;
  if((fd = open("Test", 0)) >= 0) {
    close(fd);
    remove_recursive("Test");
  }

  printf("Testing findtest1()...\n");
  findtest1();
  printf("findtest1(): OK!\n");

  printf("find_test: all tests succeeded\n");

  if((fd = open("Test", 0)) >= 0) {
    close(fd);
    remove_recursive("Test");
  }

  exit(0);
}

void
err(char *why)
{
  printf("findtest failure: %s, pid=%d\n", why, getpid());
  exit(1);
}


void generateFile(const char *f) {
  int fd = open(f, O_WRONLY | O_CREATE);
  if (fd == -1)
    err("open");
    
  if (close(fd) == -1)
    err("close");
}

void findtest1(void) {
  int p[2];
  char buf[128];
  char *argv[] = { "find", "/Test" , "file1.txt", 0 };
  // char *argv[] = { "ls", 0 };

  memset(buf, 0, sizeof(buf));

  int r_mkdir = mkdir("Test");

  if (r_mkdir == -1)
    err("findtest1 mkdir");
  
  int r_chdir = chdir("Test");
  if (r_chdir == -1)
    err("findtest1 chdir 1");

  const char * const f1 = "file1.txt";
  generateFile(f1);
  const char * const f2 = "file2.txt";
  generateFile(f2);
  const char * const f3 = "file3.txt";
  generateFile(f3);

  r_chdir = chdir("..");
  if (r_chdir == -1)
    err("findtest1 chdir 2");

  if(pipe(p) < 0)
    err("findtest1 pipe");


  if(fork() == 0) {   // child process to execute "find"
    
    close(p[0]);       // close the read side in child process
    close(1);          // close current stdout (fd 1)
    dup(p[1]);         // redirect stdout to p[1]
    close(p[1]);       // close p[1], as it is referenced by stdout now.

    exec("find", argv);  // execute "find" and its output will be in the pipe
    err("findtest1 exec failed\n");
    exit(1);
  }


  close(p[1]);         // parent process must close the write side; otherwise, read will stuck

  const char * const testString = "/Test/file1.txt\n";
  
  int n;
  int totalBytes = 0;
  while((totalBytes < sizeof(buf) - 1) && (n = read(p[0], &buf[totalBytes], sizeof(buf) - totalBytes -1)) > 0) {
    totalBytes += n;
    // fprintf(2, "n:%d\n", n);  
  }
  
  if(n < 0){
    err("findtest1 pipe read");
  }

  if(strcmp(testString, buf) != 0)
      err("findtest1 find");

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
      
      if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
        continue;
      
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      remove_recursive(buf); 
    }
    close(fd);
    if(unlink(path) < 0){
      fprintf(2, "rm: %s directory not empty or permission denied\n", path);
    }
    break;
  }
}
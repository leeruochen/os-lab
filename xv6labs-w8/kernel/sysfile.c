//
// File-system system calls.
// Mostly argument checking, since we don't trust
// user code, and calls into file.c and fs.c.
//

#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "spinlock.h"
#include "proc.h"
#include "fs.h"
#include "sleeplock.h"
#include "file.h"
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;

  argint(n, &fd);
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *p = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd] == 0){
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}

uint64
sys_dup(void)
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}

uint64
sys_read(void)
{
  struct file *f;
  int n;
  uint64 p;

  argaddr(1, &p);
  argint(2, &n);
  if(argfd(0, 0, &f) < 0)
    return -1;
  return fileread(f, p, n);
}

uint64
sys_write(void)
{
  struct file *f;
  int n;
  uint64 p;
  
  argaddr(1, &p);
  argint(2, &n);
  if(argfd(0, 0, &f) < 0)
    return -1;

  return filewrite(f, p, n);
}

uint64
sys_close(void)
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}

uint64
sys_fstat(void)
{
  struct file *f;
  uint64 st; // user pointer to struct stat

  argaddr(1, &st);
  if(argfd(0, 0, &f) < 0)
    return -1;
  return filestat(f, st);
}

// Create the path new as a link to the same inode as old.
uint64
sys_link(void)
{
  char name[DIRSIZ], new[MAXPATH], old[MAXPATH];
  struct inode *dp, *ip;

  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;

bad:
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
}

uint64
sys_unlink(void)
{
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], path[MAXPATH];
  uint off;

  if(argstr(0, path, MAXPATH) < 0)
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
    return -1;
  }

  ilock(dp);

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;

  ilock(dp);

  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      goto fail;
  }

  if(dirlink(dp, name, ip->inum) < 0)
    goto fail;

  if(type == T_DIR){
    // now that success is guaranteed:
    dp->nlink++;  // for ".."
    iupdate(dp);
  }

  iunlockput(dp);

  return ip;

 fail:
  // something went wrong. de-allocate ip.
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}

uint64
sys_mkdir(void)
{
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}

uint64
sys_mknod(void)
{
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
  argint(1, &major);
  argint(2, &minor);
  if((argstr(0, path, MAXPATH)) < 0 ||
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}

uint64
sys_chdir(void)
{
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
  
  begin_op();
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
  iput(p->cwd);
  end_op();
  p->cwd = ip;
  return 0;
}

uint64
sys_exec(void)
{
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
  if(argstr(0, path, MAXPATH) < 0) {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv)){
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
      goto bad;
    }
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
      goto bad;
  }

  int ret = exec(path, argv);

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    kfree(argv[i]);
  return -1;
}

uint64
sys_pipe(void)
{
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();

  argaddr(0, &fdarray);
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    p->ofile[fd0] = 0;
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
}

uint64
sys_open(void)
{
  char path[MAXPATH];
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
  if((n = argstr(0, path, MAXPATH)) < 0)
    return -1;

  begin_op();
  // opens the file depending on which mode is specified.

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    // set ip to the inode of the file the user wants to open
    // eg. user types open("shortcut.txt", O_RDONLY), then ip will be set to the inode of file.txt
    if((ip = namei(path)) == 0){ // sets ip to the inode by the path given then lock
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
      iunlockput(ip);
      end_op();
      return -1;
    }
  }

  if(!(omode & O_NOFOLLOW)){
    // omode stores the flag given by user. eg if O_CREATE and O_NOFOLLOW is given, it will use an | to combine flags, omode will have a value of 0x1010 0000 0000. so since create is set, in the if statement for create, it uses the and operator to check, this will return true.
    // for this if statement to work, O_NOFOLLOW must not be set. since the flag is not set, it enters a loop to check if the file is a symlink.
    // the reason why we have a NOFOLLOW flag instead of a SYMLINK flag is to make the SYMLINK the default behavior, if a user doesnt want the SYMLINK to happen, they throw in the flag and skip this.

    int count = 0;
    while(ip->type == T_SYMLINK && count < 10){ // check if the file is a symlink. if its not skip everything here
      char target[MAXPATH];

      // readi reads data from an inode given, and requires the inode to be locked by the caller
      // signature, int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
      // ip is a pointer to the inode you want to read from
      // user_dst, takes either 1 or 0, 1 for dst data from user's memory, 0 for kernel's memory, since we want to read the string into target which is in kernel's memory, use 0
      // dst is the memory address you want to read into, read data of ip into target
      // off is the offset from which to start reading
      // n is the number of bytes to read

      // reads content from an inode into the target

      // eg. shortcut.txt is a symlink with content "/docs/real.txt". this reads "/docs/real.txt" from shortcut.txt inode into target and returns the length of read string. we have to null terminate to make it a valid string
      int len = readi(ip, 0, (uint64)target, 0, sizeof(target));

      if(len <= 0){ // if len is 0 or negative, this means the file is empty
        iunlockput(ip);
        end_op();
        return -1;
      }
      iunlockput(ip); // we dont need ip anymore so just unlock it

      target[len] = 0; // null terminate the string

      // namei looks up and returns the inode for a path
      // eg. since target is stored with "/docs/real.txt", namei searches for the inode with the name real.txt and returns the inode into ip
      // if real.txt is another symlink, the while loop continues and repeats process.
      if((ip = namei(target)) == 0){ // if namei returns 0 it means the path given in the symlink content is invalid, just end op and return -1
        end_op();
        return -1;
      }
      ilock(ip); // lock new inode and increase count. then the while loop will check if the new ip is a symlink, if it is, it needs to repeat the process. if not, it will continue onwards
      count++;
    }
    if(count == 10){ // hard cap the maximum symlinks followed to 10, likely an infinite loop.
      iunlockput(ip);
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    f->off = 0;
  }
  f->ip = ip;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  if((omode & O_TRUNC) && ip->type == T_FILE){
    itrunc(ip);
  }

  iunlock(ip);
  end_op();

  return fd;
}

uint64 sys_symlink(void){
  char path[MAXPATH], target[MAXPATH];
  // an example of path would be "/shortcut.txt", target would be "/docs/real.txt"

  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0) // if user didnt enter arguments, arg 0 is the first arg and 1 is the second. this stores arguements into target and path with max length of MAXPATH.
    return -1;
  
  begin_op(); // starts file system transaction, os tells kernel it is about to make changes to the disk, so write all changes to a temporary log first
  // to commit the changes, have to call end_op();

  // path is usually stored to the directory we want to create the file at. the create function will parse the path to find the directory and create the file there. the 0,0 parameter is for major and minor which is used for device files, since we are creating a normal file, we can just set them to 0
  // this creates a new file with the path given and type SYMLINK, and returns the inode of the new file, it also locks the inode, so we dont have to lock it again before writing into it, but we have to unlock it with iunlockput after we are done
  struct inode *new = create(path, T_SYMLINK,0 ,0);
  // create a new inode for a new symlink with the path/name given
  // this creates a symlink called "shortcut.txt" in root

  if (new == 0){
    end_op();
    return -1;
  }

  // writei writes data into an inode given, and requires the inode to be locked by the caller
  // create returns a locked inode, so we just have to unlock it after the operation, to lock it manually, use ilock(struct inode *ip), to unlock iunlockput(struct inode *ip)
  // signature, int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
  // ip is a pointer to the inode you want to write into
  // user_src, takes either 1 or 0, 1 for src data from user's memory, 0 for kernel's memory, since we copied the string into target which is in kernels memory, use 0
  // src is the memory address you want to write which is target in this case
  // off, the offset, where to begin writing inside the file if there are existing data you wish to not overwrite. 0 to start from beginning
  // n, number of bytes to write into

  // write data from target into new inode new.

  // now since this is a symlink, we write the content inside the new inode with the path that it will follow which is given in target.
  if(writei(new, 0, (uint64)target, 0, strlen(target)) != strlen(target))
  // if writei returns a number less than strlen(target), it means there was an error, just unlock inode and end op then return -1
  {
    iunlockput(new);
    end_op();
    return -1;
  }

  // upon success, now if someone calls the file shortcut.txt, it will read the content which is "/docs/real.txt" and follow that path to find the real file. this is how symlink works.
  iunlockput(new);
  end_op();
  return 0;
}

// stat.h - to create the file type
// fcntl.h - create flag

// syscall.h - create syscall
// syscall.c - create syscall in syscalls with extern
// user.h - create the prototype for the syscall
// usys.pl - syscall entry
// sysfile.c - logic for the syscall (symlink)

uint64 sys_fastsymlink(void){ // fast symlink
  char path[MAXPATH], target[MAXPATH];

  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0) 
    return -1;
  
  begin_op(); 

  struct inode *new = create(path, T_SYMLINK,0 ,0);
  if (new == 0){
    end_op();
    return -1;
  }

  if(strlen(target) <= (13*(sizeof(uint)))){ // see if the target string can fit inside addrs of the inode, if can then just store in without writei, this is faster.
    char* targetStr = (char*)new->addrs;
    memmove(targetStr, target, strlen(target) + 1); // copy target into addrs, +1 to include null terminator

    new->size = strlen(target); // have to change the size as we did it manually
    iupdate(new); // have to push the changes to disk
  } else {
    if(writei(new, 0, (uint64)target, 0, strlen(target)) != strlen(target))
    {
      iunlockput(new);
      end_op();
      return -1;
    }
  }

  iunlockput(new);
  end_op();
  return 0;
}

uint64
sys_fastopen(void)
{
  char path[MAXPATH];
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
  if((n = argstr(0, path, MAXPATH)) < 0)
    return -1;

  begin_op();
  // opens the file depending on which mode is specified.

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){ // sets ip to the inode by the path given then lock
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
      iunlockput(ip);
      end_op();
      return -1;
    }
  }

  if(!(omode & O_NOFOLLOW)){
    int count = 0;
    while(ip->type == T_SYMLINK && count < 10){
      char target[MAXPATH];
      int len = 0;

      if (ip->size < (13*sizeof(uint))){ // check the size of ip, if its smaller than 52 bytes, it means the target string is stored inside addrs, we can just read from addrs without calling readi

        memmove(target, (char*)ip->addrs, ip->size); // move the addrs content into target
        len = ip->size;

      } else {

        len = readi(ip, 0, (uint64)target, 0, sizeof(target));

        if(len <= 0){ 
          iunlockput(ip);
          end_op();
          return -1;
        }
      }
      iunlockput(ip);

      target[len] = 0; 

      if((ip = namei(target)) == 0){ // set ip to the inode of target
        end_op();
        return -1;
      }

      ilock(ip); 
      count++;
    }
    if(count == 10){ 
      iunlockput(ip);
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    f->off = 0;
  }
  f->ip = ip;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  if((omode & O_TRUNC) && ip->type == T_FILE){
    itrunc(ip);
  }

  iunlock(ip);
  end_op();

  return fd;
}

uint64 sys_rename(void){ // directory 
  char old_path[MAXPATH], new_path[MAXPATH];
  char old_name[DIRSIZ], new_name[DIRSIZ];
  struct inode *old_dp, *new_dp, *old_ip;
  struct inode *target_ip = 0;
  uint old_poff, new_poff;
  struct dirent de;

  if(argstr(0, old_path, MAXPATH) < 0 || argstr(1, new_path, MAXPATH) < 0){
    return -1;
  }

  begin_op();
  if((old_dp = nameiparent(old_path, old_name)) == 0) {
    // nameiparent parses the path and returns unlocked inode of parent. it also copies the last file name into old_name
    // old_path would be something like "/docs/draft.txt", then old_dp would be the inode of "/docs" and old_name would be "draft.txt"
    end_op(); return -1; 
  }

  if((new_dp = nameiparent(new_path, new_name)) == 0) { 
    // similar, it returns the parent directory of the new path and copies the last file name into new_name
    // new_path would be something like "/docs/final.txt", then new_dp would be the inode of "/docs" and new_name would be "final.txt"
    iput(old_dp); // since nameiparent returns an unlocked inode, we have to put it back since we are not going to use it anymore, if we dont put it back, it will cause a memory leak as the inode is still in memory but we have lost the reference to it.
    end_op(); return -1; 
  }

  // 2. DEFEAT THE DEADLOCK: Lock in order of inum!
  // since we need to edit the directories, we need to lock them, in order for no deadlock, we need to lock it in order so we conveniently just lock in order of their inums.
  if(old_dp->inum < new_dp->inum){
      ilock(old_dp); //ilock locks inode
      ilock(new_dp);
  } else if(new_dp->inum < old_dp->inum){
      ilock(new_dp);
      ilock(old_dp);
  } else {
      // They are the exact same directory (e.g. renaming /a/file1 to /a/file2)
      // Only lock it once!
      ilock(old_dp); 
  }

  if ((old_ip = dirlookup(old_dp, old_name, &old_poff)) == 0){
    // look for old_name in old_dp and return the inode of that file with name old_name
    // this function never fails as with the old_dp = nameiparent call, we have already checked that the old file exists, so it should always find the file, if it doesnt find it, it means there is a bug in the code somewhere

    if (old_dp != new_dp) {
      iunlockput(old_dp);
      iunlockput(new_dp);
    } else {
      iunlock(old_dp);
    }
    return -1;
  }

  target_ip = dirlookup(new_dp, new_name, &new_poff); 
  // look for a file that has the same name as the name we want to overwrite which is new_name, if this file exists, then we have to unlink it before renaming.

  if(target_ip != 0){
    // Target exists! 
    // Remember to lock it before doing any overwriting/unlinking checks!
    ilock(target_ip);
    if(target_ip->type == T_DIR || target_ip == old_ip){
      // We cannot rename a file on top of an existing directory or the same file
      iunlockput(target_ip);
      if (old_dp != new_dp) {
          iunlockput(old_dp);
          iunlockput(new_dp);
        } else {
          iunlock(old_dp);
        }
      return -1;
    }


    // THE ONLY TIME CONTENTS OF A FILE NEEDS TO BE DELETED IS WHEN THERE IS AN EXISTING FILE WITH THE SAME NAME AS THE NEW NAME WE WANT
    // decrement nlink essentially deletes the content.
    // here we are essentially deleting the target file's data
    // because if target_ip exists, we are overwriting it. so the data in here will be deleted.
    target_ip->nlink--; // Decrement the link count of the target inode, since we are removing one link to it
    iupdate(target_ip); // Update the target inode on disk to reflect the new link count
    iunlockput(target_ip); // Unlock the target inode 

    target_ip = 0;

    // Clear the directory entry of the target file by writing a blank directory entry with inum = 0, this is similar to what unlink does, but we dont want to call unlink directly since unlink also checks if the file is a directory and if it is empty, we have already done those checks so we can just do the part where it clears the directory entry and updates the link count
    memset(&de, 0, sizeof(de)); 
    
    // this is basically deleting the directory entry of the target file eg. it would be deleting the directory "docs/final.txt"
    writei(new_dp, 0, (uint64)&de, new_poff, sizeof(de)); 
  }

  if(dirlink(new_dp, new_name, old_ip->inum) < 0){
    // dirlink creates a new directory entry in new_dp with new_name and links it to inode.
    // this essentially overwrites the old file with the new name.
    // in the directory new_dp, a file will be created called new_name with the data of old_ip
    
    // eg. with the content of "docs/draft.txt", we rename it to have the name "docs/final.txt", then in the directory "docs", a new file will be created with the name "final.txt" and the data of "draft.txt". if "final.txt" already exists, it will be overwritten and the old data will be deleted.

    // link new name to old inode number
    // if less than 0, it means there was an error, just unlock directories and return -1
    if (old_dp != new_dp) {
      iunlockput(old_dp);
      iunlockput(new_dp);
    } else {
      iunlock(old_dp);
    }
    return -1;
  }

  memset(&de, 0, sizeof(de)); // Create a completely blank directory entry (inum = 0)
  
  // eg. here we would be deleting the old directory entry which is "docs/draft.txt"
  if(writei(old_dp, 0, (uint64)&de, old_poff, sizeof(de)) != sizeof(de)){
      panic("rename: writei failed"); 
  }

  iput(old_ip);
  iupdate(old_ip); // Update the old inode on disk to reflect the new link count

  if (old_dp != new_dp) {
    iunlockput(old_dp);
    iunlockput(new_dp);
  } else {
    iunlock(old_dp);
  }

  end_op();
  return 0;
}
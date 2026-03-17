#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

#define NULL ((void *)0)
#define FALSE (0)
#define TRUE (1)

#define PATH_SEPARATOR "/"

// int main(int argc, char *argv[])
// {

//   struct stat iCurrent, iParent;
//   int fd;
//   struct dirent de;
//   char namebuf[DIRSIZ + 1];
//   int count = 1;
//   // pwd command for user to use to print present working directory
//   while (count)
//   {
//     // get the inode number of "." (current directory)
//     // we call it iCurrent
//     stat(".", &iCurrent);
//     printf("inode num of current dir: %d\n", iCurrent.ino);

//     // get the inode number of ".." (parent directory)
//     // we call it iParent
//     stat("..", &iParent);
//     printf("inode num of current dir: %d\n", iParent.ino);

//     if (iCurrent.ino == iParent.ino)
//     {
//       // We are in the root directory, and we can stop.
//       fd = open("..", 0);

//       while (read(fd, &de, sizeof(de)) == sizeof(de))
//       {
//         if (de.inum == iParent.ino)
//         {
//           memmove(namebuf, de.name, DIRSIZ);
//           namebuf[DIRSIZ] = 0;
//           break;
//         }
//       }

//       printf("%s\n", namebuf);

//       printf("Name of . is: %s\n", namebuf);
//       count--;
//     }
//     else
//     {
//       // do necessary processing
//       // ....

//       // and go one level up
//       chdir("..");
//     }
//   }
//   exit(0);
// }

static int getcwd(char *resultPath);
static char *goUp(int ino, char *ancestorPath, char *resultPath);
static int dirlookup(int fd, int ino, char *p);

int main(int argc, char *argv[])
{
  char resultPath[512];
  if (getcwd(resultPath))
    printf("%s\n", resultPath);
  else
    printf("pwd failed");
  exit(0);
}

static int getcwd(char *resultPath)
{
  resultPath[0] = '\0';

  char ancestorPath[512];
  strcpy(ancestorPath, ".");

  struct stat st;
  if (stat(ancestorPath, &st) < 0)
    return FALSE;

  char *p = goUp(st.ino, ancestorPath, resultPath);
  if (p == NULL)
    return FALSE;
  if (resultPath[0] == '\0')
    strcpy(resultPath, PATH_SEPARATOR);
  return TRUE;
}

static char *goUp(int ino, char *ancestorPath, char *resultPath)
{
  strcpy(ancestorPath + strlen(ancestorPath), PATH_SEPARATOR "..");
  struct stat st;
  if (stat(ancestorPath, &st) < 0)
    return NULL;

  if (st.ino == ino)
  {
    // No parent directory exists: must be the root.
    return resultPath;
  }

  char *foundPath = NULL;
  int fd = open(ancestorPath, O_RDONLY);
  if (fd >= 0)
  {
    char *p = goUp(st.ino, ancestorPath, resultPath);
    if (p != NULL)
    {
      strcpy(p, PATH_SEPARATOR);
      p += sizeof(PATH_SEPARATOR) - 1;

      // Find current directory.
      if (dirlookup(fd, ino, p))
        foundPath = p + strlen(p);
    }
    close(fd);
  }
  return foundPath;
}

// @param fd   file descriptor for a directory.
// @param ino  target inode number.
// @param p    [out] file name (part of absPath), overwritten by the file name of the ino.
static int dirlookup(int fd, int ino, char *p)
{
  struct dirent de;
  while (read(fd, &de, sizeof(de)) == sizeof(de))
  {
    if (de.inum == 0)
      continue;
    if (de.inum == ino)
    {
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = '\0';
      return TRUE;
    }
  }
  return FALSE;
}
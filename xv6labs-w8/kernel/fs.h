// On-disk file system format.
// Both the kernel and user programs use this header file.


#define ROOTINO  1   // root i-number
#define BSIZE 1024  // block size

// Disk layout:
// [ boot block | super block | log | inode blocks |
//                                          free bit map | data blocks]
//
// mkfs computes the super block and builds an initial file system. The
// super block describes the disk layout:
struct superblock {
  uint magic;        // Must be FSMAGIC
  uint size;         // Size of file system image (blocks)
  uint nblocks;      // Number of data blocks
  uint ninodes;      // Number of inodes.
  uint nlog;         // Number of log blocks
  uint logstart;     // Block number of first log block
  uint inodestart;   // Block number of first inode block
  uint bmapstart;    // Block number of first free map block
};

#define FSMAGIC 0x10203040

#define NDIRECT 11 // this is 12 by default, we change it to 11 to allocate a block to be a doubly indirect block. So the maximum file size is 11 + 256 + 256*256 blocks, which is about 65803 blocks. a block is 1024 bytes
#define NINDIRECT (BSIZE / sizeof(uint)) // a singly indirect block can hold 256 block numbers, so it can point to 256 blocks. each address is 4 bytes, so a block can hold 1024/4 = 256 addresses.(BSIZE / sizeof(uint)) returns 256
#define MAXFILE (NDIRECT + NINDIRECT + NINDIRECT*NINDIRECT) // 11 + 256 + 256*256 = 65803 blocks, which is about 64MB. So the maximum file size is about 64MB.

// On-disk inode structure
// type is 0 for a free inode, or one of the following types which can be found in stats.h
// T_DIR, T_FILE, T_DEVICE, T_SYMLINK (newly added for symbolic link)
// major and minor are only used for T_DEVICE, shouldnt be tested.
// nlink is the number of links to this inode.
// size is the size of the file in bytes. For a symbolic link, it is the length of the path name it links to.
// addrs[] holds the block numbers of the data blocks. The first NDIRECT blocks are listed in addrs[]. The next NINDIRECT blocks are listed in block addrs[NDIRECT]. The next NINDIRECT*NINDIRECT blocks are listed in block addrs[NDIRECT+1].
struct dinode {
  short type;           // File type
  short major;          // Major device number (T_DEVICE only)
  short minor;          // Minor device number (T_DEVICE only)
  short nlink;          // Number of links to inode in file system
  uint size;            // Size of file (bytes)
  uint addrs[NDIRECT+2];   // Data block addresses
};

// Inodes per block.
#define IPB           (BSIZE / sizeof(struct dinode))

// Block containing inode i
#define IBLOCK(i, sb)     ((i) / IPB + sb.inodestart)

// Bitmap bits per block
#define BPB           (BSIZE*8)

// Block of free map containing bit for block b
#define BBLOCK(b, sb) ((b)/BPB + sb.bmapstart)

// Directory is a file containing a sequence of dirent structures.
#define DIRSIZ 14

struct dirent {
  ushort inum;
  char name[DIRSIZ];
};


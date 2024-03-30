#include <stdio.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <assert.h>
#include <stdbool.h>

#include "types.h"
#include "fs.h"

#define BLOCK_SIZE (BSIZE)

char getbit(char *bitmapaddress, int datablock)
{
  char tmp = *(bitmapaddress + (datablock / 8));
  int index = datablock % 8;
  // int i;
  // for (i = 0; i < 8; i++)
  // {
  //   printf("%d", !!((tmp << i) & 0x80));
  // }
  // printf("\n");
  tmp = (tmp >> index) & (0x01);
  return tmp;
}

void create_dmap(struct superblock *sb, char *addrs, uint firstblock, struct dinode *inode, int *used_dbs)
{
  int i, j;
  uint blockaddr;
  uint *indirect;
  for (i = 0; i < (NDIRECT + 1); i++)
  {
    blockaddr = inode->addrs[i];
    if (blockaddr == 0)
    {
      continue;
    }

    if (blockaddr >= sb->nblocks)
    {
      continue;
    }
    used_dbs[blockaddr - firstblock] = 1;
    // check inode's indirect address
    if (i == NDIRECT)
    {
      indirect = (uint *)(addrs + blockaddr * BLOCK_SIZE);
      for (j = 0; j < NINDIRECT; j++, indirect++)
      {
        blockaddr = *(indirect);

        if (blockaddr <= 0)
        {
          continue;
        }

        used_dbs[blockaddr - firstblock] = 1;
      }
    }
  }
}

void create_imap(struct dinode *dip, char *addrs, struct dinode *currentinode, int *imap, struct superblock *sb, int parent)
{

  int i, j;
  uint blockaddr;
  uint *indirect;
  struct dinode *inode;
  struct dirent *dir;
  int direntrysize = BLOCK_SIZE / (sizeof(struct dirent));
  if (currentinode->type == 1)
  {
    for (i = 0; i < NDIRECT; i++)
    {
      blockaddr = currentinode->addrs[i];

      if (blockaddr == 0)
      {
        continue;
      }

      dir = (struct dirent *)(addrs + blockaddr * BLOCK_SIZE);
      for (j = 0; j < direntrysize; j++, dir++)
      {
        if (dir->inum != 0 && strcmp(dir->name, ".") != 0 && strcmp(dir->name, "..") != 0)
        {
          inode = ((struct dinode *)(dip)) + dir->inum;
          imap[dir->inum]++;
          create_imap(dip, addrs, inode, imap, sb, dir->inum);
        }
      }
    }

    blockaddr = currentinode->addrs[NDIRECT];
    if (blockaddr != 0)
    {
      indirect = (uint *)(addrs + blockaddr * BLOCK_SIZE);
      for (i = 0; i < NINDIRECT; i++, indirect++)
      {
        blockaddr = *(indirect);
        if (blockaddr == 0)
          continue;
        dir = (struct dirent *)(addrs + blockaddr * BLOCK_SIZE);
        for (j = 0; j < direntrysize; j++, dir++)
        {
          if (dir->inum != 0 && strcmp(dir->name, ".") != 0 && strcmp(dir->name, "..") != 0)
          {
            inode = ((struct dinode *)(dip)) + dir->inum;

            imap[dir->inum]++;

            create_imap(dip, addrs, inode, imap, sb, dir->inum);
          }
        }
      }
    }
  }
}

void check_directory(struct dinode *dip, char *addrs, int inum)
{
  struct dirent *direntry;
  int i, j;
  for (i = 0; i < NDIRECT; i++)
  {
    if (dip->addrs[i] == 0)
      continue;
    direntry = (struct dirent *)(addrs + dip->addrs[i] * BLOCK_SIZE);
    int direntrysize = BLOCK_SIZE / (sizeof(struct dirent));
    int founddot = 0;
    int founddotdot = 0;

    for (j = 0; j < direntrysize; j++, direntry++)
    {

      if (strcmp(direntry->name, ".") == 0)
      {
        if (direntry->inum != inum)
        {
          printf("ERROR: directory not properly formatted.\n");
          exit(1);
        }
        founddot = 1;
      }

      if (strcmp(direntry->name, "..") == 0)
      {

        if (inum == 1 && direntry->inum != inum)
        {
          printf("ERROR: root directory does not exist.\n");
          exit(1);
        }

        if (inum != 1 && direntry->inum == inum)
        {
          printf("ERROR: directory not properly formatted.\n");
          exit(1);
        }

        founddotdot = 1;
      }

      if (founddot && founddotdot)
        break;
    }

    if (founddot && founddotdot)
      break;

    if (!(founddot && founddotdot))
    {
      printf("ERROR: directory not properly formatted.\n");
      exit(1);
    }
  }
}

void check_inode(struct dinode *dip, struct superblock *sbtmp, char *addrs)
{
  int bitblock, i, j, z;
  struct dinode *diptmp = dip;
  uint used_datablock[sbtmp->nblocks];
  int imap[sbtmp->ninodes];
  int bmap_direct[sbtmp->nblocks];
  int bmap_indirect[sbtmp->nblocks];
  memset(bmap_direct, 0, sizeof(uint) * sbtmp->nblocks);
  memset(bmap_indirect, 0, sizeof(uint) * sbtmp->nblocks);
  memset(imap, 0, sizeof(uint) * sbtmp->ninodes);

  int firstdatablock = (sbtmp->ninodes / IPB) + (sbtmp->size / BPB) + 4;
  memset(used_datablock, 0, sizeof(uint) * sbtmp->nblocks);
  struct dinode *currentInode = dip;
  currentInode++;
  imap[0]++;
  imap[1]++;
  create_imap(dip, addrs, currentInode, imap, sbtmp, 1);
  char *bitmapblock = (char *)((char *)dip + ((sbtmp->ninodes / (IPB)) + 1) * BLOCK_SIZE);

  for (i = 0; i < sbtmp->ninodes; i++, diptmp++)
  {

    if (diptmp->type == 0)
      continue;

    if (diptmp->type != 1 && diptmp->type != 2 && diptmp->type != 3)
    {
      printf("ERROR: bad inode.\n");
      exit(1);
    }
    // root inode
    if (i == 1)
    {
      if (diptmp->type != 1)
      {
        printf("ERROR: root directory does not exist.\n");
        exit(1);
      }
    }

    if (diptmp->type == 1)
    {
      check_directory(diptmp, addrs, i);
    }
    // create_dmap(sbtmp, addrs, firstdatablock, diptmp, used_datablock);
    for (j = 0; j < NDIRECT; j++)
    {
      if (diptmp->addrs[j] > sbtmp->size)
      {
        printf("ERROR: bad direct address in inode.\n");
        exit(1);
      }
      if (diptmp->addrs[j] == 0)
        continue;
      bmap_direct[diptmp->addrs[j] - firstdatablock]++;
      if ((diptmp->addrs[j] - firstdatablock) >= 0)
      {
        used_datablock[diptmp->addrs[j] - firstdatablock] = 1;
      }
      if (diptmp->addrs[j] > 0)
      {
        if (!getbit(bitmapblock, diptmp->addrs[j]))
        {
          printf("ERROR: address used by inode but marked free in bitmap.\n");
          exit(1);
        }
      }
    }
    if (diptmp->addrs[NDIRECT] == 0)
      continue;
    // check the indirect address
    if (diptmp->addrs[NDIRECT] >= sbtmp->size || diptmp->addrs[NDIRECT] < 0)
    {
      printf("ERROR: bad indirect address in inode.\n");
      exit(1);
    }

    if ((diptmp->addrs[NDIRECT] >= firstdatablock))
    {
      used_datablock[diptmp->addrs[NDIRECT] - firstdatablock] = 1;
    }

    uint *inblockaddrs = (uint *)(addrs + diptmp->addrs[NDIRECT] * BLOCK_SIZE);
    int ninblk = (BSIZE / sizeof(uint));
    for (z = 0; z < ninblk; z++, inblockaddrs++)
    {
      if (*(inblockaddrs) >= sbtmp->size || *(inblockaddrs) < 0)
      {
        printf("ERROR: bad indirect address in inode.\n");
        exit(1);
      }
      if (*(inblockaddrs) == 0)
        continue;
      bmap_indirect[*(inblockaddrs)-firstdatablock]++;
      if ((*(inblockaddrs) >= firstdatablock))
      {
        used_datablock[*(inblockaddrs)-firstdatablock] = 1;
      }

      if (*(inblockaddrs) > 0)
      {
        if (!getbit(bitmapblock, *(inblockaddrs)))
        {
          printf("ERROR: address used by inode but marked free in bitmap.\n");
          exit(1);
        }
      }
    }
    for (j = 0; j < sbtmp->nblocks; j++)
    {

      if (bmap_direct[j] > 1)
      {
        printf("ERROR: direct address used more than once.\n");
        exit(1);
      }

      if (bmap_indirect[j] > 1)
      {
        printf("ERROR: indirect address used more than once.\n");
        exit(1);
      }
    }
  }

  diptmp = dip;
  diptmp++;
  diptmp++;
  for (i = 2; i < sbtmp->ninodes; i++, diptmp++)
  {

    if (diptmp->type == 1 && imap[i] > 1)
    {
      printf("ERROR: directory appears more than once in file system.\n");
      exit(1);
    }

    if (diptmp->type != 0 && imap[i] == 0)
    {
      printf("ERROR: inode marked use but not found in a directory.\n");
      exit(1);
    }

    if (imap[i] > 0 && diptmp->type == 0)
    {
      printf("ERROR: inode referred to in directory but marked free.\n");
      exit(1);
    }

    if (diptmp->type == 2 && imap[i] != diptmp->nlink)
    {
      printf("ERROR: bad reference count for file.\n");
      exit(1);
    }
  }

  uint block_number;
  for (i = 0; i < sbtmp->nblocks; i++)
  {
    block_number = (uint)(i + firstdatablock);
    if (used_datablock[i] == 0 && getbit(bitmapblock, block_number))
    {
      printf("ERROR: bitmap marks block in use but it is not in use.\n");
      exit(1);
    }
  }
}

int main(int argc, char *argv[])
{
  int r, i, n, fsfd;
  char *addr;
  struct dinode *dip;
  char *dip2;
  struct superblock *sb;
  struct dirent *de;
  struct stat fsStat;

  if (argc < 2)
  {
    printf("Usage: sample fs.img ...\n");
    exit(1);
  }

  fsfd = open(argv[1], O_RDONLY);
  if (fsfd < 0)
  {
    perror(argv[1]);
    exit(1);
  }

  // read file stats from fs.img
  if (fstat(fsfd, &fsStat) < 0)
  {
    exit(1);
  }

  /* Dont hard code the size of file. Use fstat to get the size */
  addr = mmap(NULL, fsStat.st_size, PROT_READ, MAP_PRIVATE, fsfd, 0);
  if (addr == MAP_FAILED)
  {
    perror("mmap failed");
    exit(1);
  }
  /* read the super block */
  sb = (struct superblock *)(addr + 1 * BLOCK_SIZE);

  /* read the inodes */
  dip = (struct dinode *)(addr + IBLOCK((uint)0) * BLOCK_SIZE);
  dip2 = (char *)(addr + 2 * BLOCK_SIZE);
  char *bitmapblock = (char *)dip + sb->ninodes * BLOCK_SIZE;

  check_inode(dip, sb, addr);
  exit(0);
}

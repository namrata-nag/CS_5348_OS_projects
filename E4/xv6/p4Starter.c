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


int
main(int argc, char *argv[])
{
  int r,i,n,fsfd;
  char *addr;
  struct stat fsStat;
  struct dinode *dip;
  struct superblock *sb;
  struct dirent *de;

  if(argc < 2){
    fprintf(stderr, "Usage: sample fs.img ...\n");
    exit(1);
  }


  fsfd = open(argv[1], O_RDONLY);
  if(fsfd < 0){
    perror(argv[1]);
    exit(1);
  }

  //read file stats from fs.img
  if(fstat(fsfd,&fsStat) < 0){
              exit(1);
  }

  /* Dont hard code the size of file. Use fstat to get the size */
  addr = mmap(NULL, fsStat.st_size, PROT_READ, MAP_PRIVATE, fsfd, 0);
  if (addr == MAP_FAILED){
	perror("mmap failed");
	exit(1);
  }

  /* read the super block */
  sb = (struct superblock *) (addr + 1 * BLOCK_SIZE);
  printf("fs size %d, no. of blocks %d, no. of inodes %d %d\n", sb->size, sb->nblocks, sb->ninodes, sb->nlog);
  
  dip = (struct dinode *) (addr + ((uint)0/IPB + sb->inodestart)*BLOCK_SIZE);
  //dip = (struct dinode *) (addr + ((2)*BLOCK_SIZE));
  printf("begin addr %p, begin inode %p , offset %d \n", addr, dip, (char *)dip -addr);

  i =0;
  struct dinode *tempdip;
  tempdip = dip;
  for(i; i< 2; i++ ){
     tempdip = tempdip + i;  
     if(tempdip->type == 0){
       continue;
     }

  }
  printf("inode num %d",i);
  /* read the inodes */
/**  dip = (struct dinode *) (addr + IBLOCK((uint)0,sb)*BLOCK_SIZE); 
  printf("begin addr %p, begin inode %p , offset %d \n", addr, dip, (char *)dip -addr);

  // read root inode
  printf("Root inode  size %d links %d type %d \n", dip[ROOTINO].size, dip[ROOTINO].nlink, dip[ROOTINO].type);

  // get the address of root dir 
  de = (struct dirent *) (addr + (dip[ROOTINO].addrs[0])*BLOCK_SIZE);

  // print the entries in the first block of root dir 

  n = dip[ROOTINO].size/sizeof(struct dirent);
  for (i = 0; i < n; i++,de++){
 	printf(" inum %d, name %s ", de->inum, de->name);
  	printf("inode  size %d links %d type %d \n", dip[de->inum].size, dip[de->inum].nlink, dip[de->inum].type);
  }**/
  exit(0);

}


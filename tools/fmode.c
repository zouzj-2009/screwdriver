#include<stdio.h>
#include<sys/types.h>
#include<sys/stat.h>
int main(int ac, char *av[])
{
struct stat info;
if(ac>1)
if(stat(av[1],&info) != -1){
show_stat_info(av[1],&info);
return 0;
}
else
perror(av[1]);
return 1;
}
void show_stat_info(char *fname, struct stat *buf)
{
printf("%04o ",buf->st_mode&0xfff&~0x800); //clear suid
//printf(" %d ",buf->st_nlink);
printf(" %d ",buf->st_uid);
printf(" %d ",buf->st_gid);
printf(" %d ",buf->st_size);
printf(" %d ",buf->st_mtime);
printf(" %s\n",fname);
}



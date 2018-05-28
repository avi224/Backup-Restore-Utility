#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/inotify.h>
#include <sys/stat.h>
#include <string.h>
struct stat st;

#define EVENT_SIZE  ( sizeof (struct inotify_event) )
#define BUF_LEN     ( 1024 * ( EVENT_SIZE + 16 ) )
 
int watch(char* path){
	long unsigned int updated_size;
	char name[1000];
	int length, i = 0;
  int fd;
  int wd;
  char buffer[BUF_LEN];
	
 fd = inotify_init();
 
  if ( fd < 0 ) {
	perror( "inotify_init" );
  }

  wd = inotify_add_watch( fd, path, 
						 IN_MODIFY | IN_CREATE | IN_DELETE );
   
  length = read( fd, buffer, BUF_LEN );  
 
  if ( length < 0 ) {
	perror( "read" );
  }  

  while ( i < length ) {
  	strcpy(name, path);
	struct inotify_event *event = ( struct inotify_event * ) &buffer[ i ];
  	strcat(name, event->name);
  	if(event->name[0] == '.')
  		return -1;

	if ( event->len ) {
	  if ( event->mask & IN_CREATE ) {
		if ( event->mask & IN_ISDIR ) {
		  //printf( "The directory %s was created.\n", event->name );       
		}
		else {

			stat(name, &st);
			updated_size += st.st_size;
		  //printf( "The file %s was created.\n", event->name );
		}
	  }
	  else if ( event->mask & IN_DELETE ) {
		if ( event->mask & IN_ISDIR ) {
		  //printf( "The directory %s was deleted.\n", event->name );       
		}
		else {
		  //printf( "The file %s was deleted.\n", event->name );
		}
	  }
	  else if ( event->mask & IN_MODIFY ) {
		if ( event->mask & IN_ISDIR ) {
		  ///printf( "The directory %s was modified.\n", event->name );
		}
		else {

			stat(name, &st);
			updated_size += st.st_size;
		 printf( "The file %s was modified.\n", event->name );
		}
	  }
	}
	i += EVENT_SIZE + event->len;
  }
  ( void ) inotify_rm_watch( fd, wd );
  ( void ) close( fd );
 
  return updated_size;
}

int main( int argc, char **argv ) 
{

	long unsigned int updated_size = 0;
	while(1){
		int size = watch(argv[1]);
		if(size > 0){
			updated_size += size;
		}

		if(updated_size > 100){
			updated_size = 0;
			printf("%s\n", "start backup");
		}
	}
  
}
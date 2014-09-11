This file has been written by Felix Albrecht and was modified by Martin Ruckert.

We start by adding a preprocessor definition to disable warnings
about deprecated functions, like strcpy or sprintf, and 
include mmixlib.h at the start of the sybroutines 
to declare the extern library interface.

@x
@<Preprocessor definitions@>=
@y
@<Sub...@>=
#ifdef MMIXLIB
#include "mmixlib.h"
#include "libname.h"
#endif

@ @<Global...@>=
static jmp_buf error_exit;

@ @<Preprocessor definitions@>=
#include <setjmp.h>
#ifdef MMIX_PRINT
extern int mmix_printf(char *format,...);
#define printf(...) mmix_printf(__VA_ARGS__)
#endif
#pragma warning(disable : 4996)
#define _MMIXAL_
@z

We change error messages that handle errors in the command line 
(there is none). Errors are no longer written to stderr.

@x
    fprintf(stderr,
       "(say `-b <number>' to increase the length of my input buffer)\n");
@y
    err("*use the Options dialog to increase the length of my input buffer");
@z

Besides filenames, we need to keep track
of external file numbers.

@x
Char *filename[257];
@y
Char *filename[257];
static int file_no[257];
@z

Whenever we enter a new filename, we look up
the external file number for it.

@x
        filename_count++;
@y
        file_no[filename_count]=filename2file(filename[filename_count],filename_count);
        filename_count++;
@z


Next we change the way errors are reported:

@x
  if (message[0]=='*')
    fprintf(stderr,"\"%s\", line %d warning: %s\n",
                 filename[cur_file],line_no,message+1);
  else if (message[0]=='!')
    fprintf(stderr,"\"%s\", line %d fatal error: %s\n",
                 filename[cur_file],line_no,message+1);
  else {
    fprintf(stderr,"\"%s\", line %d: %s!\n",
                 filename[cur_file],line_no,message);
    err_count++;
  }
@y
  if (message[0]=='*'){
    mmixal_error(message+1,file_no[cur_file],line_no,1);
    err_count+=0x1;
    }
  else if (message[0]=='!') {
    mmixal_error(message+1,file_no[cur_file],line_no,-1);
    err_count=-2;
  }
  else {
    mmixal_error(message,file_no[cur_file],line_no,0);
    err_count+=0x10000;
  }
@z                 


The error exit is redirected using a longjmp.

@x
  if (message[0]=='!') exit(-2);
@y
  if (message[0]=='!') 
    longjmp(error_exit,-2);
@z

@x
int err_count; /* this many errors were found */
@y
int err_count; /* negativ for fatal erros else (erros<<16)+warnings */
@z

In the assemble subroutine, we have the
opportunity to gain some information about
the association of lines and locations.

@x
  for (j=0;j<k;j++) {
@y
 add_line_loc(file_no[cur_file], line_no, cur_loc);
 for (j=0;j<k;j++) {
@z

We allocate tree nodes node by node so that we can free them again.

@x
  register trie_node *t=next_trie_node;
  if (t==last_trie_node) {
    t=(trie_node*)calloc(1000,sizeof(trie_node));
    if (!t) panic("Capacity exceeded: Out of trie memory");
@.Capacity exceeded...@>
    last_trie_node=t+1000;
  }
  next_trie_node=t+1;
  return t;
@y
  trie_node *t=(trie_node*)calloc(1,sizeof(trie_node));
  if (!t) panic("Capacity exceeded: Out of trie memory");
  return t;
@z

We need extra information in the symbol table.

@x
typedef struct sym_tab_struct {
@y
typedef struct sym_tab_struct {
  int file_no;
  int line_no;
@z

We allocat single sym nodes to be able to free them.

@x
    p=next_sym_node;
    if (p==last_sym_node) {
      p=(sym_node*)calloc(1000,sizeof(sym_node));
      if (!p) panic("Capacity exceeded: Out of symbol memory");
@.Capacity exceeded...@>
      last_sym_node=p+1000;
    }
    next_sym_node=p+1;
@y
    p=(sym_node*)calloc(1,sizeof(sym_node));
    if (!p) panic("Capacity exceeded: Out of symbol memory");
@z   

The special names are already defined in mmix-sim.w

@x
Char *special_name[32]={"rB","rD","rE","rH","rJ","rM","rR","rBB",
 "rC","rN","rO","rS","rI","rT","rTT","rK","rQ","rU","rV","rG","rL",
 "rA","rF","rP","rW","rX","rY","rZ","rWW","rXX","rYY","rZZ"};
@y
extern Char *special_name[32];

@z

Errors generated at the end of the assembly should use the
normal error reporting macros.

@x
  fprintf(stderr,"undefined symbol: %s\n",sym_buf+1);
@.undefined symbol@>
  err_count++;
@y
  sprintf(err_buf,"undefined symbol: %s",sym_buf+1);
  report_error(err_buf);
@.undefined symbol@>
  err_count+=0x10000;
@z

when a sym_node becomes DEFINED, we record file and line.

@x
  @<Find the symbol table node, |pp|@>;
@y
  @<Find the symbol table node, |pp|@>;
  pp->file_no=file_no[cur_file];
  pp->line_no=line_no;  
@z




Some global variables need to be static to
avoid name conflicts in the library.

@x
tetra z,y,x,yz,xyz; /* pieces for assembly */
@y
static tetra z,y,x,yz,xyz; /* pieces for assembly */
@z

The main() program becomes mmixal().

@x
int main(argc,argv)
  int argc;@+
  char *argv[];
@y
int mmixal(char *mms_name, char *mmo_name, char *mml_name, int x_option, int b_option)
@z

There is no commandline to process,
instead we handle the function parameters and 
install the return point for 
a global error exit. Further, we have to initialize global variables.
@x
  @<Process the command line@>;
@y
  err_count=setjmp(error_exit);
  if (err_count!=0){
   prune(trie_root);
   goto clean_up;
  }
  if (mms_name==NULL)
    panic("No input file name");
  src_file_name= mms_name;
  if (mmo_name==NULL)
    obj_file_name[0]=0;
  else
    strncpy(obj_file_name,mmo_name,FILENAME_MAX);
  if (mml_name==NULL)
    listing_name[0]=0;
  else
    strncpy(listing_name,mml_name,FILENAME_MAX);
  expanding = x_option;
  buf_size = b_option;
    cur_file=0;
  line_no=0;
  long_warning_given=0;
  cur_loc.h=cur_loc.l=0;
  listing_loc.h=listing_loc.l=0;
  spec_mode= 0;
  spec_mode_loc= 0;
  mmo_ptr=0;
  err_count=0;
  serial_number=0;
  filename_count=0;
  for (j=0;j<10;j++)
  { forward_local[j].link=0;
    backward_local[j].link=0;
  }
  greg= 255;
  lreg= 32;
@z

We assign the source file to filename[0]
and set also file_no[0]
@x
filename[0]=src_file_name;
filename_count=1;
@y
filename[0]=src_file_name;
file_no[0]=filename2file(src_file_name,0);
filename_count=1;
@z



We end with return instead of exit.

@x
if (err_count) {
  if (err_count>1) fprintf(stderr,"(%d errors were found.)\n",err_count);
  else fprintf(stderr,"(One error was found.)\n");
}
exit(err_count);
@y
  if (err_count>0){
    sprintf(err_buf,"%d errors and %d warnings were found.",err_count>>16, err_count&0xFFFF);
    report_error(err_buf);
  }
clean_up:
  if (listing_file!=NULL) 
  { fclose(listing_file);
    listing_file=NULL;
  }
  if (obj_file!=NULL) 
  { fclose(obj_file);
    obj_file=NULL;
  }
  if (src_file!=NULL) 
  { fclose(src_file);
    src_file=NULL;
  }
  cur_file=0;
  line_no=0;
  long_warning_given=0;
  cur_loc.h=cur_loc.l=0;
  listing_loc.h=listing_loc.l=0;
  spec_mode= 0;
  spec_mode_loc= 0;
  serial_number=0;
  free(buffer); buffer=NULL;
  free(lab_field); lab_field=NULL;
  free(op_field); op_field=NULL;
  free(operand_list); operand_list=NULL;
  free(err_buf);err_buf=NULL;
  free(op_stack); op_stack=NULL;
  free(val_stack);val_stack=NULL;
  filename[0]=NULL;
  filename_passed[0]=0;
  for (j=1;j<filename_count;j++)
  { free(filename[j]);
    filename[j]=NULL;
	filename_passed[j]=0;
  }
  filename_count=0;
  
return err_count;
@z

To report undefined local sysmbols we use the
usual error reporting.

@x
  err_count++,fprintf(stderr,"undefined local symbol %dF\n",j);
@y
  { err_count+=0x10000;
    sprintf(err_buf,"undefined local symbol %dF\n",j);
    report_error(err_buf);
  }
@z

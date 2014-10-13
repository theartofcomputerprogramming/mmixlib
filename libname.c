#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <setjmp.h>
#include "libconfig.h"
#include <time.h>
#include "libtype.h"
#include "libglobals.h"

#include <setjmp.h>
#include "libname.h"

/* simple implementation of the identity mapping */


int filename2file(char *filename, int c)
{ if (file_info[c].name==NULL)/* the usual case */
  { file_info[c].name = filename;
    return c;
  }
  else if (strcmp(file_info[c].name,filename)==0) /* the other usual case */
  { free(filename);
    return c;
  }
  MMIX_ERROR("ybyte does not match filename %s!\n",filename);
  free(filename);
  longjmp(mmix_exit,-6);
  return 0;
}

/* convert a ybyte to a valid index into file_info,
   return -1; if there is no valid file_info entry for this ybyte */
int ybyte2file(int c)
{ if (file_info[c].name)
    return c;
  else
    return -1;
}

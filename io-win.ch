
@x
#include <stdio.h>
#include <stdlib.h>
@y
#include <stdio.h>
#include <stdlib.h>

#pragma warning(disable : 4996 4267)

#ifdef MMIX_PRINT
extern int mmix_printf(char *format,...);
#define printf(...) mmix_printf(__VA_ARGS__)
#endif

@z


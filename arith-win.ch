
@x
@<Stuff for \CEE/ preprocessor@>@;
@y
@<Stuff for \CEE/ preprocessor@>@;

#pragma warning(disable : 4146 4018 4244 4267)

#ifdef MMIX_PRINT
extern int mmix_printf(char *format,...);
#define printf(...) mmix_printf(__VA_ARGS__)
#endif
@z

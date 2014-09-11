
/* simple implementation of the identity mapping */

int ybyte2file_no[256]; 

int filename2file(char *filename, char c)
{ return c;
}

int ybyte2file(char ybyte)
{
	return ybyte;
}
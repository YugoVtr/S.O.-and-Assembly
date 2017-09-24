#include <unistd.h> 
#include <sys/types.h>
#include <time.h> 
#include <stdio.h> 
#include <stdlib.h>

int main()
{
	srand( (unsigned)time(NULL) ); 
	if(!fork())
	{
		printf("%s","novo processo\n");
		while(1)
		{
			int t = rand() % 100;
			FILE *fp;
			fp = fopen("teste.txt","a+");
			if(fp == NULL) {
				printf("%s","nao abriu arq filho");
				return 0;
			}
			fprintf(fp,"%d",t);
			fprintf(fp,"%s","\n");
			fclose(fp);
		}
	}
	else
	{
		while(1)
		{
			int num;
			FILE *fp;
			fp = fopen("teste.txt","r");
			if(fp == NULL) {
				printf("%s","nao abriu arq pai");
				return 0;
			}
			while(fscanf(fp,"%d",&num))
				printf("n=%d \n",num);
			fclose(fp);
		}	
	}
	return 0;
}

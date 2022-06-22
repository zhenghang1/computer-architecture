#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

void wc(FILE *ofile, FILE *infile, char *inname) {
  // your code here:
  char result[20];
  int word=0,count=0,line=0;
  if(!inname)inname="";
  if(!infile){
	  char ch;
	  int isblank=0;
	  int isfirst=1;
	  while(scanf("%c",&ch)!=EOF){
		if(isfirst)if(ch!=' '){word++;isfirst=0;}  
		if(ch=='\n'){line++;word++;}
		else if(ch==' ')if(!isblank){word++;isblank=1;}
		else isblank=0;
		count++;
	}
  }
  else{
  	char str[1000];
  	while(!feof(infile)){
	  	fgets(str,1000,infile);
	  	line++;
		int i=0;
		for(i=0;str[i]!='\n';i++)count++;
		if(str[i]=='\n')count++;
		char *tmp2;
		char* tmp=str;
	while (*tmp !='\0') {
		 if(!((*tmp>=33)&&(*tmp<=126))) {
			tmp++;
			continue;
		 }
		 else {
			 tmp2=tmp+1;
			do {
				if(!((*tmp2>=33)&&(*tmp2<=126))) {
					word++;
					tmp=tmp2;
					break;
				}
			} while (*(++tmp2)!= '\0');
		}
	
	}
	}
	line--;
	count-=2;
	word--;
  }
  if(!ofile)printf("  %d  %d %d %s\n",line,word,count,inname);
  else fprintf(ofile,"  %d  %d %d %s\n",line,word,count,inname);
}

int main (int argc, char *argv[]) {

  char* out_file_name = NULL;
	char* inname = NULL;
	if(argc == 1) wc(NULL,NULL,NULL);
	else if(argc == 2){
		inname = argv[1];
		FILE *infile = fopen(inname,"r");
		if(!infile){
			perror("Input file opening failed");
			exit(1);
		}
		wc(NULL,infile,inname);
	}
	else if(argc == 3){
		inname = argv[1];
		FILE *infile = fopen(inname,"r");
		if(!infile){
			perror("Input file opening failed");
			exit(1);
		}
		FILE *out_file = fopen(argv[2],"w");
		if(!out_file){
			perror("Output file opening failed");
			exit(1);
		}
		wc(out_file,infile,inname);
	}
	else{
		printf("arguments error\n");
		exit(1);
	}
	return 0;

}

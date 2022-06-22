# <center>lab0 report

<p align="right">520021911347 郑航</p>



## exercise2

1. **How do you pass command line arguments to a program when using gdb?  **

   Use the set args command to set the command line parameters before using the run command.

2. **How do you set a breakpoint which only occurs when a set of conditions is true (e.g. when certain variables are a certain value)?  **

   Use the break ... if cond command, and ... is the parameter to settle where the breakpoint is,  cond is an expression. Only when the cond expression is true will the program stop at the breakpoint.

3. **How do you execute the next line of C code in the program after stopping at a breakpoint? ** 

   There are two ways. The first one is to use the next command (abbreviated as n), while the second one is to use the step command (abbreviated as s). The difference of these two ways is that when occurring to a function, the next command will take the function as a single line and skip it at one step while the step command will get inside the function to debug inside. 

4. **If the next line of code is a function call, you'll execute the whole function call at once if you use your answer to #3. How do you tell GDB that you want to debug the code inside the function instead?  **

   As in the answer to #3, we can use the step command instead of the next command.

5. **How do you resume the program after stopping at a breakpoint? **

   Use the continue command (abbreviated as c).

6. **How can you see the value of a variable (or even an expression like 1+2) in gdb? ** 

   Use the print command (abbreviated as p).

7. **How do you configure gdb so it prints the value of a variable after every step?**

   Use the display command (abbreviated as disp).

8. **How do you print a list of all variables and their values in the current function?**

   Use the info variables command.

9. **How do you exit out of gdb?  **

   Use the quit command (abbreviated as q).



## exercise3

The modified codes are as below:

~~~c
#include <stdio.h>

typedef struct node {
	int val;
	struct node* next;
} node;

/* FIXME: this function is buggy. */
int ll_equal(const node* a, const node* b) {
	while (a != NULL && b != NULL ) {
		if (a->val != b->val)
			return 0;
		a = a->next;
		b = b->next;
	}
	/* lists are equal if a and b are both null */
	return a == b;
}

int main(int argc, char** argv) {
	int i;
	node nodes[10];

	for (i=0; i<10; i++) {
		nodes[i].val = 0;
		nodes[i].next = NULL;
	}

	nodes[0].next = &nodes[1];
	nodes[1].next = &nodes[2];
	nodes[2].next = &nodes[3];

	printf("equal test 1 result = %d\n", ll_equal(&nodes[0], &nodes[0]));
	printf("equal test 2 result = %d\n", ll_equal(&nodes[0], &nodes[2]));

	return 0;
}

~~~



## exercise4

Function wc in wc.c:

~~~c
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

~~~

结果截图如下：



![截图](D:\A 上交\大二下\计算机系统结构\lab0\截图.png)


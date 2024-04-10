#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

float *A;
FILE *file;

int main() {
  int n;
  int lin;
  scanf("%d", &n);

  A = (float *) malloc (n * n * sizeof(float));

  srand(281);
  for(int i=0; i < n * n; i++) {
		A[i]= (float)(rand()%50);
  }

  if ((file = fopen("gauss.in", "w")) == NULL) {
		perror("gauss.in");
		exit(1);
	}

  fprintf(file,"%d\n",n);
  for(int i=0;i<n;i++) {
    for(int j=0;j<n;j++) {
      fprintf(file,"%.0f ",A[i*n+j]);
    }
    fprintf(file,"\n");;
  }

  srand(240);
  for(int i=0;i<n;i++) {
    fprintf(file,"%.0f ",((float)(rand()%20)));
  }

	fflush(file);

	fclose(file);
  free(A);
}
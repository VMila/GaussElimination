#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <cuda.h>

//#define DEBUG
#define TYPE double
#define BLOCK_SIZE 64
#define MAX_SIZE 4000
TYPE *a; // matriz de coeficientes
TYPE *x;
TYPE *b;
TYPE *swap;

//
__global__ void gElim(TYPE* a, TYPE* b, int n, int i) {

  int row = (i+1) + blockIdx.x * blockDim.x + threadIdx.x;
  if (row < n ) {
		TYPE m = a[row*n + i] / a[i*n+i];
		for (int k = i; k < n; k++) {
			a[row*n + k] = a[row*n + k] - m * a[i*n+k];
		}
		b[row] = b[row] - m * b[i];
  }
}

int main() {
	int r, n;
	int i, j;
	TYPE m;

	FILE *file;

	if ((file = fopen("gauss.in", "r")) == NULL) {
		perror("gauss.in");
		exit(1);
	}

	if(!fscanf(file, "%d", &n)){
		perror("n in gauss.in");
		exit(1);
	}

	a = (TYPE*) malloc(n*n*sizeof(TYPE));
	x = (TYPE*) malloc(n*sizeof(TYPE));
	b = (TYPE*) malloc(n*sizeof(TYPE));
	swap = (TYPE*) malloc(n*sizeof(TYPE));

	for (r = 0; r < n * n; r++) {
		if(!fscanf(file, "%lf", &a[r])){
			perror("a in gauss.in");
			exit(1);
		}
	}

	for (r = 0; r < n; r++){
		if(!fscanf(file, "%lf", &b[r])){
			perror("b in gauss.in");
			exit(1);
		}
	}

	fclose(file);

	cudaEvent_t start, stop;

	// Criacao dos eventos
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

  TYPE *d_a, *d_b;
  cudaMalloc((void **)&d_a, n*n*sizeof(TYPE));
  cudaMalloc((void **)&d_b, n*sizeof(TYPE));

  int block = BLOCK_SIZE;
	int grid = (n + block - 1) / block;

	cudaEventRecord(start);

	cudaMemcpy(d_a, a, n*n*sizeof(TYPE), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, n*sizeof(TYPE), cudaMemcpyHostToDevice);


	for (i = 0; i < n - 1; i++) {

		gElim <<< grid, block >>> (d_a, d_b, n, i);
		cudaError_t erro = cudaGetLastError();
		if(erro != cudaSuccess){
			printf("Erro na ativação do kernel: %s\n", cudaGetErrorString(erro));
			exit(1);
		}
	}
	cudaMemcpy(a, d_a, n*n*sizeof(TYPE), cudaMemcpyDeviceToHost);
  cudaMemcpy(b, d_b, n*sizeof(TYPE), cudaMemcpyDeviceToHost);

	cudaEventRecord(stop);

	x[i] = b[i] / a[i*n + i];
	for (i = i - 1; i >= 0; i--) {
		m = 0;
		for (j = i; j < n; j++)
			m = m + a[i*n + j] * x[j];
		x[i] = (b[i] - m) / a[i*n + i];
	}

	// garante que o evento stop já ocorreu
	cudaEventSynchronize(stop);

	float milliseconds = 0;
	cudaEventElapsedTime(&milliseconds, start, stop);
	printf("Tempo de Execução na GPU: %.4f s\n", milliseconds/1000);

//#define DEBUG
#ifdef DEBUG
	for (int r = 0; r < n; r++) {
		for (int c = 0; c < n; c++) {
			fprintf(stdout, "%.2lf ", a[r*n + c]);
		}
		fprintf(stdout, "\n");
	}
  fprintf(stdout, "\n");
	for (r = 0; r < n; r++)
	fprintf(stdout, "%.2lf ", b[r]);
	fprintf(stdout, "\n");
#endif

	if ((file = fopen("gaussCUDA.out", "w")) == NULL) {
		perror("gaussCUDA.out");
		exit(1);
	}

	for (r = 0; r < n; r++)
		fprintf(file, "%2.2lf ", x[r]);
	fprintf(file, "\n");
	for (r = 0; r < 10; r++)
		fprintf(stdout, "%2.2lf ", x[r]);
	fprintf(stdout, "\n");
	fflush(file);
	fclose(file);

	free(a);
  free(x);
  free(b);
  free(swap);
  cudaFree(d_a);
  cudaFree(d_b);

	return EXIT_SUCCESS;
}
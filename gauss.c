#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

//#define DEBUG
#define MAX 4000
long double a[MAX][MAX];
long double x[MAX];
long double b[MAX];
long double swap[MAX];

int main() {

	int r, c, n;
	int i, j, k;
	long double m;

	FILE *file;

	if ((file = fopen("gauss.in", "r")) == NULL) {
		perror("gauss.in");
		exit(1);
	}

	if(!fscanf(file, "%d", &n)){
		perror("n in gauss.in");
		exit(1);
	}
	printf("%d\n", n);

	for (r = 0; r < n; r++) {
		for (c = 0; c < n; c++) {
			if(!fscanf(file, "%Lf", &a[r][c])){
				perror("a in gauss.in");
				exit(1);
			}
		}
	}

	for (r = 0; r < n; r++){
		if(!fscanf(file, "%Lf", &b[r])){
			perror("b in gauss.in");
			exit(1);
		}
	}

	fclose(file);
	for (i = 0; i < n - 1; i++) {

		for (j = i + 1; j < n; j++) {
			m = a[j][i] / a[i][i];
			for (k = i; k < n; k++) {
				a[j][k] = a[j][k] - a[i][k] * m;
			}
			b[j] = b[j] - b[i] * m;
		}
	}

	x[i] = b[i] / a[i][i];

	for (i--; i >= 0; i--) {
		m = 0;
		for (j = i; j < n; j++)
			m = m + a[i][j] * x[j];
		x[i] = (b[i] - m) / a[i][i];
	}

#ifdef DEBUG
	for (r = 0; r < n; r++) {
		for (c = 0; c < n; c++) {
			fprintf(stdout, "%Lf ", a[r][c]);
		}
		fprintf(stdout, "\n");
	}
	for (r = 0; r < n; r++)
	fprintf(stdout, "%Lf ", b[r]);
	fprintf(stdout, "\n");
#endif

	if ((file = fopen("gauss.out", "w")) == NULL) {
		perror("gauss.out");
		exit(1);
	}

	for (r = 0; r < n; r++)
		printf("%2.2Lf ", x[r]);
	printf("\n");
	fflush(file);

	fclose(file);

	return EXIT_SUCCESS;
}
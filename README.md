# GaussElimination
---

Ivan Capeli Navas

João Paulo Migliatti

Matheus Yuiti Moriy Miata

Vitor Milanez

---
Compilação de generateFile.c:

! gcc -o gen generateFile.c && ./gen

! cat gauss.in

Compilação de gauss.c:

! gcc -O3 -Wall -o gauss gauss.c

! echo 'Results: '

! time ./gauss

Compilação de gaussOMP.c:

! gcc -O3 -Wall -o gaussOMP gaussOMP.c -fopenmp

! echo 'Results: '

! time ./gaussOMP

! cat gaussOMP.out

Compilação de gaussCUDA.c:

! nvcc gaussCUDA.cu -o gaussCUDA -O3

! nvprof --unified-memory-profiling off ./gaussCUDA

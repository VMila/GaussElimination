# Gauss Elimination
---

Ivan Capeli Navas 

João Paulo Migliatti 

Matheus Yuiti Moriy Miata 

Vitor Milanez 

---
- generateFile.c:
``` Bash
# Compilação e execução do programa generateFile.c
gcc -o gen generateFile.c && ./gen

# Vizualização da saída gerada no arquivo gauss.in
cat gauss.in
```

- gauss.c:
``` Bash
# Compilação do programa sequencial gauss.c
gcc -O3 -Wall -o gauss gauss.c

# Execução do programa com os tempos de execução
echo 'Results: '
time ./gauss

# Vizualização da saída gerada no arquivo gauss.out
cat gauss.out
```

- gaussOMP.c:
``` Bash
# Compilação do programa paralelo gaussOMP.c em ambiente multicore
gcc -O3 -Wall -o gaussOMP gaussOMP.c -fopenmp

# Execução do programa com os tempos de execução
echo 'Results: '
time ./gaussOMP

# Vizualização da saída gerada no arquivo gaussOMP.out
cat gaussOMP.out
```

- gaussCUDA.c:
``` Shell
# Compilação do programa paralelo gaussCUDA.cu em GPU
nvcc gaussCUDA.cu -o gaussCUDA -O3

# Execução do programa com as informações da execução em GPU e CPU
nvprof --unified-memory-profiling off ./gaussCUDA

# Vizualização da saída gerada no arquivo gaussCUDA.out
cat gaussCUDA.out 
```

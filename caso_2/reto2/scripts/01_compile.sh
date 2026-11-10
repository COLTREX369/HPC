#!/bin/bash
mkdir -p ../bin ../results

gcc -O3 ../src/buffon_serial.c -o ../bin/buffon_serial -lm
gcc -O3 -fopenmp ../src/buffon_omp.c -o ../bin/buffon_omp -lm

gcc -O3 ../src/dartboard_serial.c -o ../bin/dartboard_serial -lm
gcc -O3 -fopenmp ../src/dartboard_omp.c -o ../bin/dartboard_omp -lm

echo "Compilación finalizada exitosamente."
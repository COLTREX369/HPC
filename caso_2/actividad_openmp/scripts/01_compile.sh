#!/bin/bash
echo "Compilando matrix_omp.c con OpenMP..."
gcc -O3 -fopenmp ../src/matrix_omp.c -o ../bin/matrix_omp
if [ $? -eq 0 ]; then
    echo "¡Compilación exitosa! Ejecutable guardado en bin/matrix_omp"
else
    echo "Error durante la compilación."
fi
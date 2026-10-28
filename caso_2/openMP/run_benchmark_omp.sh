#!/bin/bash

# Compilar el ejecutable
make

# Archivo de salida de resultados
OUTPUT_FILE="resultados_omp.csv"
echo "N,Hilos,Iteracion,Tiempo_s" > $OUTPUT_FILE

# Tamaños de matriz requeridos
SIZES=(600 1000 1500 2000 3000 4000)

# Lista de hilos a evaluar
THREADS=(1 2 4 8 16)

# Muestreo de 10 iteraciones
ITERATIONS=10

echo "=== Iniciando Benchmark de OpenMP ==="

for threads in "${THREADS[@]}"; do
    export OMP_NUM_THREADS=$threads
    echo "Testing con OMP_NUM_THREADS=$threads..."
    
    for N in "${SIZES[@]}"; do
        echo "  Ejecutando N=$N..."
        for iter in $(seq 1 $ITERATIONS); do
            # Ejecuta y captura únicamente la salida con el tiempo
            TIME=$(./matrix_omp $N)
            echo "$N,$threads,$iter,$TIME" >> $OUTPUT_FILE
        done
    done
done

echo "=== Benchmark Finalizado. Resultados guardados en $OUTPUT_FILE ==="
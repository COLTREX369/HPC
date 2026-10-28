#!/bin/bash
BIN="../bin/matrix_omp"
OUT="../results/benchmark_omp.csv"

echo "N,Hilos,Tiempo_seg" > $OUT
echo "Iniciando pruebas de Benchmark..."

HILOS=(1 2 4 8 16)
DIMENSIONES=(500 1000 1500 2000 3000 4000)
ITERACIONES=10

for N in "${DIMENSIONES[@]}"; do
    for THREADS in "${HILOS[@]}"; do
        for (( i=1; i<=$ITERACIONES; i++ )); do
            echo "Ejecutando: N=$N | Hilos=$THREADS | Repetición $i"
            $BIN $N $THREADS >> $OUT
        done
    done
done

echo "Benchmark finalizado. Resultados guardados en $OUT"
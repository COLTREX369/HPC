#!/bin/bash
BIN_DIR="../bin"
OUT_BUFFON="../results/benchmark_buffon.csv"
OUT_DART="../results/benchmark_dartboard.csv"

SIZES=(10000000 50000000 100000000)
THREADS=(1 2 4 8 16)
ITERATIONS=10

# Pruebas Buffon
echo "Algoritmo,N,Hilos,Iteracion,Tiempo_s" > $OUT_BUFFON
for N in "${SIZES[@]}"; do
    for iter in $(seq 1 $ITERATIONS); do
        T=$($BIN_DIR/buffon_serial $N)
        echo "Buffon_Serial,$N,1,$iter,$T" >> $OUT_BUFFON
    done
    for t in "${THREADS[@]}"; do
        export OMP_NUM_THREADS=$t
        for iter in $(seq 1 $ITERATIONS); do
            T=$($BIN_DIR/buffon_omp $N)
            echo "Buffon_OMP,$N,$t,$iter,$T" >> $OUT_BUFFON
        done
    done
done

# Pruebas Dartboard
echo "Algoritmo,N,Hilos,Iteracion,Tiempo_s" > $OUT_DART
for N in "${SIZES[@]}"; do
    for iter in $(seq 1 $ITERATIONS); do
        T=$($BIN_DIR/dartboard_serial $N)
        echo "Dartboard_Serial,$N,1,$iter,$T" >> $OUT_DART
    done
    for t in "${THREADS[@]}"; do
        export OMP_NUM_THREADS=$t
        for iter in $(seq 1 $ITERATIONS); do
            T=$($BIN_DIR/dartboard_omp $N)
            echo "Dartboard_OMP,$N,$t,$iter,$T" >> $OUT_DART
        done
    done
done

echo "Toma de tiempos completada."
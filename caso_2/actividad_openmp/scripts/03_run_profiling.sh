#!/bin/bash
BIN="../bin/matrix_omp"
OUT="../results/reporte_profiling.txt"
N_PROF=1500
THREADS=4

echo "=================================================" > $OUT
echo "   REPORTE DE CARACTERIZACIÓN (CPU Y MEMORIA)   " >> $OUT
echo "   Dimensión N = $N_PROF | Hilos = $THREADS     " >> $OUT
echo "   Fecha: $(date)                                " >> $OUT
echo "=================================================" >> $OUT
echo "" >> $TXT_OUT

echo "--- 1. CARACTERIZACIÓN DE HARDWARE Y CACHÉ (perf stat) ---" >> $OUT
perf stat -e instructions,cycles,L1-dcache-load-misses,cache-misses $BIN $N_PROF $THREADS 2>&1 | grep -E "instructions|cycles|cache-misses|seconds" >> $OUT
echo "" >> $OUT

echo "--- 2. CONSUMO DE MEMORIA RAM Y CPU (/usr/bin/time) ---" >> $OUT
/usr/bin/time -v $BIN $N_PROF $THREADS 2>&1 | grep -E "Percent of CPU|Maximum resident set size" >> $OUT

echo "Perfilado completado. Reporte guardado en $OUT"
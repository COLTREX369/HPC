#!/bin/bash

SRC="../src/matrix_mult.c"
BIN_DIR="../bin"
RES_DIR="../results"

mkdir -p $BIN_DIR $RES_DIR

echo "=================================================="
echo " 1. COMPILANDO CÓDIGO CON BANDERAS DE OPTIMIZACIÓN"
echo "=================================================="

gcc -O0 -Wall $SRC -o $BIN_DIR/matrix_O0 -lrt
echo "[OK] Compilado -O0 (Sin optimización - Línea base)"

gcc -O1 -Wall $SRC -o $BIN_DIR/matrix_O1 -lrt
echo "[OK] Compilado -O1 (Optimización básica)"

gcc -O2 -Wall $SRC -o $BIN_DIR/matrix_O2 -lrt
echo "[OK] Compilado -O2 (Optimización estándar)"

gcc -O3 -Wall $SRC -o $BIN_DIR/matrix_O3 -lrt
echo "[OK] Compilado -O3 (Optimización agresiva / Vectorización)"

gcc -Ofast -march=native -Wall $SRC -o $BIN_DIR/matrix_Ofast -lrt
echo "[OK] Compilado -Ofast -march=native (Máxima optimización de hardware)"

# Generar archivos ensamblador para inspección
gcc -O0 -S $SRC -o $RES_DIR/matrix_O0.s
gcc -O3 -S $SRC -o $RES_DIR/matrix_O3.s
echo "[OK] Archivos Ensamblador generados: matrix_O0.s y matrix_O3.s"

echo "=================================================="
echo " COMPILACIÓN FINALIZADA CON ÉXITO"
echo "=================================================="
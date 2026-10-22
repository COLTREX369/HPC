#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

BIN_DIR="../bin"
TXT_OUT="../results/reporte_profiling_traspuesta.txt"
EJECUTABLE="$BIN_DIR/matrix_trans_O2"
N_PROFILE=1000 

echo "==================================================" > $TXT_OUT
echo "   REPORTE DE PERFILADO: MATRIZ TRASPUESTA (PERF) " >> $TXT_OUT
echo "   Dimensión evaluada: N = $N_PROFILE             " >> $TXT_OUT
echo "==================================================" >> $TXT_OUT
echo "" >> $TXT_OUT

echo "Iniciando perfilado con 'perf stat'..."

perf stat -e instructions,cycles,L1-dcache-load-misses $EJECUTABLE $N_PROFILE 2>&1 | grep -E "instructions|cycles|L1-dcache-load-misses|seconds time elapsed" >> $TXT_OUT

echo "=================================================="
echo " PERFILADO COMPLETADO. Reporte guardado en:"
echo " $TXT_OUT"
echo "=================================================="
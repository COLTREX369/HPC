#!/bin/bash

BIN_DIR="../bin"
TXT_OUT="../results/reporte_profiling.txt"
N_PROFILE=1000 
BANDERAS=("O0" "O1" "O2" "O3" "Ofast")

echo "==================================================" > $TXT_OUT
echo "   REPORTE DE PERFILADO DE HARDWARE (PERF STAT)   " >> $TXT_OUT
echo "   Evaluación de Reducción de Instrucciones      " >> $TXT_OUT
echo "   Dimensión fija evaluada: N = $N_PROFILE        " >> $TXT_OUT
echo "==================================================" >> $TXT_OUT
echo "" >> $TXT_OUT

echo "Iniciando perfilado con 'perf stat'..."

for BANDERA in "${BANDERAS[@]}"; do
    EJECUTABLE="$BIN_DIR/matrix_$BANDERA"
    
    echo "--------------------------------------------------" >> $TXT_OUT
    echo ">>> METRICAS DE HARDWARE CON BANDERA: -$BANDERA" >> $TXT_OUT
    echo "--------------------------------------------------" >> $TXT_OUT
    
    perf stat -e instructions,cycles,L1-dcache-load-misses $EJECUTABLE $N_PROFILE 2>&1 | grep -E "instructions|cycles|L1-dcache-load-misses|seconds time elapsed" >> $TXT_OUT
    
    echo "" >> $TXT_OUT
done

echo "=================================================="
echo " PERFILADO COMPLETADO. Reporte guardado en:"
echo " $TXT_OUT"
echo "=================================================="
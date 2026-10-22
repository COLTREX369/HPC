#!/bin/bash

BIN_DIR="../bin"
CSV_OUT="../results/tiempos_optimizacion.csv"

TAMANOS=(600 1000 1500 2000 3000 4000)
BANDERAS=("O0" "O1" "O2" "O3" "Ofast")

echo "Bandera,N,Iteracion,Tiempo_Segundos" > $CSV_OUT

echo "=================================================="
echo " 2. BENCHMARKING DE TIEMPOS POR OPTIMIZACIÓN"
echo "=================================================="

for BANDERA in "${BANDERAS[@]}"; do
    EJECUTABLE="$BIN_DIR/matrix_$BANDERA"
    
    if [ ! -f "$EJECUTABLE" ]; then
        echo "Error: $EJECUTABLE no existe. Ejecuta primero 01_compile_all.sh"
        exit 1
    fi
    
    for N in "${TAMANOS[@]}"; do
        echo "Corriendo -$BANDERA | Tamaño N = $N..."
        
        OUTPUT=$($EJECUTABLE $N)
        
        echo "$OUTPUT" | grep "Iteracion" | awk -v band="$BANDERA" -v n="$N" '{print band "," n "," $2 "," $3}' | tr -d ':' >> $CSV_OUT
    done
done

echo "=================================================="
echo " BENCHMARK COMPLETADO. Resultados guardados en:"
echo " $CSV_OUT"
echo "=================================================="
#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

BIN_DIR="../bin"
CSV_OUT="../results/tiempos_traspuesta.csv"
EJECUTABLE="$BIN_DIR/matrix_trans_O2"

TAMANOS=(600 1000 1500 2000 3000 4000)

if [ ! -f "$EJECUTABLE" ]; then
    echo "Error: No existe el ejecutable $EJECUTABLE. Ejecuta 01_compile_transpose.sh primero."
    exit 1
fi

echo "Método,N,Iteracion,Tiempo_Segundos" > $CSV_OUT

echo "=================================================="
echo " BENCHMARK DE TIEMPOS CON MATRIZ TRASPUESTA"
echo "=================================================="

for N in "${TAMANOS[@]}"; do
    echo "Ejecutando Matriz Traspuesta (-O2) | Tamaño N = $N..."
    
    OUTPUT=$($EJECUTABLE $N)
    
    echo "$OUTPUT" | grep "Iteracion" | awk -v n="$N" '{print "Traspuesta_O2," n "," $2 "," $3}' | tr -d ':' >> $CSV_OUT
done

echo "=================================================="
echo " BENCHMARK COMPLETADO. Resultados guardados en:"
echo " $CSV_OUT"
echo "=================================================="
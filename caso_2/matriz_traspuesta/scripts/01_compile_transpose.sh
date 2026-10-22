#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

SRC="../src/matrix_transpose.c"
BIN_DIR="../bin"
RES_DIR="../results"

mkdir -p $BIN_DIR $RES_DIR

echo "=================================================="
echo " COMPILANDO VERSIÓN CON MATRIZ TRASPUESTA (-O2)"
echo "=================================================="

# Compilamos usando la bandera -O2 que fue nuestra mejor opción para matrices grandes
gcc -O2 -Wall $SRC -o $BIN_DIR/matrix_trans_O2 -lrt

if [ $? -eq 0 ]; then
    echo "[OK] Compilación exitosa: bin/matrix_trans_O2"
else
    echo "[ERROR] Falló la compilación de matrix_transpose.c"
    exit 1
fi

echo "=================================================="
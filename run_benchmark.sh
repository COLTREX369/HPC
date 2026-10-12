#!/bin/bash

# 1. Compilar automáticamente el código en C
echo "Compilando matrix_mult.c..."
gcc matrix_mult.c -o matrix_mult -O0 -Wall -lrt

if [ $? -ne 0 ]; then
    echo "Error de compilación. Abortando."
    exit 1
fi

# 2. Lista de tamaños N que quieres probar (puedes agregar o quitar los que quieras)
TAMANOS=(6000 4900 3800 2600 1400 700)

# 3. Archivo donde se guardarán todos los resultados
ARCHIVO_SALIDA="resultados_benchmarking.txt"

# Limpiar o crear el archivo de resultados
echo "==================================================" > $ARCHIVO_SALIDA
echo "       REPORTE AUTOMÁTICO DE BENCHMARKING         " >> $ARCHIVO_SALIDA
echo "       Fecha: $(date)" >> $ARCHIVO_SALIDA
echo "==================================================" >> $ARCHIVO_SALIDA
echo "" >> $ARCHIVO_SALIDA

echo "Iniciando experimento masivo... Déjalo corriendo."

# 4. Bucle que recorre cada tamaño N de la lista
for N in "${TAMANOS[@]}"; do
    echo "--------------------------------------------------" | tee -a $ARCHIVO_SALIDA
    echo ">>> EJECUTANDO EXPERIMENTO PARA MATRIZ N = $N" | tee -a $ARCHIVO_SALIDA
    echo "--------------------------------------------------" | tee -a $ARCHIVO_SALIDA
    
    # Ejecuta el programa en C (que internamente corre las 10 iteraciones)
    # 'tee -a' muestra la salida en la terminal Y la guarda al mismo tiempo en el archivo
    ./matrix_mult $N | tee -a $ARCHIVO_SALIDA
    
    echo "" | tee -a $ARCHIVO_SALIDA
done

echo "==================================================" | tee -a $ARCHIVO_SALIDA
echo " ¡PROCESO COMPLETADO! Todos los datos se guardaron en: $ARCHIVO_SALIDA" | tee -a $ARCHIVO_SALIDA
echo "==================================================" | tee -a $ARCHIVO_SALIDA
#!/bin/bash

# 1. Compilar automáticamente el código de hilos con la librería -pthread
echo "Compilando matrix_mult_pthreads.c..."
gcc matrix_mult_pthreads.c -o matrix_mult_pthreads -O0 -Wall -pthread -lrt

if [ $? -ne 0 ]; then
    echo "Error de compilación. Abortando."
    exit 1
fi

# 2. Configuración de parámetros para los experimentos
TAMANOS=( 600 1000 1500 2000 3000 4000) # Tamaños de matrices a evaluar
HILOS_LISTA=(1 2 4 8 16) # Cantidades de hilos a evaluar

# 3. Archivo de salida de resultados
ARCHIVO_SALIDA="resultados_benchmarking_pthreads.txt"

# Inicializar/Limpiar el archivo de reporte
echo "==================================================" > $ARCHIVO_SALIDA
echo "   REPORTE AUTOMÁTICO DE BENCHMARKING (PTHREADS)  " >> $ARCHIVO_SALIDA
echo "   Fecha: $(date)" >> $ARCHIVO_SALIDA
echo "==================================================" >> $ARCHIVO_SALIDA
echo "" >> $ARCHIVO_SALIDA

echo "Iniciando experimento masivo con hilos... Déjalo corriendo."

# 4. Doble bucle: recorre tamaños N y cantidad de hilos
for N in "${TAMANOS[@]}"; do
    for HILOS in "${HILOS_LISTA[@]}"; do
        echo "--------------------------------------------------" | tee -a $ARCHIVO_SALIDA
        echo ">>> EVALUANDO: Matriz N = $N | Hilos = $HILOS" | tee -a $ARCHIVO_SALIDA
        echo "--------------------------------------------------" | tee -a $ARCHIVO_SALIDA
        
        # Ejecuta el binario de hilos (que corre las 10 iteraciones internamente)
        ./matrix_mult_pthreads $N $HILOS | tee -a $ARCHIVO_SALIDA
        
        echo "" | tee -a $ARCHIVO_SALIDA
    done
done

echo "==================================================" | tee -a $ARCHIVO_SALIDA
echo " ¡PROCESO COMPLETADO! Resultados guardados en: $ARCHIVO_SALIDA" | tee -a $ARCHIVO_SALIDA
echo "==================================================" | tee -a $ARCHIVO_SALIDA
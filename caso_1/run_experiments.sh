#!/bin/bash

# 1. Compilación sin optimizaciones de compilador para medir paralelismo puro (-O0)
echo "Compilando ejecutables..."
gcc matrix_mult_pthreads.c -o matrix_mult_pthreads -O0 -Wall -pthread -lrt
gcc matrix_mult_processes.c -o matrix_mult_processes -O0 -Wall -lrt

if [ $? -ne 0 ]; then
    echo "Error de compilación. Abortando."
    exit 1
fi

# 2. Configuración de parámetros de prueba
TAMANOS=(600 1000 1500 2000 3000 4000)
WORKERS=(1 2 4 8 16) # Cantidad de Hilos / Procesos

ARCHIVO_CSV="resultados_desempeno.csv"
ARCHIVO_TXT="reporte_ejecucion.txt"

# Crear cabecera CSV
echo "Tipo,N,Workers,Iteracion,Tiempo_Segundos" > $ARCHIVO_CSV

# Limpiar reporte TXT
echo "==================================================" > $ARCHIVO_TXT
echo "      PRUEBAS DE DESEMPEÑO HPC: HILOS Y PROCESOS   " >> $ARCHIVO_TXT
echo "      Fecha: $(date)" >> $ARCHIVO_TXT
echo "==================================================" >> $ARCHIVO_TXT
echo "" >> $ARCHIVO_TXT

echo "Iniciando ejecución automatizada de experimentos..."

# 3. Pruebas con Hilos (pthread)
echo "--------------------------------------------------"
echo ">>> Ejecutando pruebas con HILOS (pthread)"
echo "--------------------------------------------------"
for N in "${TAMANOS[@]}"; do
    for W in "${WORKERS[@]}"; do
        echo "Ejecutando: Hilos | N = $N | Workers = $W" | tee -a $ARCHIVO_TXT
        OUTPUT=$(./matrix_mult_pthreads $N $W)
        echo "$OUTPUT" >> $ARCHIVO_TXT
        
        # Extraer filas de tiempo y guardar en CSV
        echo "$OUTPUT" | grep "Iteracion" | awk -v tipo="Hilos" -v n="$N" -v w="$W" '{print tipo "," n "," w "," $2 "," $3}' | tr -d ':' >> $ARCHIVO_CSV
    done
done

# 4. Pruebas con Procesos (fork)
echo "--------------------------------------------------"
echo ">>> Ejecutando pruebas con PROCESOS (fork)"
echo "--------------------------------------------------"
for N in "${TAMANOS[@]}"; do
    for W in "${WORKERS[@]}"; do
        echo "Ejecutando: Procesos | N = $N | Workers = $W" | tee -a $ARCHIVO_TXT
        OUTPUT=$(./matrix_mult_processes $N $W)
        echo "$OUTPUT" >> $ARCHIVO_TXT
        
        # Extraer filas de tiempo y guardar en CSV
        echo "$OUTPUT" | grep "Iteracion" | awk -v tipo="Procesos" -v n="$N" -v w="$W" '{print tipo "," n "," w "," $2 "," $3}' | tr -d ':' >> $ARCHIVO_CSV
    done
done

echo "=================================================="
echo " ¡PROCESO COMPLETADO EXITOSAMENTE!"
echo " - Resultados detallados: $ARCHIVO_TXT"
echo " - Archivo CSV para gráficas: $ARCHIVO_CSV"
echo "=================================================="
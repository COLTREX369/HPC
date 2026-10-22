import os
import matplotlib
# Configurar Matplotlib para ejecuciones en servidores Linux/WSL sin pausar la terminal
matplotlib.use('Agg')

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")
plt.rcParams.update({'font.size': 11})

# Función auxiliar para localizar archivos CSV de forma flexible
def buscar_csv(rutas_posibles):
    for ruta in rutas_posibles:
        if os.path.exists(ruta):
            return ruta
    return None

ruta_compilador = buscar_csv([
    'optimizacion_compilacion/results/tiempos_optimizacion.csv',
    'optimizacion_compilacion/tiempos_optimizacion.csv',
    'tiempos_optimizacion.csv'
])

ruta_traspuesta = buscar_csv([
    'matriz_traspuesta/results/tiempos_traspuesta.csv',
    'matriz_traspuesta/tiempos_traspuesta.csv',
    'tiempos_traspuesta.csv'
])

if not ruta_compilador or not ruta_traspuesta:
    print("❌ ERROR: No se encontraron los archivos CSV.")
    print(f"Ruta Compilador detectada: {ruta_compilador}")
    print(f"Ruta Traspuesta detectada: {ruta_traspuesta}")
    exit(1)

print(f"✅ Cargando datos de Compilador desde: {ruta_compilador}")
print(f"✅ Cargando datos de Traspuesta desde:  {ruta_traspuesta}")

# 1. Cargar DataFrames
df_comp = pd.read_csv(ruta_compilador)
df_trans = pd.read_csv(ruta_traspuesta)

# Homologar nombres de columnas
df_comp.rename(columns={'Bandera': 'Metodo'}, inplace=True)
df_trans.rename(columns={'Método': 'Metodo'}, inplace=True)

# 2. Unir datasets y filtrar iteración 1 (Efecto Warm-up / Calentamiento)
df_total = pd.concat([df_comp, df_trans], ignore_index=True)
df_clean = df_total[df_total['Iteracion'] > 1]

# 3. Calcular promedios por Método y Tamaño N
df_summary = df_clean.groupby(['Metodo', 'N'])['Tiempo_Segundos'].mean().reset_index()

# 4. Calcular Speedup relativo a -O0
base_times = df_summary[df_summary['Metodo'] == 'O0'].set_index('N')['Tiempo_Segundos'].to_dict()

def calc_speedup(row):
    t0 = base_times.get(row['N'])
    return t0 / row['Tiempo_Segundos'] if t0 and row['Tiempo_Segundos'] > 0 else 1.0

df_summary['Speedup'] = df_summary.apply(calc_speedup, axis=1)

print("\n=== RESUMEN DE TIEMPOS PROMEDIO (SEGUNDOS) ===")
print(df_summary.pivot(index='N', columns='Metodo', values='Tiempo_Segundos'))

print("\n=== RESUMEN DE SPEEDUP RELATIVO A -O0 ===")
print(df_summary.pivot(index='N', columns='Metodo', values='Speedup'))

# ------------------------------------------------------------------------------
# GRÁFICA 1: Tiempo de Ejecución vs Tamaño N
# ------------------------------------------------------------------------------
plt.figure(figsize=(10, 6))

metodos_clave = ['O0', 'O2', 'Ofast', 'Traspuesta_O2']
df_filtrado = df_summary[df_summary['Metodo'].isin(metodos_clave)]

sns.lineplot(
    data=df_filtrado, 
    x='N', 
    y='Tiempo_Segundos', 
    hue='Metodo', 
    style='Metodo',
    markers=True, 
    dashes=False,
    linewidth=2.5,
    markersize=8
)

plt.title('Caso 2: Comparativa de Tiempos - Compilador vs. Matriz Traspuesta (B^T)', fontsize=13, fontweight='bold')
plt.xlabel('Dimensión de la Matriz (N)', fontsize=11)
plt.ylabel('Tiempo Promedio (Segundos - Escala Log)', fontsize=11)
plt.yscale('log')
plt.grid(True, which="both", linestyle="--", alpha=0.5)
plt.legend(title='Estrategia', bbox_to_anchor=(1.05, 1), loc='upper left')
plt.tight_layout()

# Guardar Gráfica 1
plt.savefig('comparativa_tiempos_caso2.png', dpi=300)
plt.close()
print("🖼️  Gráfica 1 guardada: comparativa_tiempos_caso2.png")

# ------------------------------------------------------------------------------
# GRÁFICA 2: Speedup vs Tamaño N
# ------------------------------------------------------------------------------
plt.figure(figsize=(10, 6))

df_speedup_filt = df_summary[df_summary['Metodo'] != 'O0']

sns.lineplot(
    data=df_speedup_filt, 
    x='N', 
    y='Speedup', 
    hue='Metodo', 
    style='Metodo',
    markers=True, 
    dashes=False,
    linewidth=2.5,
    markersize=8
)

plt.axhline(1.0, color='red', linestyle='--', label='Línea base (-O0)')
plt.title('Caso 2: Aceleración (Speedup) respecto a Línea Base (-O0)', fontsize=13, fontweight='bold')
plt.xlabel('Dimensión de la Matriz (N)', fontsize=11)
plt.ylabel('Speedup (T_O0 / T_Metodo)', fontsize=11)
plt.grid(True, linestyle=":", alpha=0.7)
plt.legend(title='Estrategia', bbox_to_anchor=(1.05, 1), loc='upper left')
plt.tight_layout()

# Guardar Gráfica 2
plt.savefig('comparativa_speedup_caso2.png', dpi=300)
plt.close()
print("🖼️  Gráfica 2 guardada: comparativa_speedup_caso2.png")

print("\n🚀 ¡Proceso finalizado! Ambas imágenes están generadas en la carpeta 'caso_2'.")
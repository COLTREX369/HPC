#!/usr/bin/env bash
# Uso: ./scripts/03_run_profiling.sh [N] [HILOS]
# Ejemplo: ./scripts/03_run_profiling.sh 100000000 4

set -u
export LC_ALL=C

N="${1:-100000000}"
THREADS="${2:-4}"
# Valgrind simula la CPU por software (~50x más lento); usamos N menor para caché
VG_N="${VG_N:-10000000}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_BUFFON="$ROOT/bin/buffon_omp"
BIN_DART="$ROOT/bin/dartboard_omp"
RESULTS="$ROOT/results"
REPORT="$RESULTS/reporte_profiling.txt"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$RESULTS" "$ROOT/bin"

# 1. Verificar dependencias
for cmd in gcc valgrind /usr/bin/time; do
    command -v "$cmd" >/dev/null 2>&1 || [ -x "$cmd" ] || {
        echo "Falta '$cmd'. Instala con: apt install -y gcc valgrind time" >&2
        exit 1
    }
done

# 2. Compilar con símbolos de depuración (-g) y optimización (-O3)
gcc -O3 -g -fopenmp "$ROOT/src/buffon_omp.c" -o "$BIN_BUFFON" -lm || { echo "Error compilando Buffon" >&2; exit 1; }
gcc -O3 -g -fopenmp "$ROOT/src/dartboard_omp.c" -o "$BIN_DART" -lm || { echo "Error compilando Dartboard" >&2; exit 1; }

export OMP_NUM_THREADS="$THREADS"

echo "Ejecutando profiling para Buffon y Dartboard (N=$N, Hilos=$THREADS)..."

# =========================================================
# SECCIÓN A: AGUJA DE BUFFON
# =========================================================
/usr/bin/time -v -o "$TMP/buffon_time.log" "$BIN_BUFFON" "$N" > "$TMP/buffon_stdout.txt" 2> "$TMP/buffon_stderr.txt"

valgrind --tool=cachegrind \
         --cache-sim=yes \
         --cachegrind-out-file="$TMP/buffon_cg.out" \
         --log-file="$TMP/buffon_vg.log" \
         "$BIN_BUFFON" "$VG_N" > "$TMP/buffon_vg_out.txt" 2>&1

sync
BUFFON_CACHE="$(sed 's/^==[0-9]*== *//' "$TMP/buffon_vg.log" \
    | grep -E '^(I +refs|I1 +misses|LLi +misses|D +refs|D1 +misses|LLd +misses):')"

# =========================================================
# SECCIÓN B: TABLERO DE DARDOS
# =========================================================
/usr/bin/time -v -o "$TMP/dart_time.log" "$BIN_DART" "$N" > "$TMP/dart_stdout.txt" 2> "$TMP/dart_stderr.txt"

valgrind --tool=cachegrind \
         --cache-sim=yes \
         --cachegrind-out-file="$TMP/dart_cg.out" \
         --log-file="$TMP/dart_vg.log" \
         "$BIN_DART" "$VG_N" > "$TMP/dart_vg_out.txt" 2>&1

sync
DART_CACHE="$(sed 's/^==[0-9]*== *//' "$TMP/dart_vg.log" \
    | grep -E '^(I +refs|I1 +misses|LLi +misses|D +refs|D1 +misses|LLd +misses):')"

# =========================================================
# SECCIÓN C: CONSTRUCCIÓN DEL REPORTE FINAL
# =========================================================
{
    echo "================================================="
    echo " REPORTE DE PROFILING - RETO 2 (OpenMP)"
    echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
    echo " N (time) = $N | N (Valgrind) = $VG_N | Hilos = $THREADS"
    echo "================================================="
    echo
    echo "-------------------------------------------------"
    echo " 1. AGUJA DE BUFFON (buffon_omp)"
    echo "-------------------------------------------------"
    echo "Tiempo de ejecución nativo: $(cat "$TMP/buffon_stdout.txt") segundos"
    echo
    echo "--- CPU y Memoria RAM (/usr/bin/time -v) ---"
    grep -E 'User time|System time|Percent of CPU|Elapsed \(wall|Maximum resident set size' "$TMP/buffon_time.log" \
        | sed 's/^[[:space:]]*//'
    echo
    echo "--- Perfilado de Caché (Valgrind Cachegrind, N=$VG_N) ---"
    printf '%s\n' "$BUFFON_CACHE"
    echo
    echo "-------------------------------------------------"
    echo " 2. TABLERO DE DARDOS (dartboard_omp)"
    echo "-------------------------------------------------"
    echo "Tiempo de ejecución nativo: $(cat "$TMP/dart_stdout.txt") segundos"
    echo
    echo "--- CPU y Memoria RAM (/usr/bin/time -v) ---"
    grep -E 'User time|System time|Percent of CPU|Elapsed \(wall|Maximum resident set size' "$TMP/dart_time.log" \
        | sed 's/^[[:space:]]*//'
    echo
    echo "--- Perfilado de Caché (Valgrind Cachegrind, N=$VG_N) ---"
    printf '%s\n' "$DART_CACHE"
} > "$REPORT"

cat "$REPORT"
echo
echo "Reporte generado con éxito en: $REPORT"
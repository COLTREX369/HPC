#!/usr/bin/env bash
# Uso: ./scripts/03_run_profiling.sh [N] [HILOS]
# Opcional: VG_N=500 ./scripts/03_run_profiling.sh 1500 4
#   (Valgrind es ~50x más lento; puedes usar un N menor solo para caché)

set -u
export LC_ALL=C

N="${1:-1500}"
THREADS="${2:-4}"
VG_N="${VG_N:-$N}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/src/matrix_omp.c"
BIN="$ROOT/bin/matrix_omp"
RESULTS="$ROOT/results"
REPORT="$RESULTS/reporte_profiling.txt"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$RESULTS"
mkdir -p "$ROOT/bin"

# Dependencias
for cmd in gcc valgrind /usr/bin/time; do
    command -v "$cmd" >/dev/null 2>&1 || [ -x "$cmd" ] || {
        echo "Falta '$cmd'. Instala: apt install -y gcc valgrind time" >&2
        exit 1
    }
done

# Compilar con símbolos de depuración (necesario para Valgrind)
if [ ! -x "$BIN" ] || [ "$SRC" -nt "$BIN" ]; then
    gcc -O2 -g -fopenmp "$SRC" -o "$BIN" || { echo "Error compilando" >&2; exit 1; }
fi

export OMP_NUM_THREADS="$THREADS"

# ---------- 1) CPU y RAM con /usr/bin/time -v ----------
/usr/bin/time -v -o "$TMP/time.log" "$BIN" "$N" "$THREADS" > "$TMP/time_stdout.txt" 2> "$TMP/time_stderr.txt"
if [ ! -s "$TMP/time.log" ]; then
    echo "Fallo /usr/bin/time" >&2; exit 1
fi

# ---------- 2) Cachegrind: sin pipes, todo a archivos ----------
valgrind --tool=cachegrind \
         --cache-sim=yes \
         --cachegrind-out-file="$TMP/cachegrind.out" \
         --log-file="$TMP/valgrind.log" \
         "$BIN" "$VG_N" "$THREADS" > "$TMP/vg_stdout.txt" 2> "$TMP/vg_stderr.txt"
VG_RC=$?

# Valgrind terminó: ahora sí se filtra el log ya completo
sync
CACHE_LINES="$(sed 's/^==[0-9]*== *//' "$TMP/valgrind.log" \
    | grep -E '^(I +refs|I1 +misses|LLi +misses|D +refs|D1 +misses|LLd +misses):')"

if [ "$VG_RC" -ne 0 ] || [ "$(printf '%s\n' "$CACHE_LINES" | grep -c .)" -lt 6 ]; then
    echo "Valgrind no produjo el resumen completo (rc=$VG_RC). Log:" >&2
    cat "$TMP/valgrind.log" >&2
    exit 1
fi

# ---------- 3) Reporte final ----------
{
    echo "=============================================="
    echo " REPORTE DE PROFILING  -  matrix_omp"
    echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
    echo " N (time) = $N | N (valgrind) = $VG_N | Hilos = $THREADS"
    echo "=============================================="
    echo
    echo "--- Resultado del programa (CSV: N,Hilos,Tiempo_s) ---"
    cat "$TMP/time_stdout.txt"
    echo
    echo "--- CPU y memoria RAM (/usr/bin/time -v) ---"
    grep -E 'User time|System time|Percent of CPU|Elapsed \(wall|Maximum resident set size' "$TMP/time.log" \
        | sed 's/^[[:space:]]*//'
    echo
    echo "--- Caché (valgrind --tool=cachegrind, N=$VG_N) ---"
    printf '%s\n' "$CACHE_LINES"
} > "$REPORT"

cat "$REPORT"
echo
echo "Reporte guardado en: $REPORT"
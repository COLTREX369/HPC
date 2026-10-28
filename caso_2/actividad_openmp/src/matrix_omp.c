#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <sys/time.h>

void multiply_matrices_omp(double *A, double *B, double *C, int N) {
    // Reordenamiento i-k-j paralelizado con OpenMP
    #pragma omp parallel for collapse(1) schedule(static)
    for (int i = 0; i < N; i++) {
        for (int k = 0; k < N; k++) {
            double r = A[i * N + k];
            for (int j = 0; j < N; j++) {
                C[i * N + j] += r * B[k * N + j];
            }
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Uso: %s <N (Dimensión)> <Num_Hilos>\n", argv[0]);
        return 1;
    }

    int N = atoi(argv[1]);
    int num_threads = atoi(argv[2]);

    omp_set_num_threads(num_threads);

    // Reservar memoria dinámicamente
    double *A = (double *)malloc(N * N * sizeof(double));
    double *B = (double *)malloc(N * N * sizeof(double));
    double *C = (double *)calloc(N * N, sizeof(double));

    if (!A || !B || !C) {
        printf("Error asignando memoria para N = %d\n", N);
        return 1;
    }

    // Inicializar matrices
    for (int i = 0; i < N * N; i++) {
        A[i] = 1.0;
        B[i] = 2.0;
    }

    // Medición del tiempo con OpenMP
    double start_time = omp_get_wtime();
    multiply_matrices_omp(A, B, C, N);
    double end_time = omp_get_wtime();

    double elapsed_time = end_time - start_time;

    // Salida para captura CSV: N, Hilos, Tiempo(s)
    printf("%d,%d,%.6f\n", N, num_threads, elapsed_time);

    free(A);
    free(B);
    free(C);

    return 0;
}
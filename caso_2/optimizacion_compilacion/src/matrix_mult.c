#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define NUM_ITERACIONES 10

void multiplicar_matrices(double *A, double *B, double *C, int N) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            double suma = 0.0;
            for (int k = 0; k < N; k++) {
                suma += A[i * N + k] * B[k * N + j];
            }
            C[i * N + j] = suma;
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Uso: %s <N>\n", argv[0]);
        return 1;
    }

    int N = atoi(argv[1]);
    size_t size = (size_t)N * N * sizeof(double);

    double *A = (double *)malloc(size);
    double *B = (double *)malloc(size);
    double *C = (double *)malloc(size);

    if (!A || !B || !C) {
        fprintf(stderr, "Error al asignar memoria.\n");
        return 1;
    }

    // Inicialización de matrices
    for (int i = 0; i < N * N; i++) {
        A[i] = 1.0;
        B[i] = 2.0;
        C[i] = 0.0;
    }

    printf("=== Ejecutando %d iteraciones para N = %d ===\n", NUM_ITERACIONES, N);

    struct timespec start, end;
    for (int it = 1; it <= NUM_ITERACIONES; it++) {
        clock_gettime(CLOCK_MONOTONIC, &start);
        
        multiplicar_matrices(A, B, C, N);
        
        clock_gettime(CLOCK_MONOTONIC, &end);
        
        double tiempo = (end.tv_sec - start.tv_sec) + 
                        (end.tv_nsec - start.tv_nsec) / 1e9;
        
        printf("Iteracion %d: %.6f segundos\n", it, tiempo);
    }

    free(A);
    free(B);
    free(C);
    return 0;
}
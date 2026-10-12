#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ITERACIONES 10

int* allocate_matrix(int n) {
    int *matrix = (int*)malloc(n * n * sizeof(int));
    if (matrix == NULL) {
        fprintf(stderr, "Error: No se pudo reservar memoria.\n");
        exit(EXIT_FAILURE);
    }
    return matrix;
}

void fill_matrix(int* matrix, int n) {
    for (int i = 0; i < n * n; i++) {
        matrix[i] = (rand() % 10) + 1; 
    }
}

void multiply_matrices(int* A, int* B, int* C, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            int suma_temporal = 0;
            for (int k = 0; k < n; k++) {
                suma_temporal += A[i * n + k] * B[k * n + j];
            }
            C[i * n + j] = suma_temporal;
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Uso: %s <tamano_matriz_N>\n", argv[0]);
        return EXIT_FAILURE;
    }

    int N = atoi(argv[1]);
    if (N <= 0) {
        fprintf(stderr, "Error: El tamaño N debe ser un entero positivo.\n");
        return EXIT_FAILURE;
    }

    srand(time(NULL));

    int *A = allocate_matrix(N);
    int *B = allocate_matrix(N);
    int *C = allocate_matrix(N);

    fill_matrix(A, N);
    fill_matrix(B, N);

    printf("=== Ejecutando %d iteraciones para N = %d ===\n", ITERACIONES, N);

    // Bucle para repetir la ejecucion del kernel 10 veces
    for (int it = 1; it <= ITERACIONES; it++) {
        struct timespec start, end;
        
        // 1. Inicio de medicion del kernel
        clock_gettime(CLOCK_MONOTONIC, &start);

        multiply_matrices(A, B, C, N);

        // 2. Fin de medicion del kernel
        clock_gettime(CLOCK_MONOTONIC, &end);

        double time_taken = (end.tv_sec - start.tv_sec) + 
                             (end.tv_nsec - start.tv_nsec) / 1e9;

        // Muestra el resultado de cada iteracion individualmente
        printf("Iteracion %2d: %f segundos\n", it, time_taken);
    }

    free(A);
    free(B);
    free(C);

    return EXIT_SUCCESS;
}
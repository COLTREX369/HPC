#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h> // Librería de OpenMP

void multiply_matrices_omp(int N, double **A, double **B_T, double **C) {
    // Paralelizamos el bucle externo distributing filas entre hilos de OpenMP
    #pragma omp parallel for collapse(1) schedule(static)
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            double sum = 0.0;
            for (int k = 0; k < N; k++) {
                // Acceso eficiente por filas gracias a B traspuesta (B_T)
                sum += A[i][k] * B_T[j][k];
            }
            C[i][j] = sum;
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Uso: %s <tamaño_matriz_N>\n", argv[0]);
        return 1;
    }

    int N = atoi(argv[1]);

    // Reserva dinámica de memoria
    double **A = (double **)malloc(N * sizeof(double *));
    double **B = (double **)malloc(N * sizeof(double *));
    double **B_T = (double **)malloc(N * sizeof(double *));
    double **C = (double **)malloc(N * sizeof(double *));

    for (int i = 0; i < N; i++) {
        A[i] = (double *)malloc(N * sizeof(double));
        B[i] = (double *)malloc(N * sizeof(double));
        B_T[i] = (double *)malloc(N * sizeof(double));
        C[i] = (double *)malloc(N * sizeof(double));
    }

    // Inicialización de matrices
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = (double)(i + j);
            B[i][j] = (double)(i - j);
        }
    }

    // Trasposición de la matriz B
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            B_T[j][i] = B[i][j];
        }
    }

    // Medición de tiempo con OpenMP
    double start_time = omp_get_wtime();

    multiply_matrices_omp(N, A, B_T, C);

    double end_time = omp_get_wtime();
    double execution_time = end_time - start_time;

    // Imprimir el tiempo (formato compatible con nuestro pipeline de benchmarking)
    printf("%f\n", execution_time);

    // Liberación de memoria
    for (int i = 0; i < N; i++) {
        free(A[i]);
        free(B[i]);
        free(B_T[i]);
        free(C[i]);
    }
    free(A); free(B); free(B_T); free(C);

    return 0;
}
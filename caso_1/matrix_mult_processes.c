#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/mman.h>

#define ITERACIONES 10

// Reserva de memoria compartida para que los procesos hijos escriban en C
int* allocate_shared_matrix(int n) {
    size_t size = (size_t)n * n * sizeof(int);
    int *matrix = (int*)mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    if (matrix == MAP_FAILED) {
        perror("Error en mmap");
        exit(EXIT_FAILURE);
    }
    return matrix;
}

void free_shared_matrix(int* matrix, int n) {
    munmap(matrix, (size_t)n * n * sizeof(int));
}

void fill_matrix(int* matrix, int n) {
    for (int i = 0; i < n * n; i++) {
        matrix[i] = (rand() % 10) + 1;
    }
}

void multiply_matrices_process(int pid, int num_processes, int N, int *A, int *B, int *C) {
    int chunk = N / num_processes;
    int start_row = pid * chunk;
    int end_row = (pid == num_processes - 1) ? N : start_row + chunk;

    for (int i = start_row; i < end_row; i++) {
        for (int j = 0; j < N; j++) {
            int suma_temporal = 0;
            for (int k = 0; k < N; k++) {
                suma_temporal += A[i * N + k] * B[k * N + j];
            }
            C[i * N + j] = suma_temporal;
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Uso: %s <tamano_matriz_N> <numero_procesos>\n", argv[0]);
        return EXIT_FAILURE;
    }

    int N = atoi(argv[1]);
    int NUM_PROCESSES = atoi(argv[2]);

    if (N <= 0 || NUM_PROCESSES <= 0) {
        fprintf(stderr, "Error: N y el numero de procesos deben ser positivos.\n");
        return EXIT_FAILURE;
    }

    srand(time(NULL));

    // Reserva de memoria compartida
    int *A = allocate_shared_matrix(N);
    int *B = allocate_shared_matrix(N);
    int *C = allocate_shared_matrix(N);

    fill_matrix(A, N);
    fill_matrix(B, N);

    printf("=== Benchmarking Procesos (fork + mmap): N = %d, Procesos = %d, Iteraciones = %d ===\n", N, NUM_PROCESSES, ITERACIONES);

    for (int it = 1; it <= ITERACIONES; it++) {
        struct timespec start, end;

        // Inicio de medición
        clock_gettime(CLOCK_MONOTONIC, &start);

        for (int p = 0; p < NUM_PROCESSES; p++) {
            pid_t pid = fork();
            if (pid == 0) {
                // Código del proceso hijo
                multiply_matrices_process(p, NUM_PROCESSES, N, A, B, C);
                exit(EXIT_SUCCESS);
            } else if (pid < 0) {
                perror("Error al crear proceso con fork");
                exit(EXIT_FAILURE);
            }
        }

        // El proceso padre espera a que todos los hijos terminen
        for (int p = 0; p < NUM_PROCESSES; p++) {
            wait(NULL);
        }

        // Fin de medición
        clock_gettime(CLOCK_MONOTONIC, &end);

        double time_taken = (end.tv_sec - start.tv_sec) + 
                             (end.tv_nsec - start.tv_nsec) / 1e9;

        printf("Iteracion %2d: %f segundos\n", it, time_taken);
    }

    free_shared_matrix(A, N);
    free_shared_matrix(B, N);
    free_shared_matrix(C, N);

    return EXIT_SUCCESS;
}
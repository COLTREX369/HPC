#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>

#define ITERACIONES 10

typedef struct {
    int thread_id;
    int num_threads;
    int N;
    int *A;
    int *B;
    int *C;
} ThreadData;

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

void* multiply_matrices_thread(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    int tid = data->thread_id;
    int num_threads = data->num_threads;
    int N = data->N;
    int *A = data->A;
    int *B = data->B;
    int *C = data->C;
    
    int chunk = N / num_threads;
    int start_row = tid * chunk;
    int end_row = (tid == num_threads - 1) ? N : start_row + chunk;
    
    for (int i = start_row; i < end_row; i++) {
        for (int j = 0; j < N; j++) {
            int suma_temporal = 0;
            for (int k = 0; k < N; k++) {
                suma_temporal += A[i * N + k] * B[k * N + j];
            }
            C[i * N + j] = suma_temporal;
        }
    }
    
    pthread_exit(NULL);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Uso: %s <tamano_matriz_N> <numero_hilos>\n", argv[0]);
        return EXIT_FAILURE;
    }

    int N = atoi(argv[1]);
    int NUM_THREADS = atoi(argv[2]);

    if (N <= 0 || NUM_THREADS <= 0) {
        fprintf(stderr, "Error: N y el numero de hilos deben ser positivos.\n");
        return EXIT_FAILURE;
    }

    srand(time(NULL));

    int *A = allocate_matrix(N);
    int *B = allocate_matrix(N);
    int *C = allocate_matrix(N);

    fill_matrix(A, N);
    fill_matrix(B, N);

    printf("=== Ejecutando %d iteraciones (Hilos: %d) para N = %d ===\n", ITERACIONES, NUM_THREADS, N);

    for (int it = 1; it <= ITERACIONES; it++) {
        pthread_t threads[NUM_THREADS];
        ThreadData thread_data[NUM_THREADS];
        struct timespec start, end;

        // Medicion del kernel paralelo en cada iteracion
        clock_gettime(CLOCK_MONOTONIC, &start);

        for (int i = 0; i < NUM_THREADS; i++) {
            thread_data[i].thread_id = i;
            thread_data[i].num_threads = NUM_THREADS;
            thread_data[i].N = N;
            thread_data[i].A = A;
            thread_data[i].B = B;
            thread_data[i].C = C;
            
            pthread_create(&threads[i], NULL, multiply_matrices_thread, (void*)&thread_data[i]);
        }

        for (int i = 0; i < NUM_THREADS; i++) {
            pthread_join(threads[i], NULL);
        }

        clock_gettime(CLOCK_MONOTONIC, &end);

        double time_taken = (end.tv_sec - start.tv_sec) + 
                             (end.tv_nsec - start.tv_nsec) / 1e9;

        printf("Iteracion %2d: %f segundos\n", it, time_taken);
    }

    free(A);
    free(B);
    free(C);

    return EXIT_SUCCESS;
}
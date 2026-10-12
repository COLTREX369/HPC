#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>

#define ITERACIONES 10

// Estructura para pasar argumentos a cada hilo
typedef struct {
    int thread_id;
    int num_threads;
    int N;
    int *A;
    int *B;
    int *C;
} ThreadData;

// Reserva dinámica de memoria en arreglo 1D continuo para localidad espacial
int* allocate_matrix(int n) {
    int *matrix = (int*)malloc((size_t)n * n * sizeof(int));
    if (matrix == NULL) {
        fprintf(stderr, "Error: No se pudo reservar memoria.\n");
        exit(EXIT_FAILURE);
    }
    return matrix;
}

// Inicialización con enteros acotados (1 a 10) para evitar desbordamientos
void fill_matrix(int* matrix, int n) {
    for (int i = 0; i < n * n; i++) {
        matrix[i] = (rand() % 10) + 1; 
    }
}

// Función ejecutada por cada hilo (Kernel paralelo)
void* multiply_matrices_thread(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    int tid = data->thread_id;
    int num_threads = data->num_threads;
    int N = data->N;
    int *A = data->A;
    int *B = data->B;
    int *C = data->C;
    
    // División del trabajo por filas (Chunking)
    int chunk = N / num_threads;
    int start_row = tid * chunk;
    int end_row = (tid == num_threads - 1) ? N : start_row + chunk; // Manejo del residuo
    
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
    // 1. Lectura de parámetros desde la terminal
    if (argc != 3) {
        fprintf(stderr, "Uso: %s <tamano_matriz_N> <numero_hilos>\n", argv[0]);
        return EXIT_FAILURE;
    }

    int N = atoi(argv[1]);
    int NUM_THREADS = atoi(argv[2]);

    if (N <= 0 || NUM_THREADS <= 0) {
        fprintf(stderr, "Error: El tamaño N y el número de hilos deben ser enteros positivos.\n");
        return EXIT_FAILURE;
    }

    srand(time(NULL));

    // 2. Reserva e inicialización de matrices
    int *A = allocate_matrix(N);
    int *B = allocate_matrix(N);
    int *C = allocate_matrix(N);

    fill_matrix(A, N);
    fill_matrix(B, N);

    printf("=== Benchmarking Hilos (pthreads): N = %d, Hilos = %d, Iteraciones = %d ===\n", N, NUM_THREADS, ITERACIONES);

    // 3. Muestreo estadístico (Bucle de 10 iteraciones)
    for (int it = 1; it <= ITERACIONES; it++) {
        pthread_t threads[NUM_THREADS];
        ThreadData thread_data[NUM_THREADS];
        struct timespec start, end;

        // Medición exclusiva del Kernel paralelo (Inicio)
        clock_gettime(CLOCK_MONOTONIC, &start);

        // Creación de hilos
        for (int i = 0; i < NUM_THREADS; i++) {
            thread_data[i].thread_id = i;
            thread_data[i].num_threads = NUM_THREADS;
            thread_data[i].N = N;
            thread_data[i].A = A;
            thread_data[i].B = B;
            thread_data[i].C = C;
            
            pthread_create(&threads[i], NULL, multiply_matrices_thread, (void*)&thread_data[i]);
        }

        // Sincronización (esperar a que todos los hilos terminen)
        for (int i = 0; i < NUM_THREADS; i++) {
            pthread_join(threads[i], NULL);
        }

        // Medición exclusiva del Kernel paralelo (Fin)
        clock_gettime(CLOCK_MONOTONIC, &end);

        double time_taken = (end.tv_sec - start.tv_sec) + 
                             (end.tv_nsec - start.tv_nsec) / 1e9;

        printf("Iteracion %2d: %f segundos\n", it, time_taken);
    }

    // 4. Liberación de memoria
    free(A);
    free(B);
    free(C);

    return EXIT_SUCCESS;
}
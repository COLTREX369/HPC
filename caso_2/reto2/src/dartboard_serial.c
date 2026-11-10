#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[]) {
    long long N = (argc > 1) ? atoll(argv[1]) : 100000000LL;
    long long dentro = 0;
    unsigned int seed = 54321;

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    for (long long i = 0; i < N; i++) {
        double x = ((double)rand_r(&seed) / RAND_MAX) * 2.0 - 1.0;
        double y = ((double)rand_r(&seed) / RAND_MAX) * 2.0 - 1.0;
        if (x * x + y * y <= 1.0) {
            dentro++;
        }
    }

    clock_gettime(CLOCK_MONOTONIC, &end);
    double tiempo = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    printf("%.6f\n", tiempo);
    return 0;
}
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define M_PI 3.14159265358979323846

int main(int argc, char *argv[]) {
    long long N = (argc > 1) ? atoll(argv[1]) : 100000000LL;
    double L = 1.0, D = 1.0;
    long long cruces = 0;
    unsigned int seed = 12345;

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    for (long long i = 0; i < N; i++) {
        double x = ((double)rand_r(&seed) / RAND_MAX) * (D / 2.0);
        double theta = ((double)rand_r(&seed) / RAND_MAX) * (M_PI / 2.0);
        if (x <= (L / 2.0) * sin(theta)) {
            cruces++;
        }
    }

    clock_gettime(CLOCK_MONOTONIC, &end);
    double tiempo = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    printf("%.6f\n", tiempo);
    return 0;
}
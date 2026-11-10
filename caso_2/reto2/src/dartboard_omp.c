#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>

int main(int argc, char *argv[]) {
    long long N = (argc > 1) ? atoll(argv[1]) : 100000000LL;
    long long dentro_totales = 0;

    double t_start = omp_get_wtime();

    #pragma omp parallel reduction(+:dentro_totales)
    {
        int tid = omp_get_thread_num();
        unsigned int seed = (unsigned int)time(NULL) + tid * 17;
        long long dentro_locales = 0;

        #pragma omp for schedule(static)
        for (long long i = 0; i < N; i++) {
            double x = ((double)rand_r(&seed) / RAND_MAX) * 2.0 - 1.0;
            double y = ((double)rand_r(&seed) / RAND_MAX) * 2.0 - 1.0;
            if (x * x + y * y <= 1.0) {
                dentro_locales++;
            }
        }
        dentro_totales += dentro_locales;
    }

    double t_end = omp_get_wtime();
    printf("%.6f\n", t_end - t_start);
    return 0;
}
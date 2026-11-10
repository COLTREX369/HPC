#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>
#include <time.h>

#define M_PI 3.14159265358979323846

int main(int argc, char *argv[]) {
    long long N = (argc > 1) ? atoll(argv[1]) : 100000000LL;
    double L = 1.0, D = 1.0;
    long long cruces_totales = 0;

    double t_start = omp_get_wtime();

    #pragma omp parallel reduction(+:cruces_totales)
    {
        int tid = omp_get_thread_num();
        unsigned int seed = (unsigned int)time(NULL) + tid * 31;
        long long cruces_locales = 0;

        #pragma omp for schedule(static)
        for (long long i = 0; i < N; i++) {
            double x = ((double)rand_r(&seed) / RAND_MAX) * (D / 2.0);
            double theta = ((double)rand_r(&seed) / RAND_MAX) * (M_PI / 2.0);
            if (x <= (L / 2.0) * sin(theta)) {
                cruces_locales++;
            }
        }
        cruces_totales += cruces_locales;
    }

    double t_end = omp_get_wtime();
    printf("%.6f\n", t_end - t_start);
    return 0;
}
CC = gcc
CFLAGS = -O3 -fopenmp -Wall
TARGET = matrix_omp

all: $(TARGET)

$(TARGET): matrix_omp.c
	$(CC) $(CFLAGS) matrix_omp.c -o $(TARGET)

clean:
	rm -f $(TARGET) *.csv
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// include SSE intrinsics
#if defined(_MSC_VER)
#include <intrin.h>
#elif defined(__GNUC__) && (defined(__x86_64__) || defined(__i386__))
#include <x86intrin.h>
#endif

#define CLOCK_RATE_GHZ 2.26e9

static __inline__ uint64_t RDTSC()
{
	uint32_t hi, lo;
	__asm__ volatile(
		"rdtsc"
		: "=a"(lo), "=d"(hi));
	return (((uint64_t)hi) << 32) | ((uint64_t)lo);
}

static int sum_naive(int n, int *a)
{
	int sum = 0;
	for (int i = 0; i < n; i++)
	{
		sum += a[i];
	}
	return sum;
}

static int sum_unrolled(int n, int *a)
{
	// UNROLL YOUR VECTORIZED CODE HERE
	int sum = 0;

	// unrolled loop
	for (int i = 0; i < n / 4 * 4; i += 4)
	{
		sum += a[i + 0];
		sum += a[i + 1];
		sum += a[i + 2];
		sum += a[i + 3];
	}

	// tail case
	for (int i = n / 4 * 4; i < n; i++)
	{
		sum += a[i];
	}

	return sum;
}

static int sum_vectorized(int n, int *a)
{
	// WRITE YOUR VECTORIZED CODE HERE
	__m256i res = _mm256_setzero_si256();
	for (int i = 0; i < n / 8 * 8; i += 8)
	{
		res = _mm256_add_epi32(res, _mm256_loadu_si256(a + i));
	}
	int RES[8];
	_mm256_storeu_si256(RES, res);

	int sum=0;
	for(int i=0;i<8;i++){
		sum+=RES[i];
	}

	for (int i = n / 8 * 8; i < n; i++)
	{
		sum += a[i];
	}

	return sum;
}

static int sum_vectorized_unrolled(int n, int *a)
{
	// unrolled loop
	__m256i sum_vec = _mm256_setzero_si256();
	for (int i = 0; i < n / 32 * 32; i += 32)
	{
		__m256i tmp1 = _mm256_add_epi32(_mm256_loadu_si256(a + i), _mm256_loadu_si256(a + i + 8));
		__m256i tmp2 = _mm256_add_epi32(_mm256_loadu_si256(a + i + 16), _mm256_loadu_si256(a + i + 24));
		sum_vec = _mm256_add_epi32(sum_vec, tmp1);
		sum_vec = _mm256_add_epi32(sum_vec, tmp2);
	}
	int RES[8];
	_mm256_storeu_si256(RES, sum_vec);
	int sum=0;
	for(int i=0;i<8;i++){
		sum+=RES[i];
	}


	// tail case
	for (int i = n / 32 * 32; i < n; i++)
	{
		sum += a[i];
	}

	return sum;
}

void benchmark(int n, int *a, int (*computeSum)(int, int *), char *name)
{
	// warm up cache
	int sum = computeSum(n, a);

	// measure
	uint64_t beginCycle = RDTSC();
	sum += computeSum(n, a);
	uint64_t cycles = RDTSC() - beginCycle;

	double microseconds = cycles / CLOCK_RATE_GHZ * 1e6;

	// print results
	printf("%20s: ", name);
	if (sum == 2 * sum_naive(n, a))
	{
		printf("%.2f microseconds\n", microseconds);
	}
	else
	{
		printf("ERROR!\n");
	}
}

int main(int argc, char **argv)
{
	const int n = 9999;

	// initialize the array with random values
	srand48(time(NULL));
	int a[n] __attribute__((aligned(16)));
	for (int i = 0; i < n; i++)
	{
		a[i] = lrand48();
	}

	// benchmark series of codes
	benchmark(n, a, sum_naive, "naive");
	benchmark(n, a, sum_unrolled, "unrolled");
	benchmark(n, a, sum_vectorized, "vectorized");
	benchmark(n, a, sum_vectorized_unrolled, "vectorized unrolled");

	return 0;
}

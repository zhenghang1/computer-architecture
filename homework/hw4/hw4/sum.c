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
	__m128i res = _mm_setzero_si128();
	for (int i = 0; i < n / 4 * 4; i += 4)
	{
		res = _mm_add_epi32(res, _mm_loadu_si128(a + i));
	}
	int RES[4];
	_mm_storeu_si128(RES, res);

	int sum = RES[0] + RES[1] + RES[2] + RES[3];

	for (int i = n / 4 * 4; i < n; i++)
	{
		sum += a[i];
	}

	return sum;
}

static int sum_vectorized_unrolled(int n, int *a)
{
	// unrolled loop
	__m128i sum_vec = _mm_setzero_si128();
	for (int i = 0; i < n / 16 * 16; i += 16)
	{
		__m128i tmp1 = _mm_add_epi32(_mm_loadu_si128(a + i), _mm_loadu_si128(a + i + 4));
		__m128i tmp2 = _mm_add_epi32(_mm_loadu_si128(a + i + 8), _mm_loadu_si128(a + i + 12));
		sum_vec = _mm_add_epi32(sum_vec, tmp1);
		sum_vec = _mm_add_epi32(sum_vec, tmp2);
	}
	int RES[4];
	_mm_storeu_si128(RES, sum_vec);
	int sum = RES[0] + RES[1] + RES[2] + RES[3];

	// tail case
	for (int i = n / 16 * 16; i < n; i++)
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

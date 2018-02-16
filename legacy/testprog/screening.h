#pragma once
#include <CInt.h>

#define TOLSRC 1e-10

void schwartz_screening (BasisSet_t basis, int **shellptr, int **shellid, int **shellrid, double **shellvalue, int *nnz);

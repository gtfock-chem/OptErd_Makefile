#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>
#include <string.h>
#include <assert.h>

#include "screening.h"


void schwartz_screening(BasisSet_t basis, int **shellptrOut,
    int **shellidOut, int **shellridOut,
    double **shellvalueOut, int *nnzOut)
{
    ERD_t erd;
    CInt_createERD(basis, &erd, 1);
    const int nshells = CInt_getNumShells(basis);

    double *vpairs = (double *)malloc(sizeof(double) * nshells * nshells);
    assert(vpairs != NULL);

    double allmax = 0.0;
    for (int M = 0; M < nshells; M++) {
        const int dimM = CInt_getShellDim(basis, M);
        for (int N = 0; N < nshells; N++) {
            const int dimN = CInt_getShellDim(basis, N);

            int nints;
            double *integrals;
            CInt_computeShellQuartet(basis, erd, 0, M, N, M, N, &integrals, &nints);

            double mvalue = 0.0;
            if (nints != 0) {
                for (int iM = 0; iM < dimM; iM++) {
                    for (int iN = 0; iN < dimN; iN++) {
                        const int index = iM * (dimN*dimM*dimN+dimN) + iN * (dimM*dimN+1);
                        if (mvalue < fabs(integrals[index])) {
                            mvalue = fabs(integrals[index]);
                        }
                    }
                }
            }
            vpairs[M * nshells + N] = mvalue;
            if (mvalue > allmax) {
                allmax = mvalue;
            }
        }
    }

    // init shellptr
    int nnz = 0;
    const double eta = TOLSRC*TOLSRC / allmax;
    int *shellptr = (int *)malloc(sizeof(int) * (nshells + 1));
    assert(shellptr != NULL);
    memset(shellptr, 0, sizeof(int) * (nshells + 1));
    for (int M = 0; M < nshells; M++) {
        for (int N = 0; N < nshells; N++) {
            double mvalue = vpairs[M * nshells  + N];
            if (mvalue > eta) {
                nnz++;
            }
        }
        shellptr[M + 1] = nnz;
    }

    double *shellvalue  = (double *)malloc(sizeof(double) * nnz);
    int *shellid  = (int *)malloc(sizeof(int) * nnz);
    int *shellrid  = (int *)malloc(sizeof(int) * nnz);
    assert((shellvalue != NULL) &&
           (shellid != NULL) &&
           (shellrid != NULL));
    nnz = 0;
    for (int M = 0; M < nshells; M++) {
        for (int N = 0; N < nshells; N++) {
            const double mvalue = vpairs[M * nshells  + N];
            if (mvalue > eta) {
                shellvalue[nnz] = mvalue;
                shellid[nnz] = N;
                shellrid[nnz] = M;
                nnz++;
            }
        }
    }
    *nnzOut = nnz;
    free(vpairs);
    CInt_destroyERD(erd);

    *shellidOut = shellid;
    *shellridOut = shellrid;
    *shellptrOut = shellptr;
    *shellvalueOut = shellvalue;
}

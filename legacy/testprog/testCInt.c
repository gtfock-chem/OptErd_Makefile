#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <math.h>
#include <sys/time.h>

#include <screening.h>


int main (int argc, char **argv)
{
    BasisSet_t basis;
    ERD_t erd;
    int M;
    int N;
    int P;
    int Q;
    int nints;
    int ns;
    int nnz;
    double totalcalls = 0;
    double *integrals;
    int *shellptr;
    int *shellid;
    int *shellrid;
    double *shellvalue;
    struct timeval tv1;
    struct timeval tv2;
    double timepass;   
    double totalintls = 0;

    if (argc != 3)
    {
        printf ("Usage: %s <basisset> <xyz>\n", argv[0]);
        return 0;
    }
    FILE *ref_data_file = fopen ("ivalues.ref", "w+");
    if (ref_data_file == NULL)
    {
        fprintf (stderr, "failed to open ivalues.ref\n");
        exit (0);
    }
    int errcount; 
    errcount = 0;
    // load basis set   
    CInt_createBasisSet (&basis);
    CInt_loadBasisSet (basis, argv[1], argv[2]);
    schwartz_screening (basis, &shellptr, &shellid, &shellrid, &shellvalue, &nnz);

    printf ("Molecule info:\n");
    printf ("  #Atoms\t= %d\n", CInt_getNumAtoms (basis));
    printf ("  #Shells\t= %d\n", CInt_getNumShells (basis));
    printf ("  #Funcs\t= %d\n", CInt_getNumFuncs (basis));
    printf ("  #OccOrb\t= %d\n", CInt_getNumOccOrb (basis));

    // compute intergrals
    CInt_createERD (basis, &erd);
    //printf ("max memory footprint per thread = %lf KB\n",
    //    CInt_getMaxMemory (erd)/1024.0);   

    printf ("Computing integrals ...\n");
    ns = CInt_getNumShells (basis);
    timepass = 0.0;
    int start2;
    int end2;
    double value1;
    double value2;

    for (int M = 0; M < ns; M++) {
        const int start1 = shellptr[M];
        const int end1 = shellptr[M + 1];       
        for (int P = 0; P < ns; P++) {
            const int start2 = shellptr[P];
            const int end2 = shellptr[P + 1];              
            for (int i = start1; i < end1; i++) {
                const int N = shellid[i];
                const double value1 = shellvalue[i];
                for (int j = start2; j < end2; j++) {
                    const int Q = shellid[j];
                    const double value2 = shellvalue[j];
                    if (M > N || P > Q || (M + N) > (P + Q))
                        continue;
                    if (fabs(value1 * value2) < TOLSRC * TOLSRC)
                        continue;                        
                    totalcalls = totalcalls + 1;
                    gettimeofday (&tv1, NULL);
                    CInt_computeShellQuartet (basis, erd, M, N, P, Q,
                                              &integrals, &nints);

                    gettimeofday (&tv2, NULL);
                    timepass += (tv2.tv_sec - tv1.tv_sec) +
                        (tv2.tv_usec - tv1.tv_usec) / 1000.0 / 1000.0;
                    totalintls = totalintls + nints;
                    
                    fwrite (&nints, sizeof(int), 1, ref_data_file);
                    if (nints != 0) {
                        fwrite (integrals, sizeof(double), nints, ref_data_file);
                    }

                    if (errcount > 10) {
                        goto end;
                    }
                } /* for (j = start2; j < end2; j++) */
            } /* for (P = 0; P < ns; P++) */
        } /* for (i = start1; i < end1; i++) */
    } /* for (M = 0; M < ns; M++) */
    
    printf ("Done\n");
    printf ("\n");
    printf ("Number of calls: %.6le, Number of integrals: %.6le\n",
            totalcalls, totalintls);
    printf ("Total time: %.4lf secs\n", timepass);
    printf ("Average time per call: %.3le us\n",
            1000.0 * 1000.0 * timepass / totalcalls);

end:
    CInt_destroyERD (erd);
    CInt_destroyBasisSet (basis);
    free (shellptr);
    free (shellid);
    free (shellvalue);
    free (shellrid);
    
    fclose (ref_data_file);
    return 0;
}

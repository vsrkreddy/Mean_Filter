#include <libmap.h>

#define REF(_A,_i,_j) (_A[(_i)*n_cols+(_j)])

void subr (uint8_t input_image[], uint8_t output_image[], uint n_rows, uint n_cols, uint n_bytes, int64_t *time, uint mapnum) {

    OBM_BANK_A (AL, int64_t, MAX_OBM_SIZE)
    OBM_BANK_B (BL, int64_t, MAX_OBM_SIZE)
    Stream_64 SA,SB;

    int64_t t0, t1;
    int i,j;
    int64_t a00,a01,a02,a10,a11,a12,a20,a21,a22, sum;
    
    buffered_dma_cpu (CM2OBM, PATH_0, AL, MAP_OBM_stripe (1,"A"), input_image, 1, n_bytes);

    read_timer (&t0);

    


      for (i=0; i<n_rows; i++) {
      for (j=0; j<n_cols; j++) {
     		a00 = REF(AL,i,j);
			a01 = REF(AL,i,j+1);
			a02 = REF(AL,i,j+2);
			
			a10 = REF(AL,i+1,j);
			a11 = REF(AL,i+1,j+1);
			a12 = REF(AL,i+1,j+2);
			
			a20 = REF(AL,i+2,j);
			a21 = REF(AL,i+2,j+1);
			a22 = REF(AL,i+2,j+2);
			
			sum = a00 + a01 + a02 + a10 + a11 + a12 + a20 + a21 + a22; 
			REF (BL, i, j) = sum/9;
 
	}
	
}
     read_timer (&t1);
    *time = t1 - t0;

    buffered_dma_cpu (OBM2CM, PATH_0, BL, MAP_OBM_stripe (1,"B"), output_image, 1, n_bytes);
}


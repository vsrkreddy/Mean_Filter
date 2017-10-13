#include <libmap.h>

#define REF(_A,_i,_j) (_A[(_i)*n_cols+(_j)])

void subr (uint8_t input_image[], uint8_t output_image[], uint n_rows, uint n_cols, uint n_bytes, int64_t *time, uint mapnum) {

    OBM_BANK_A (AL, int64_t, MAX_OBM_SIZE)
    OBM_BANK_B (BL, int64_t, MAX_OBM_SIZE)
    Stream_64 SA,SB;

    int64_t t0, t1;
    int i,j,n;
    int64_t a00,a01,a02,a10,a11,a12,a20,a21,a22, sum,mean;
    
   buffered_dma_cpu(CM2OBM, PATH_0, AL, MAP_OBM_stripe(1,"A"), input_image, 1,n_bytes);

    read_timer (&t0);

    


     for(i=0;i<n_rows;i++){
	 for(j=0;j<n_cols;j++){

     		mean = REF(AL, i, j);
			a20 = a21;
			a21 = a22;
			a22 = mean;
			a10 = a11;
			a11 = a12;
			delay_queue_8_var (a22, 1, (i==0)&&(j==0), n_rows, &a12);
			a00 = a01;
			a11 = a02;
			delay_queue_8_var (a12, 1, (i==0)&&(j==0), n_rows, &a02);
			
			REF (BL, i, j) = (a00 + a01 + a02 + a10 + a11 + a12 + a20 + a21 + a22)/9; 
			 
 
	}
	}
	

     read_timer (&t1);
    *time = t1 - t0;
    buffered_dma_cpu(OBM2CM, PATH_0, BL, MAP_OBM_stripe(1,"B"), output_image, 1,n_bytes);

}


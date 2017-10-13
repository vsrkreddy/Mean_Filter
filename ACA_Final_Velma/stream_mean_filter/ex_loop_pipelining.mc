#include <libmap.h>

#define REF(_A,_i,_j) (_A[(_i)*n_cols+(_j)])

void subr (uint8_t input_image[], uint8_t output_image[], uint n_rows, uint n_cols, uint n_bytes, int64_t *time, uint mapnum) {

   
   
    Stream_64 SA,SB;

    int64_t t0, t1;
  
    int64_t a00,a01,a02,a10,a11,a12,a20,a21,a22, sum;
    


    read_timer (&t0);

   

    #pragma src parallel sections
	{
		#pragma src section
		{
		streamed_dma_cpu_64 (&SA, PORT_TO_STREAM, input_image, (n_bytes)*sizeof(uint8_t));
		}
		#pragma src section
		{
		int i;
		
		int64_t data;
		
		
	      
	      for(i=0;i<n_bytes;i++){
	       get_stream_64 (&SA, &data);
			a20 = a21;
			a21 = a22;
			a22 = data;
			a10 = a11;
			a11 = a12;
			delay_queue_8_var (a22, 1, (i==0), 1024, &a12);
			a00 = a01;
			a11 = a02;
			delay_queue_8_var (a12, 1, (i==0), 1024, &a02);
			sum = (a00 + a01 + a02 + a10 + a11 + a12 + a20 + a21 + a22)/9; 
			put_stream_64(&SB, ~sum, 1);
	   
		}
	
		}
		#pragma src section
		{
		streamed_dma_cpu_64 (&SB, STREAM_TO_PORT, output_image, (n_bytes)*sizeof(uint8_t));
		}
	}
	read_timer (&t1);
        *time = t1 - t0;
   
}


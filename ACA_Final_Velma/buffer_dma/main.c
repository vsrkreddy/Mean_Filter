#include <libmap.h>
#include <time.h>
#include <stdlib.h>

void read_image (char *filename);
void write_image (uint8_t *X, char *name);
void cpu_compute (char *name);
void subr (uint8_t input_image[], uint8_t output_image[], uint n_rows, uint n_cols, uint n_bytes, int64_t *time, uint mapnum);

#define REF(_A,_i,_j) ((_A)[(_i)*n_cols+(_j)])

uint n_cols, n_rows, n_bytes;
uint8_t *A=NULL, *B=NULL;

int main (int argc, char *argv[]) {
    
    int64_t time;
    clock_t clock_start;
    clock_t clock_end;
    double clock_diff;

    if (argc < 2) {
        fprintf (stderr, "need image file source as arg\n");
		exit (1);
	}

	/*** Insert Your Code Here ***/
        read_image(argv[1]);
        clock_start = clock();
	
        cpu_compute(NULL);
        clock_end = clock();
	

        clock_diff = (double)(clock_end - clock_start) * 1000 / CLOCKS_PER_SEC;
        printf("CPU: %f\n", clock_diff);
        write_image(NULL, "res_cpu.pgm");

        map_allocate (1);
         clock_start = clock();
	 
        subr(A, B, n_rows, n_cols, n_bytes, &time, 0);
         clock_end = clock();
	 

        clock_diff = (double)(clock_end - clock_start) * 1000 / CLOCKS_PER_SEC;
        printf("MAP: %f\n", clock_diff);
        write_image(NULL, "res_map.pgm");

	/*****************************/

	printf ("%lld clocks\n", time);

    exit (0);
}

void read_image (char *filename) {
    FILE *fp;
    char str[1024];
    int mx;

    if ((fp = fopen (filename, "r")) == NULL) {
        fprintf (stderr, "couldn't open image file\n");
        exit (1);
    }
    fscanf (fp, "%s", str);
    if (strcmp ("P2", str) != 0) {
        fprintf (stderr, "image format error; must be a 'P2' pgm file\n");
        exit (1);
    }
    fscanf (fp, "%d %d", &n_cols, &n_rows);
    fscanf (fp, "%d", &mx);
    printf ("image size is %dx%d\n", n_rows, n_cols);

	/*** Insert Your Code Here ***/

        A = (uint8_t *)Cache_Aligned_Allocate (n_rows*n_cols* sizeof(uint8_t));
        B = (uint8_t *)Cache_Aligned_Allocate (n_rows*n_cols* sizeof(uint8_t));

        unsigned int i;
        unsigned int j;

        for (i = 0; i < n_rows; i++){
                for (j = 0; j<n_cols; j++){
                  fscanf(fp,"%d",&A[i*n_cols+j]);
			}
	}

}

void cpu_compute (char *name) {

	/*** Insert Your Code Here ***/

        
			
        int i,j, sum,a00,a01,a02,a10,a11,a12,a20,a21,a22;
        
        for (i = 0; i < n_rows; i++){
                for (j = 0; j < n_cols; j++){
			a00 = REF(A,i,j);
			a01 = REF(A,i,j+1);
			a02 = REF(A,i,j+2);
			
			a10 = REF(A,i+1,j);
			a11 = REF(A,i+1,j+1);
			a12 = REF(A,i+1,j+2);
			
			a20 = REF(A,i+2,j);
			a21 = REF(A,i+2,j+1);
			a22 = REF(A,i+2,j+2);
			
			sum = a00 + a01 + a02 + a10 + a11 + a12 + a20 + a21 + a22; 
			REF (B, i, j) = sum/9;
                

                }
        }


	/*****************************/
}

void write_image (uint8_t *X, char *name) {
    FILE *fp;
    uint8_t v0;
    int i, j;

    if ((fp = fopen (name, "w")) == NULL) {
        fprintf (stderr, "couldn't open file '%s'\n", name);
        exit (1);
    }
    fprintf (fp, "P2\n");
    fprintf (fp, "%d %d\n", n_cols, n_rows);
    fprintf (fp, "255\n");

	/*** Insert Your Code Here ***/

        for (i = 0; i < n_rows; i++){
                for (j = 0; j<n_cols; j++){
                  fprintf(fp,"%d ",B[i*n_cols+j]);
		//	printf("%d ", B[i*n_cols+j]);
                }
        }


	/*****************************/
}





















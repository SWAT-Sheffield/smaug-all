#include "cudapars.h"
#include "paramssteeringtest1.h"

/////////////////////////////////////
// standard imports
/////////////////////////////////////
#include <stdio.h>
#include <math.h>
#include "step.h"

/////////////////////////////////////
// kernel function (CUDA device)
/////////////////////////////////////
#include "gradops_hdb1.cuh"






__global__ void hyperdifbsource4_parallel(struct params *p,  real *wmod, 
    real *dwn1, real *wd, int order,int ordero, real *wtemp, int field, int dim, int jj, int ii0,int mm,real sb,real dt)
{

  int iindex = blockIdx.x * blockDim.x + threadIdx.x;
  int i,j;
  int m,ii1;
  real fip,fim1,tmpc;
  int index,k;
  int ni=p->n[0];
  int nj=p->n[1];

  //real dt=p->dt;
  real dy=p->dx[1];
  real dx=p->dx[0];

  int ip,jp,ipg,jpg;
  int iia[NDIM];
  int dimp=((p->n[0]))*((p->n[1]));
 #ifdef USE_SAC_3D
   int kp,kpg;
   real dz=p->dx[2];
   dimp=((p->n[0]))*((p->n[1]))*((p->n[2]));
#endif  

  #ifdef USE_SAC_3D
   kp=iindex/(nj*ni/((p->npgp[1])*(p->npgp[0])));
   jp=(iindex-(kp*(nj*ni/((p->npgp[1])*(p->npgp[0])))))/(ni/(p->npgp[0]));
   ip=iindex-(kp*nj*ni/((p->npgp[1])*(p->npgp[0])))-(jp*(ni/(p->npgp[0])));
#endif
 #if defined USE_SAC || defined ADIABHYDRO
    jp=iindex/(ni/(p->npgp[0]));
   ip=iindex-(jp*(ni/(p->npgp[0])));
#endif  
#ifdef USE_SAC_3D
  real rdx=(((p->dx[0])*(dim==0))+(p->dx[1])*(dim==1)+(p->dx[2])*(dim==2));
#else
  real rdx=(((p->dx[0])*(dim==0))+  (p->dx[1])*(dim==1)  );
#endif

int shift=order*NVAR*dimp;
   
   for(ipg=0;ipg<(p->npgp[0]);ipg++)
   for(jpg=0;jpg<(p->npgp[1]);jpg++)
   #ifdef USE_SAC_3D
     for(kpg=0;kpg<(p->npgp[2]);kpg++)
   #endif
   {

     iia[0]=ip*(p->npgp[0])+ipg;
     iia[1]=jp*(p->npgp[1])+jpg;
     i=iia[0];
     j=iia[1];
     k=0;
     #ifdef USE_SAC_3D
	   iia[2]=kp*(p->npgp[2])+kpg;
           k=iia[2];
     #endif

     #ifdef USE_SAC_3D
     if(i<((p->n[0])) && j<((p->n[1])) && k<((p->n[2])))
     #else
    if(i<((p->n[0])) && j<((p->n[1])))
     #endif

                         {
                              //                                                                                  - sign here same as vac maybe a +
                              wmod[fencode3_hdb1(p,iia,b1+ii0)+(ordero*NVAR*dimp)]=wmod[fencode3_hdb1(p,iia,b1+ii0)+(ordero*NVAR*dimp)]+dt*dwn1[fencode3_hdb1(p,iia,b1+field)]; 
                             wmod[fencode3_hdb1(p,iia,energy)+(ordero*NVAR*dimp)]=wmod[fencode3_hdb1(p,iia,energy)+(ordero*NVAR*dimp)]+dt*dwn1[fencode3_hdb1(p,iia,energy)]; 

                         }
              //  }	
}
  __syncthreads();  
}




__global__ void hyperdifbsource3_parallel(struct params *p, real *wmod, 
    real *dwn1, real *wd, int order,int ordero, real *wtemp, int field, int dim, int jj, int ii0,int mm,real sb,real dt)
{
 
  int iindex = blockIdx.x * blockDim.x + threadIdx.x;
  int i,j;
  int m,ii1;
  real fip,fim1,tmpc;
  int index,k;
  int ni=p->n[0];
  int nj=p->n[1];

   real dy=p->dx[1];
  real dx=p->dx[0];

  int ip,jp,ipg,jpg;
  int iia[NDIM];
  int dimp=((p->n[0]))*((p->n[1]));
 #ifdef USE_SAC_3D
   int kp,kpg;
   real dz=p->dx[2];
   dimp=((p->n[0]))*((p->n[1]))*((p->n[2]));
#endif  

  #ifdef USE_SAC_3D
   kp=iindex/(nj*ni/((p->npgp[1])*(p->npgp[0])));
   jp=(iindex-(kp*(nj*ni/((p->npgp[1])*(p->npgp[0])))))/(ni/(p->npgp[0]));
   ip=iindex-(kp*nj*ni/((p->npgp[1])*(p->npgp[0])))-(jp*(ni/(p->npgp[0])));
#endif
 #if defined USE_SAC || defined ADIABHYDRO
    jp=iindex/(ni/(p->npgp[0]));
   ip=iindex-(jp*(ni/(p->npgp[0])));
#endif  
#ifdef USE_SAC_3D
  real rdx=(((p->dx[0])*(dim==0))+(p->dx[1])*(dim==1)+(p->dx[2])*(dim==2));
#else
  real rdx=(((p->dx[0])*(dim==0))+  (p->dx[1])*(dim==1)  );
#endif

int shift=order*NVAR*dimp;

   
   for(ipg=0;ipg<(p->npgp[0]);ipg++)
   for(jpg=0;jpg<(p->npgp[1]);jpg++)
   #ifdef USE_SAC_3D
     for(kpg=0;kpg<(p->npgp[2]);kpg++)
   #endif
   {

     iia[0]=ip*(p->npgp[0])+ipg;
     iia[1]=jp*(p->npgp[1])+jpg;
     i=iia[0];
     j=iia[1];
     k=0;
     #ifdef USE_SAC_3D
	   iia[2]=kp*(p->npgp[2])+kpg;
           k=iia[2];
     #endif

     #ifdef USE_SAC_3D
     if(i<((p->n[0])) && j<((p->n[1])) && k<((p->n[2])))
     #else
    if(i<((p->n[0])) && j<((p->n[1])))
     #endif
	{		               



dwn1[fencode3_hdb1(p,iia,b1+ii0)]=sb*(wtemp[fencode3_hdb1(p,iia,tmp5)]*wd[fencode3_hdb1(p,iia,hdnur)]-wtemp[fencode3_hdb1(p,iia,tmp4)]*wd[fencode3_hdb1(p,iia,hdnul)])/rdx;

dwn1[fencode3_hdb1(p,iia,energy)]=sb*(wtemp[fencode3_hdb1(p,iia,tmp3)]*wtemp[fencode3_hdb1(p,iia,tmp5)]*wd[fencode3_hdb1(p,iia,hdnur)]-wtemp[fencode3_hdb1(p,iia,tmp2)]*wtemp[fencode3_hdb1(p,iia,tmp4)]*wd[fencode3_hdb1(p,iia,hdnul)])/rdx;


   }
}
 __syncthreads();


 
}






__global__ void hyperdifbsource2_parallel(struct params *p,  real *wmod, 
    real *dwn1, real *wd, int order,int ordero, real *wtemp, int field, int dim, int jj, int ii0,int mm,real sb)
{

  int iindex = blockIdx.x * blockDim.x + threadIdx.x;
  int i,j;
  int m,ii1;
  real fip,fim1,tmpc;
  int index,k;
  int ni=p->n[0];
  int nj=p->n[1];

  real dt=p->dt;
  real dy=p->dx[1];
  real dx=p->dx[0];

  int ip,jp,ipg,jpg;
  int iia[NDIM];
  int dimp=((p->n[0]))*((p->n[1]));
 #ifdef USE_SAC_3D
   int kp,kpg;
   real dz=p->dx[2];
   dimp=((p->n[0]))*((p->n[1]))*((p->n[2]));
#endif  

  #ifdef USE_SAC_3D
   kp=iindex/(nj*ni/((p->npgp[1])*(p->npgp[0])));
   jp=(iindex-(kp*(nj*ni/((p->npgp[1])*(p->npgp[0])))))/(ni/(p->npgp[0]));
   ip=iindex-(kp*nj*ni/((p->npgp[1])*(p->npgp[0])))-(jp*(ni/(p->npgp[0])));
#endif
 #if defined USE_SAC || defined ADIABHYDRO
    jp=iindex/(ni/(p->npgp[0]));
   ip=iindex-(jp*(ni/(p->npgp[0])));
#endif  


int shift=order*NVAR*dimp;

   
   for(ipg=0;ipg<(p->npgp[0]);ipg++)
   for(jpg=0;jpg<(p->npgp[1]);jpg++)
   #ifdef USE_SAC_3D
     for(kpg=0;kpg<(p->npgp[2]);kpg++)
   #endif
   {

     iia[0]=ip*(p->npgp[0])+ipg;
     iia[1]=jp*(p->npgp[1])+jpg;
     i=iia[0];
     j=iia[1];
     k=0;
     #ifdef USE_SAC_3D
	   iia[2]=kp*(p->npgp[2])+kpg;
           k=iia[2];
     #endif

     #ifdef USE_SAC_3D
     if(i<((p->n[0])) && j<((p->n[1])) && k<((p->n[2])))
     #else
    if(i<((p->n[0])) && j<((p->n[1])))
     #endif
 // if(i>0 && j >0 && i<((p->n[0])-1) && j<((p->n[1])-1))
	{		               

wtemp[fencode3_hdb1(p,iia,tmp4)]=grad1l3_hdb1(wtemp,p,iia,tmp1,dim);
wtemp[fencode3_hdb1(p,iia,tmp5)]=grad1r3_hdb1(wtemp,p,iia,tmp1,dim);

   }
}
 __syncthreads();   



   



}



__global__ void hyperdifbsource1_parallel(struct params *p,  real *wmod, 
    real *dwn1, real *wd, int order,int ordero, real *wtemp, int field, int dim, int jj, int ii0,int mm,real sb)
{
  int iindex = blockIdx.x * blockDim.x + threadIdx.x;
  int i,j;
  int m,ii1;
  real fip,fim1,tmpc;
  int index,k;
  int ni=p->n[0];
  int nj=p->n[1];

  real dt=p->dt;
  real dy=p->dx[1];
  real dx=p->dx[0];

  int ip,jp,ipg,jpg;
  int iia[NDIM];
  int dimp=((p->n[0]))*((p->n[1]));
 #ifdef USE_SAC_3D
   int kp,kpg;
   real dz=p->dx[2];
   dimp=((p->n[0]))*((p->n[1]))*((p->n[2]));
#endif  

  #ifdef USE_SAC_3D
   kp=iindex/(nj*ni/((p->npgp[1])*(p->npgp[0])));
   jp=(iindex-(kp*(nj*ni/((p->npgp[1])*(p->npgp[0])))))/(ni/(p->npgp[0]));
   ip=iindex-(kp*nj*ni/((p->npgp[1])*(p->npgp[0])))-(jp*(ni/(p->npgp[0])));
#endif
 #if defined USE_SAC || defined ADIABHYDRO
    jp=iindex/(ni/(p->npgp[0]));
   ip=iindex-(jp*(ni/(p->npgp[0])));
#endif  


int shift=order*NVAR*dimp;
   
   for(ipg=0;ipg<(p->npgp[0]);ipg++)
   for(jpg=0;jpg<(p->npgp[1]);jpg++)
   #ifdef USE_SAC_3D
     for(kpg=0;kpg<(p->npgp[2]);kpg++)
   #endif
   {

     iia[0]=ip*(p->npgp[0])+ipg;
     iia[1]=jp*(p->npgp[1])+jpg;
     i=iia[0];
     j=iia[1];
     k=0;
     #ifdef USE_SAC_3D
	   iia[2]=kp*(p->npgp[2])+kpg;
           k=iia[2];
     #endif

     #ifdef USE_SAC_3D
     if(i<((p->n[0])) && j<((p->n[1])) && k<((p->n[2])))
     #else
    if(i<((p->n[0])) && j<((p->n[1])))
     #endif

  //init rhol and rhor

  {
    for(int f=tmp1; f<=tmp8; f++)	
        wtemp[fencode3_hdb1(p,iia,f)]=0.0;

   dwn1[fencode3_hdb1(p,iia,energy)]=0.0;
   dwn1[fencode3_hdb1(p,iia,b1+ii0)]=0.0;
  }

}
 __syncthreads();



   
   for(ipg=0;ipg<(p->npgp[0]);ipg++)
   for(jpg=0;jpg<(p->npgp[1]);jpg++)
   #ifdef USE_SAC_3D
     for(kpg=0;kpg<(p->npgp[2]);kpg++)
   #endif
   {

     iia[0]=ip*(p->npgp[0])+ipg;
     iia[1]=jp*(p->npgp[1])+jpg;
     i=iia[0];
     j=iia[1];
     k=0;
     #ifdef USE_SAC_3D
	   iia[2]=kp*(p->npgp[2])+kpg;
           k=iia[2];
     #endif

     #ifdef USE_SAC_3D
     if(i>0 && j >0 && k>0 && i<((p->n[0])-1) && j<((p->n[1])-1) && k<((p->n[2])-1))
     #else
    if(i>0 && j >0 && i<((p->n[0])-1) && j<((p->n[1])-1))
     #endif

  //if(i>0 && j >0 && i<((p->n[0])-1) && j<((p->n[1])-1))
  {

     #ifdef USE_SAC_3D
       wtemp[fencode3_hdb1(p,iia,tmp2)]=(wmod[shift+fencode3_hdb1(p,iia,b1+jj)]+wmod[shift+encode3_hdb1(p,i-(dim==0),j-(dim==1),k-(dim==2),b1+jj)])/2;
       wtemp[fencode3_hdb1(p,iia,tmp3)]=(wmod[shift+fencode3_hdb1(p,iia,b1+jj)]+wmod[shift+encode3_hdb1(p,i+(dim==0),j+(dim==1),k+(dim==2),b1+jj)])/2;
     #else
       wtemp[fencode3_hdb1(p,iia,tmp2)]=(wmod[shift+fencode3_hdb1(p,iia,b1+jj)]+wmod[shift+encode3_hdb1(p,i-(dim==0),j-(dim==1),k,b1+jj)])/2;
       wtemp[fencode3_hdb1(p,iia,tmp3)]=(wmod[shift+fencode3_hdb1(p,iia,b1+jj)]+wmod[shift+encode3_hdb1(p,i+(dim==0),j+(dim==1),k,b1+jj)])/2;
     #endif
     wtemp[fencode3_hdb1(p,iia,tmp1)]=wmod[shift+fencode3_hdb1(p,iia,b1+field)];

   }

}
__syncthreads();






   

}


/////////////////////////////////////
// error checking routine
/////////////////////////////////////
void checkErrors_hdb1(char *label)
{
  // we need to synchronise first to catch errors due to
  // asynchroneous operations that would otherwise
  // potentially go unnoticed

  cudaError_t err;

  err = cudaThreadSynchronize();
  if (err != cudaSuccess)
  {
    char *e = (char*) cudaGetErrorString(err);
    fprintf(stderr, "CUDA Error: %s (at %s)", e, label);
  }

  err = cudaGetLastError();
  if (err != cudaSuccess)
  {
    char *e = (char*) cudaGetErrorString(err);
    fprintf(stderr, "CUDA Error: %s (at %s)", e, label);
  }
}





int cuhyperdifbsource1(struct params **p,  struct params **d_p,   real **d_wmod, real **d_dwn1, real **d_wd, int order,int ordero, real **d_wtemp, int field, int dim, int jj, int ii0,int mm,real sb, real dt)
{

 dim3 dimBlock(dimblock, 1);

    dim3 dimGrid(((*p)->n[0])/dimBlock.x,((*p)->n[1])/dimBlock.y);
   int numBlocks = (((*p)->n[0])*((*p)->n[1])+numThreadsPerBlock-1) / numThreadsPerBlock;


     hyperdifbsource1_parallel<<<numBlocks, numThreadsPerBlock>>>(*d_p, *d_wmod, *d_dwn1,  *d_wd, order,ordero,*d_wtemp, field, dim,jj,ii0,mm,sb); 
     cudaThreadSynchronize();
     hyperdifbsource2_parallel<<<numBlocks, numThreadsPerBlock>>>(*d_p, *d_wmod, *d_dwn1,  *d_wd, order,ordero,*d_wtemp, field, dim,jj,ii0,mm,sb); 
     cudaThreadSynchronize();
     hyperdifbsource3_parallel<<<numBlocks, numThreadsPerBlock>>>(*d_p, *d_wmod, *d_dwn1,  *d_wd, order,ordero,*d_wtemp, field, dim,jj,ii0,mm,sb,dt); 
     cudaThreadSynchronize();
     hyperdifbsource4_parallel<<<numBlocks, numThreadsPerBlock>>>(*d_p, *d_wmod, *d_dwn1,  *d_wd, order,ordero,*d_wtemp, field, dim,jj,ii0,mm,sb,dt); 
     cudaThreadSynchronize();

}








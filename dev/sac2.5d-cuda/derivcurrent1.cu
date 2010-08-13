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



__device__ __host__
int encode_dc1 (struct params *dp,int ix, int iy) {

  //int kSizeX=(dp)->ni;
  //int kSizeY=(dp)->nj;
  
  return ( iy * ((dp)->ni) + ix);
}

__device__ __host__
int fencode_dc1 (struct params *dp,int ix, int iy, int field) {

  //int kSizeX=(dp)->ni;
  //int kSizeY=(dp)->nj;
  
  return ( (iy * ((dp)->ni) + ix)+(field*((dp)->ni)*((dp)->nj)));
}

__device__ __host__
real evalgrad_dc1(real fi, real fim1, real fip2, real fim2,struct params *p,int dir)
{
 //real valgrad_dc1;

 if(dir == 0)
 {
     //valgrad=(2.0/(3.0*(p->dx)))*(fi-fim1)-(1.0/(12.0*(p->dx)))*(fip2-fim2);
   //return((1.0/(2.0*(p->dx)))*(fi-fim1));
   return(p->sodifon?((1.0/(2.0*(p->dx)))*(fi-fim1)):((1.0/(12.0*(p->dx)))*((8*fi-8*fim1+fim2-fip2))));
 }
 else if(dir == 1)
 {
    // valgrad=(2.0/(3.0*(p->dy)))*(fi-fim1)-(1.0/(12.0*(p->dy)))*(fip2-fim2);
     // return((2.0/(1.0*(p->dy)))*(fi-fim1));
   return(p->sodifon?((1.0/(2.0*(p->dy)))*(fi-fim1)):((1.0/(12.0*(p->dy)))*((8*fi-8*fim1+fim2-fip2))));
 }

 return -1;
}


__device__ __host__
real grad_dc1(real *wmod,struct params *p,int i,int j,int field,int dir)
{
 //real valgrad_dc1;

  if(dir == 0)
 {
    // valgrad=(2.0/(3.0*(p->dx)))*(wmod[fencode(p,i,j,field)]-wmod[fencode(p,i-1,j,field)])-(1.0/(12.0*(p->dx)))*(wmod[fencode(p,i+2,j,field)]-wmod[fencode(p,i-2,j,field)]);
//return((1.0/(2.0*(p->dx)))*(wmod[fencode_dc1(p,i+1,j,field)]-wmod[fencode_dc1(p,i-1,j,field)]));
 return(  ( (p->sodifon)?((8*wmod[fencode_dc1(p,i+1,j,field)]-8*wmod[fencode_dc1(p,i-1,j,field)]+wmod[fencode_dc1(p,i-2,j,field)]-wmod[fencode_dc1(p,i+2,j,field)])/6.0):wmod[fencode_dc1(p,i+1,j,field)]-wmod[fencode_dc1(p,i-1,j,field)])/(2.0*(p->dx))    );
 }
 else if(dir == 1)
 {
    // valgrad=(2.0/(3.0*(p->dy)))*(wmod[fencode(p,i,j,field)]-wmod[fencode(p,i,j-1,field)])-(1.0/(12.0*(p->dy)))*(wmod[fencode(p,i,j+2,field)]-wmod[fencode(p,i,j-2,field)]);
// return((1.0/(2.0*(p->dy)))*(wmod[fencode_dc1(p,i,j+1,field)]-wmod[fencode_dc1(p,i,j-1,field)]));
 return(  ( (p->sodifon)?((8*wmod[fencode_dc1(p,i,j+1,field)]-8*wmod[fencode_dc1(p,i,j-1,field)]+wmod[fencode_dc1(p,i,j-2,field)]-wmod[fencode_dc1(p,i,j+2,field)])/6.0):wmod[fencode_dc1(p,i,j+1,field)]-wmod[fencode_dc1(p,i,j-1,field)])/(2.0*(p->dy))    );
}
 return 0;
}

__device__ __host__
real ddotcurrentrho (real *dw, real *wd, real *w, struct params *p,int ix, int iy) {

  real ddc=0;
//  int field=rho;

      ddc= grad_dc1(w,p,ix,iy,mom1,0)+grad_dc1(w,p,ix,iy,mom2,1);
  return ( isnan(ddc)?0:ddc);
}

__device__ __host__
real ddotcurrentmom1 (real *dw, real *wd, real *w, struct params *p,int ix, int iy,int field, int direction) {

  real ddc=0;
  real fi, fim1;
  real  fip2=0, fim2=0;
 // real ddc1;
  real ddcx,ddcy;
   //     ddc= grad_dc1(w,p,ix,iy,mom1,0)+grad_dc1(w,p,ix,iy,mom2,1);
//evalgrad_dc1(real fi, real fim1, real fip2, real fim2,struct params *p,int dir)
  //fi=w(fencode_dc1(p,ix,iy,rho))
  //calculate momentum current

//w[fencode_dc1(p,ix,iy,rho)])=1;
//w[fencode_dc1(p,ix-1,iy,rho)])=1;
//w[fencode_dc1(p,ix+2,iy,rho)])=1;
//w[fencode_dc1(p,ix-2,iy,rho)])=1;
//w[fencode_dc1(p,ix,iy,rho)])=1;
//w[fencode_dc1(p,ix,iy-1,rho)])=1;
//w[fencode_dc1(p,ix,iy+2,rho)])=1;
//w[fencode_dc1(p,ix,iy-2,rho)])=1;

  switch(direction)
  {
    case 0:
       fi=(w[fencode_dc1(p,ix+1,iy,mom1)]/w[fencode_dc1(p,ix+1,iy,rho)])*w[fencode_dc1(p,ix+1,iy,mom1)];
       fim1=(w[fencode_dc1(p,ix-1,iy,mom1)]/w[fencode_dc1(p,ix-1,iy,rho)])*w[fencode_dc1(p,ix-1,iy,mom1)];
       if(p->sodifon)
       {
       fip2=(w[fencode_dc1(p,ix+2,iy,mom1)]/w[fencode_dc1(p,ix+2,iy,rho)])*w[fencode_dc1(p,ix+2,iy,mom1)];
       fim2=(w[fencode_dc1(p,ix-2,iy,mom1)]/w[fencode_dc1(p,ix-2,iy,rho)])*w[fencode_dc1(p,ix-2,iy,mom1)];
       }
       ddcx=evalgrad_dc1(fi,fim1,fip2,fim2,p,0);
      //ddcx=evalgrad_dc1(fi,fim1,0,0,p,0);
       //ddcx=fi-fim1;
       fi=(w[fencode_dc1(p,ix,iy+1,mom1)]/w[fencode_dc1(p,ix,iy+1,rho)])*w[fencode_dc1(p,ix,iy+1,mom2)];
       fim1=(w[fencode_dc1(p,ix,iy-1,mom1)]/w[fencode_dc1(p,ix,iy-1,rho)])*w[fencode_dc1(p,ix,iy-1,mom2)];
       if(p->sodifon)
       {
       fip2=(w[fencode_dc1(p,ix,iy+2,mom1)]/w[fencode_dc1(p,ix,iy+2,rho)])*w[fencode_dc1(p,ix,iy+2,mom2)];
       fim2=(w[fencode_dc1(p,ix,iy-2,mom1)]/w[fencode_dc1(p,ix,iy-2,rho)])*w[fencode_dc1(p,ix,iy-2,mom2)];
       }
       //ddcy=fi;
       ddcy=evalgrad_dc1(fi,fim1,fip2,fim2,p,1);
       //ddcy=evalgrad_dc1(0,0,fip2,fim2,p,1);
    break;
    case 1:
       fi=(w[fencode_dc1(p,ix+1,iy,mom2)]/w[fencode_dc1(p,ix+1,iy,rho)])*w[fencode_dc1(p,ix+1,iy,mom1)];
       fim1=(w[fencode_dc1(p,ix-1,iy,mom2)]/w[fencode_dc1(p,ix-1,iy,rho)])*w[fencode_dc1(p,ix-1,iy,mom1)];
       if(p->sodifon)
       {
       fip2=(w[fencode_dc1(p,ix+2,iy,mom2)]/w[fencode_dc1(p,ix+2,iy,rho)])*w[fencode_dc1(p,ix+2,iy,mom1)];
       fim2=(w[fencode_dc1(p,ix-2,iy,mom2)]/w[fencode_dc1(p,ix-2,iy,rho)])*w[fencode_dc1(p,ix-2,iy,mom1)];
       }
       ddcx=evalgrad_dc1(fi,fim1,fip2,fim2,p,0);
       fi=(w[fencode_dc1(p,ix,iy+1,mom2)]/w[fencode_dc1(p,ix,iy+1,rho)])*w[fencode_dc1(p,ix,iy+1,mom2)];
       fim1=(w[fencode_dc1(p,ix,iy-1,mom2)]/w[fencode_dc1(p,ix,iy-1,rho)])*w[fencode_dc1(p,ix,iy-1,mom2)];
       if(p->sodifon)
       {
       fip2=(w[fencode_dc1(p,ix,iy+2,mom2)]/w[fencode_dc1(p,ix,iy+2,rho)])*w[fencode_dc1(p,ix,iy+2,mom2)];
       fim2=(w[fencode_dc1(p,ix,iy-2,mom2)]/w[fencode_dc1(p,ix,iy-2,rho)])*w[fencode_dc1(p,ix,iy-2,mom2)];
       }
       ddcy=evalgrad_dc1(fi,fim1,fip2,fim2,p,1);
    break;
    case 2:
       fi=(w[fencode_dc1(p,ix+1,iy,mom3)]/w[fencode_dc1(p,ix+1,iy,rho)])*w[fencode_dc1(p,ix+1,iy,mom1)];
       fim1=(w[fencode_dc1(p,ix-1,iy,mom3)]/w[fencode_dc1(p,ix-1,iy,rho)])*w[fencode_dc1(p,ix-1,iy,mom1)];
       if(p->sodifon)
       {
         fip2=(w[fencode_dc1(p,ix+2,iy,mom3)]/w[fencode_dc1(p,ix+2,iy,rho)])*w[fencode_dc1(p,ix+2,iy,mom1)];
         fim2=(w[fencode_dc1(p,ix-2,iy,mom3)]/w[fencode_dc1(p,ix-2,iy,rho)])*w[fencode_dc1(p,ix-2,iy,mom1)];
       }
       ddcx=evalgrad_dc1(fi,fim1,fip2,fim2,p,0);
       fi=(w[fencode_dc1(p,ix,iy+1,mom3)]/w[fencode_dc1(p,ix,iy+1,rho)])*w[fencode_dc1(p,ix,iy+1,mom2)];
       fim1=(w[fencode_dc1(p,ix,iy-1,mom3)]/w[fencode_dc1(p,ix,iy-1,rho)])*w[fencode_dc1(p,ix,iy-1,mom2)];
       if(p->sodifon)
       {
       fip2=(w[fencode_dc1(p,ix,iy+2,mom3)]/w[fencode_dc1(p,ix,iy+2,rho)])*w[fencode_dc1(p,ix,iy+2,mom2)];
       fim2=(w[fencode_dc1(p,ix,iy-2,mom3)]/w[fencode_dc1(p,ix,iy-2,rho)])*w[fencode_dc1(p,ix,iy-2,mom2)];
       }
       ddcy=evalgrad_dc1(fi,fim1,fip2,fim2,p,1);
    break;
  }
  
  return(isnan(ddcx)?0:ddcx)+(isnan(ddcy)?0:ddcy);


  //return ( ddc1-ddc2);
}

__device__ __host__
real ddotcurrentmom2 (real *dw, real *wd, real *w, struct params *p,int ix, int iy,int field, int direction) {

  real ddc=0;
  real fi, fim1;
  real  fip2=0, fim2=0;
  //real ddc1,ddc2;
  real ddcx,ddcy;
   //     ddc= grad_dc1(w,p,ix,iy,mom1,0)+grad_dc1(w,p,ix,iy,mom2,1);
//evalgrad_dc1(real fi, real fim1, real fip2, real fim2,struct params *p,int dir)
  //fi=w(fencode_dc1(p,ix,iy,rho))
  //calculate momentum current

//w[fencode_dc1(p,ix,iy,rho)])=1;
//w[fencode_dc1(p,ix-1,iy,rho)])=1;
//w[fencode_dc1(p,ix+2,iy,rho)])=1;
//w[fencode_dc1(p,ix-2,iy,rho)])=1;
//w[fencode_dc1(p,ix,iy,rho)])=1;
//w[fencode_dc1(p,ix,iy-1,rho)])=1;
//w[fencode_dc1(p,ix,iy+2,rho)])=1;
//w[fencode_dc1(p,ix,iy-2,rho)])=1;

//fip2=0, fim2=0;
  //calculate bfield current
  switch(direction)
  {
    case 0:
       fi=w[fencode_dc1(p,ix+1,iy,b1)]*w[fencode_dc1(p,ix+1,iy,b1)];
       fim1=w[fencode_dc1(p,ix-1,iy,b1)]*w[fencode_dc1(p,ix-1,iy,b1)];
      if(p->sodifon)
      {
      fip2=w[fencode_dc1(p,ix+2,iy,b1)]*w[fencode_dc1(p,ix+2,iy,b1)];
       fim2=w[fencode_dc1(p,ix-2,iy,b1)]*w[fencode_dc1(p,ix-2,iy,b1)];
      }
       ddcx=evalgrad_dc1(fi,fim1,fip2,fim2,p,0);


       fi=w[fencode_dc1(p,ix,iy+1,b1)]*w[fencode_dc1(p,ix,iy+1,b2)];
       fim1=w[fencode_dc1(p,ix,iy-1,b1)]*w[fencode_dc1(p,ix,iy-1,b2)];
           if(p->sodifon)
      {
       fip2=w[fencode_dc1(p,ix,iy+2,b1)]*w[fencode_dc1(p,ix,iy+2,b2)];
       fim2=w[fencode_dc1(p,ix,iy-2,b1)]*w[fencode_dc1(p,ix,iy-2,b2)];
      }
       ddcy=evalgrad_dc1(fi,fim1,fip2,fim2,p,1);
    break;
    case 1:
       fi=w[fencode_dc1(p,ix+1,iy,b2)]*w[fencode_dc1(p,ix+1,iy,b1)];
       fim1=w[fencode_dc1(p,ix-1,iy,b2)]*w[fencode_dc1(p,ix-1,iy,b1)];

     if(p->sodifon)
      {
       fip2=w[fencode_dc1(p,ix+2,iy,b2)]*w[fencode_dc1(p,ix+2,iy,b1)];
       fim2=w[fencode_dc1(p,ix-2,iy,b2)]*w[fencode_dc1(p,ix-2,iy,b1)];
      }
       ddcx=evalgrad_dc1(fi,fim1,fip2,fim2,p,0);
       fi=w[fencode_dc1(p,ix,iy+1,b2)]*w[fencode_dc1(p,ix,iy+1,b2)];
       fim1=w[fencode_dc1(p,ix,iy-1,b2)]*w[fencode_dc1(p,ix,iy-1,b2)];

      if(p->sodifon)
      {
       fip2=w[fencode_dc1(p,ix,iy+2,b2)]*w[fencode_dc1(p,ix,iy+2,b2)];
       fim2=w[fencode_dc1(p,ix,iy-2,b2)]*w[fencode_dc1(p,ix,iy-2,b2)];
      }
       ddcy=evalgrad_dc1(fi,fim1,fip2,fim2,p,1);
    break;
    case 2:
       fi=w[fencode_dc1(p,ix+1,iy,b3)]*w[fencode_dc1(p,ix+1,iy,b1)];
       fim1=w[fencode_dc1(p,ix-1,iy,b3)]*w[fencode_dc1(p,ix-1,iy,b1)];

      if(p->sodifon)
      {
       fip2=w[fencode_dc1(p,ix+2,iy,b3)]*w[fencode_dc1(p,ix+2,iy,b1)];
       fim2=w[fencode_dc1(p,ix-2,iy,b3)]*w[fencode_dc1(p,ix-2,iy,b1)];
       }
       ddcx=evalgrad_dc1(fi,fim1,fip2,fim2,p,0);
       fi=w[fencode_dc1(p,ix,iy+1,b3)]*w[fencode_dc1(p,ix,iy+1,b2)];
       fim1=w[fencode_dc1(p,ix,iy-1,b3)]*w[fencode_dc1(p,ix,iy-1,b2)];
            if(p->sodifon)
      {
       fip2=w[fencode_dc1(p,ix,iy+2,b3)]*w[fencode_dc1(p,ix,iy+2,b2)];
       fim2=w[fencode_dc1(p,ix,iy-2,b3)]*w[fencode_dc1(p,ix,iy-2,b2)];
       }
       ddcy=evalgrad_dc1(fi,fim1,fip2,fim2,p,1);
    break;
  }
  //ddc2=ddcx+ddcy;
 // ddc2=(isnan(ddcx)?0:ddcx)+(isnan(ddcy)?0:ddcy);
return(isnan(ddcx)?0:-ddcx)-(isnan(ddcy)?0:ddcy);
  //ddc=ddc1-ddc2;

  //return ( ddc1-ddc2);
}



__device__ __host__
int derivcurrentrho (real *dw, real *wd, real *w, struct params *p,int ix, int iy) {

  int status=0;
  int field=rho;
        dw[fencode_dc1(p,ix,iy,field)]= -ddotcurrentrho(dw,wd,w,p,ix,iy);
     	//dw[fencode_dc1(p,ix,iy,field)]=w[fencode_dc1(p,ix,iy,field)]+10;
  return ( status);
}

__device__ __host__
int derivcurrentmom (real *dw, real *wd, real *w, struct params *p,int ix, int iy,int field, int direction) {

  int status=0;
     	//dw[fencode_dc1(p,ix,iy,field)]=w[fencode_dc1(p,ix,iy,field)]+20+5*(2*direction+1);
        dw[fencode_dc1(p,ix,iy,field)]= -ddotcurrentmom1(dw,wd,w,p,ix,iy,field,direction)-ddotcurrentmom2(dw,wd,w,p,ix,iy,field,direction);
        //dw[fencode_dc1(p,ix,iy,field)]=-ddotcurrentmom(dw,wd,w,p,ix,iy,field,direction);

  return ( status);
}


//rho, mom1, mom2, mom3, energy, b1, b2, b3
__device__ __host__
void derivcurrent1 (real *dw, real *wd, real *w, struct params *p,int ix, int iy, int field) {

  //int status=0;
  switch(field)
  {
     case rho:
      derivcurrentrho(dw,wd,w,p,ix,iy);
     break;
     case mom1:
      derivcurrentmom(dw,wd,w,p,ix,iy,field,0);
     break;
     case mom2:
       derivcurrentmom(dw,wd,w,p,ix,iy,field,1);
     break;
     case mom3:
      derivcurrentmom(dw,wd,w,p,ix,iy,field,2);
     break;
  }
  //return ( status);
}



__global__ void derivcurrent1_parallel(struct params *p, real *w, real *wnew, real *wmod, 
    real *dwn1, real *wd, int order)
{
  // compute the global index in the vector from
  // the number of the current block, blockIdx,
  // the number of threads per block, blockDim,
  // and the number of the current thread within the block, threadIdx
  //int i = blockIdx.x * blockDim.x + threadIdx.x;
  //int j = blockIdx.y * blockDim.y + threadIdx.y;

  int iindex = blockIdx.x * blockDim.x + threadIdx.x;
  int i,j;
  int index,k;
  int ni=p->ni;
  int nj=p->nj;
  real dt=p->dt;
  real dy=p->dy;
  real dx=p->dx;
  real g=p->g;
 //  dt=1.0;
//dt=0.05;
//enum vars rho, mom1, mom2, mom3, energy, b1, b2, b3;


  

   j=iindex/ni;
   //i=iindex-j*(iindex/ni);
   i=iindex-(j*ni);


  //if(i>(1+(p->sodifon==1)) && j >(1+(p->sodifon==1)) && i<((p->ni)-1-(p->sodifon==1)) && j<((p->nj)-1-(p->sodifon==1)))
if(i>1 && j >1 && i<(ni-2) && j<(nj-2))
	{		               
               /*for(int f=rho; f<=b3; f++)               
                  wmod[fencode_dc1(p,i,j,f)]=w[fencode_dc1(p,i,j,f)];
               computej(wmod,wd,p,i,j);
               computepk(wmod,wd,p,i,j);
               computept(wmod,wd,p,i,j);
               computebdotv(wmod,wd,p,i,j);*/
          
               for(int f=rho; f<=mom3; f++)
               {              
                  derivcurrent1(dwn1+(8*(p->ni)*(p->nj)*order),wd,wmod,p,i,j,f);
                  //dwn1[fencode_dc1(p,i,j,f)]=1.0;
                  //__syncthreads();
               }
               
               /*for(int f=rho; f<=b3; f++) 
                  wmod[fencode_dc1(p,i,j,f)]=w[fencode_dc1(p,i,j,f)]+0.5*dt*dwn1[fencode_dc1(p,i,j,f)];
               computej(wmod,wd,p,i,j);
               computepk(wmod,wd,p,i,j);
               computept(wmod,wd,p,i,j);
               for(int f=rho; f<=b3; f++) 
                  deriv(dwn2,wd,wmod,p,i,j,f);
               
               for(int f=rho; f<=b3; f++) 
                  wmod[fencode_dc1(p,i,j,f)]=w[fencode_dc1(p,i,j,f)]+0.5*dt*dwn2[fencode_dc1(p,i,j,f)];
               computej(wmod,wd,p,i,j);
               computepk(wmod,wd,p,i,j);
               computept(wmod,wd,p,i,j);
               for(int f=rho; f<=b3; f++) 
                  deriv(dwn3,wd,wmod,p,i,j,f);
               
               for(int f=rho; f<=b3; f++) 
                  wmod[fencode_dc1(p,i,j,f)]=w[fencode_dc1(p,i,j,f)]+dt*dwn3[fencode_dc1(p,i,j,f)];
               computej(wmod,wd,p,i,j);
               computepk(wmod,wd,p,i,j);
               computept(wmod,wd,p,i,j);
               for(int f=rho; f<=b3; f++) 
                  deriv(dwn4,wd,wmod,p,i,j,f);
               
               for(int f=rho; f<=b3; f++) 
                  {
                  wnew[fencode_dc1(p,i,j,f)]=w[fencode_dc1(p,i,j,f)]+(dt/6.0)*(
                     dwn1[fencode_dc1(p,i,j,f)]+2.0*dwn2[fencode_dc1(p,i,j,f)]
                         +2.0*dwn3[fencode_dc1(p,i,j,f)]+dwn4[fencode_dc1(p,i,j,f)]);
               }*/
              //  __syncthreads();
              /* for(int f=rho; f<=b3; f++)
                   wnew[fencode_dc1(p,i,j,f)]=w[fencode_dc1(p,i,j,f)]+dt*dwn1[fencode_dc1(p,i,j,f)];
               computej(wnew,wd,p,i,j);
               computepk(wnew,wd,p,i,j);
               computept(wnew,wd,p,i,j);*/ 


	}
 __syncthreads();
  
}


/////////////////////////////////////
// error checking routine
/////////////////////////////////////
void checkErrors_dc1(char *label)
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




int cuderivcurrent1(struct params **p, real **w, real **wnew, struct params **d_p, real **d_w, real **d_wnew,  real **d_wmod, real **d_dwn1, real **d_wd, int order)
{


//printf("calling propagate solution\n");

    //dim3 dimBlock(blocksize, blocksize);
    //dim3 dimGrid(((*p)->ni)/dimBlock.x,((*p)->nj)/dimBlock.y);
 dim3 dimBlock(dimblock, 1);
    //dim3 dimGrid(((*p)->ni)/dimBlock.x,((*p)->nj)/dimBlock.y);
    dim3 dimGrid(((*p)->ni)/dimBlock.x,((*p)->nj)/dimBlock.y);
   int numBlocks = (((*p)->ni)*((*p)->nj)+numThreadsPerBlock-1) / numThreadsPerBlock;
 //  cudaMemcpy(*w, *d_w, 8*((*p)->ni)* ((*p)->nj)*sizeof(real), cudaMemcpyDeviceToHost);
 // if(order==0)
    cudaMemcpy(*d_p, *p, sizeof(struct params), cudaMemcpyHostToDevice);

//__global__ void prop_parallel(struct params *p, real *b, real *w, real *wnew, real *wmod, 
  //  real *dwn1, real *dwn2, real *dwn3, real *dwn4, real *wd)
     //init_parallel(struct params *p, real *b, real *u, real *v, real *h)
     derivcurrent1_parallel<<<numBlocks, numThreadsPerBlock>>>(*d_p,*d_w,*d_wnew, *d_wmod, *d_dwn1,  *d_wd, order);
     //prop_parallel<<<dimGrid,dimBlock>>>(*d_p,*d_b,*d_u,*d_v,*d_h);
	    //printf("called prop\n"); 
     cudaThreadSynchronize();
     //boundary_parallel<<<numBlocks, numThreadsPerBlock>>>(*d_p,*d_b,*d_w,*d_wnew);
	    //printf("called boundary\n");  
     //cudaThreadSynchronize();
     //update_parallel<<<numBlocks, numThreadsPerBlock>>>(*d_p,*d_b,*d_w,*d_wnew);
	    //printf("called update\n"); 
   // cudaThreadSynchronize();
// cudaMemcpy(*w, *d_w, 8*((*p)->ni)* ((*p)->nj)*sizeof(real), cudaMemcpyDeviceToHost);
//cudaMemcpy(*wnew, *d_wnew, 8*((*p)->ni)* ((*p)->nj)*sizeof(real), cudaMemcpyDeviceToHost);
//cudaMemcpy(*b, *d_b, (((*p)->ni)* ((*p)->nj))*sizeof(real), cudaMemcpyDeviceToHost);

  //checkErrors("copy data from device");


 


}



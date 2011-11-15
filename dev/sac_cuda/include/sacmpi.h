#include "mpi.h"
#include "iotypes.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

MPI::Intracomm comm;
MPI::Request request;
double gwall_time;
real *gmpisendbuffer;
real *gmpirecvbuffer;

real **gmpisrcbufferl;
real **gmpisrcbufferr;
real **gmpitgtbufferl;
real **gmpitgtbufferr;


int gnmpirequest,gnmpibuffer;
MPI::Request *gmpirequest;



int encode3p2_sacmpi (struct params *dp,int ix, int iy, int iz, int field) {


  #ifdef USE_SAC_3D
    return ( (iz*(((dp)->n[0])+2)*(((dp)->n[1])+2)  + iy * (((dp)->n[0])+2) + ix)+(field*(((dp)->n[0])+2)*(((dp)->n[1])+2)*(((dp)->n[2])+2)));
  #else
    return ( (iy * (((dp)->n[0])+2) + ix)+(field*(((dp)->n[0])+2)*(((dp)->n[1])+2)));
  #endif
}

/*void mpiinit(params *p);
void mpifinalize(params *p);
void mpisetnpediped(params *p, char *string);
void ipe2iped(params *p);
void iped2ipe(params *p);*/

//!=============================================================================
//subroutine mpiinit
//
//! Initialize MPI variables
//

//!----------------------------------------------------------------------------
//call MPI_INIT(ierrmpi)
//call MPI_COMM_RANK (MPI_COMM_WORLD, ipe, ierrmpi)
//call MPI_COMM_SIZE (MPI_COMM_WORLD, npe, ierrmpi)

//! unset values for directional processor numbers
//npe1=-1;npe2=-1;
//! default value for test processor
//ipetest=0
void mpiinit(params *p)
{
    int nmpibuffer;
   int numbuffers=2;
   int i;


     //MPI::Intracomm comm;
     //MPI_Init(&argc, &argv);
     gwall_time = MPI_Wtime();
     comm=MPI::COMM_WORLD;
     p->npe=comm.Get_size();
     p->ipe=comm.Get_rank();

#ifdef USE_SAC3D
   if((p->n[0])>(p->n[1])  && (p->n[0])>(p->n[2]))
   {
     if((p->n[1])>(p->n[2]))
       nmpibuffer=NVAR*(p->n[0])*(p->n[1])*(p->ng[0]);
     else
       nmpibuffer=NVAR*(p->n[0])*(p->n[2])*(p->ng[0]);

   }
   else if((p->n[1])>(p->n[0])  && (p->n[1])>(p->n[2]))
   {
     if((p->n[0])>(p->n[2]))
       nmpibuffer=NVAR*(p->n[1])*(p->n[0])*(p->ng[1]);
     else
       nmpibuffer=NVAR*(p->n[1])*(p->n[2])*(p->ng[1]);
   }
   else if((p->n[2])>(p->n[0])  && (p->n[2])>(p->n[1]))
   {
     if((p->n[0])>(p->n[1]))
       nmpibuffer=NVAR*(p->n[2])*(p->n[0])*(p->ng[2]);
     else
       nmpibuffer=NVAR*(p->n[2])*(p->n[1])*(p->ng[2]);
   }

#else
   if((p->n[0])>(p->n[1]))
    nmpibuffer=NVAR*(p->n[0])*(p->ng[0]);
   else
    nmpibuffer=NVAR*(p->n[1])*(p->ng[1]);
#endif
     gnmpirequest=0;
     gnmpibuffer=nmpibuffer;
     gmpirequest=(MPI::Request *)calloc(numbuffers,sizeof(MPI::Request));
     gmpisendbuffer=(real *)calloc(nmpibuffer,sizeof(real));
     gmpirecvbuffer=(real *)calloc(nmpibuffer*numbuffers,sizeof(real));	
     

for(i=0;i<NDIM;i++)
{
     gmpisrcbufferl=(real **)calloc(NDIM,sizeof(real *));
     gmpisrcbufferr=(real **)calloc(NDIM,sizeof(real *));
     gmpitgtbufferl=(real **)calloc(NDIM,sizeof(real *));
     gmpitgtbufferr=(real **)calloc(NDIM,sizeof(real *));
}

for(i=0;i<NDIM;i++)
{
              switch(i)
              {
                 case 0:
#ifdef USE_SAC3D
     gmpisrcbufferl[i]=(real *)calloc( ((p->n[1])+2)*((p->n[2])+2),sizeof(real));
     gmpisrcbufferr[i]=(real *)calloc( ((p->n[1])+2)*((p->n[2])+2),sizeof(real ));
     gmpitgtbufferl[i]=(real *)calloc(((p->n[1])+2)*((p->n[2])+2),sizeof(real ));
     gmpitgtbufferr[i]=(real *)calloc(((p->n[1])+2)*((p->n[2])+2),sizeof(real ));
#else
     gmpisrcbufferl[i]=(real *)calloc((p->n[1])+2,sizeof(real ));
     gmpisrcbufferr[i]=(real *)calloc((p->n[1])+2,sizeof(real ));
     gmpitgtbufferl[i]=(real *)calloc((p->n[1])+2,sizeof(real ));
     gmpitgtbufferr[i]=(real *)calloc((p->n[1])+2,sizeof(real ));
#endif
                      
                      break;   
                 case 1:
#ifdef USE_SAC3D
     gmpisrcbufferl[i]=(real *)calloc(((p->n[0])+2)*((p->n[2])+2),sizeof(real ));
     gmpisrcbufferr[i]=(real *)calloc(((p->n[0])+2)*((p->n[2])+2),sizeof(real ));
     gmpitgtbufferl[i]=(real *)calloc(((p->n[0])+2)*((p->n[2])+2),sizeof(real ));
     gmpitgtbufferr[i]=(real *)calloc(((p->n[0])+2)*((p->n[2])+2),sizeof(real ));
#else
     gmpisrcbufferl[i]=(real *)calloc((p->n[0])+2,sizeof(real ));
     gmpisrcbufferr[i]=(real *)calloc((p->n[0])+2,sizeof(real ));
     gmpitgtbufferl[i]=(real *)calloc((p->n[0])+2,sizeof(real ));
     gmpitgtbufferr[i]=(real *)calloc((p->n[0])+2,sizeof(real ));
#endif
                      
                      break;
#ifdef USE_SAC3D         
                 case 2:
     gmpisrcbufferl[i]=(real *)calloc(((p->n[0])+2)*((p->n[1])+2),sizeof(real ));
     gmpisrcbufferr[i]=(real *)calloc(((p->n[0])+2)*((p->n[1])+2),sizeof(real ));
     gmpitgtbufferl[i]=(real *)calloc(((p->n[0])+2)*((p->n[1])+2),sizeof(real ));
     gmpitgtbufferr[i]=(real *)calloc(((p->n[0])+2)*((p->n[1])+2),sizeof(real ));
                      break;
#endif                             
                       }     
}    
     	
}



//!==============================================================================
//subroutine mpifinalize

//call MPI_BARRIER(MPI_COMM_WORLD,ierrmpi)
//call MPI_FINALIZE(ierrmpi)

void mpifinalize(params *p)
{
     gwall_time = MPI_Wtime() - gwall_time;
     if ((p->ipe) == 0)
	  printf("\n Wall clock time = %f secs\n", gwall_time);
     free(gmpisendbuffer);
     free(gmpirecvbuffer);
     free(gmpirequest);
     MPI_Finalize();
}





//!==============================================================================
//subroutine mpisetnpeDipeD(name)

//! Set directional processor numbers and indexes based on a filename.
//! The filename contains _np followed by np^D written with 2 digit integers.
//! For example _np0203 means np1=2, np2=3 for 2D.

//! Extract and check the directional processor numbers and indexes
//! and concat the PE number to the input and output filenames

void mpisetnpediped(params *p, char *string)
{    
  
}


//!==============================================================================
//subroutine ipe2ipeD(qipe,qipe1,qipe2)
//
//! Convert serial processor index to directional processor indexes

//integer:: qipe1,qipe2, qipe
//!-----------------------------------------------------------------------------
//qipe1 = qipe - npe1*(qipe/npe1)
//qipe2 = qipe/npe1 - npe2*(qipe/(npe1*npe2)) 

void ipe2iped(params *p)
{

#ifdef USE_SAC_3D
//qipe1 = qipe - npe1*(qipe/npe1)
//qipe2 = qipe/npe1 - npe2*(qipe/(npe1*npe2)) 
//qipe3 = qipe/(npe1*npe2)
(p->pipe[0])=(p->ipe)-(p->pnpe[0])*(p->ipe)/(p->pnpe[0]);
(p->pipe[1])=((p->ipe)/(p->pnpe[0]))-(p->pnpe[1])*(p->ipe)/((p->pnpe[0])*(p->pnpe[1]));
(p->pipe[2])=(p->ipe)/((p->pnpe[0])*(p->pnpe[1]));   


//set upper boundary flags
//mpiupperB(1)=ipe1<npe1-1
//mpilowerB(1)=ipe1>0 

//mpiupperB(2)=ipe2<npe2-1
//mpilowerB(2)=ipe2>0 

(p->mpiupperb[0])=(p->pipe[0])<((p->npe[0]-1);
(p->mpiupperb[1])=(p->pipe[1])<((p->npe[1]-1);
(p->mpiupperb[2])=(p->pipe[2])<((p->npe[2]-1);

(p->mpilowerb[0])=(p->pipe[0])>0;
(p->mpilowerb[1])=(p->pipe[1])>0;
(p->mpilowerb[2])=(p->pipe[2])>0;
#else
//qipe1 = qipe - npe1*(qipe/npe1)
//qipe2 = qipe/npe1 - npe2*(qipe/(npe1*npe2)) 
(p->pipe[0])=(p->ipe)-(p->pnpe[0])*(p->ipe)/(p->pnpe[0]);
(p->pipe[1])=((p->ipe)/(p->pnpe[0]))-(p->pnpe[1])*(p->ipe)/((p->pnpe[0])*(p->pnpe[1]));

(p->mpiupperb[0])=(p->pipe[0])<((p->pnpe[0])-1);
(p->mpiupperb[1])=(p->pipe[1])<((p->pnpe[1])-1);

(p->mpilowerb[0])=(p->pipe[0])>0;
(p->mpilowerb[1])=(p->pipe[1])>0;

#endif



    //ensure boundary set correctly 
    for(int ii=0; ii<NVAR; ii++)
    for(int idir=0; idir<NDIM; idir++)
    {
       if( ((p->boundtype[ii][idir])==0) && ((p->pnpe[idir])>0) )
                                     p->boundtype[ii][idir]=2;
       else if( (((p->mpiupperb[idir])==1)    &&  ((p->pipe[idir])<(p->pnpe[idir])-1)) || 
          ( ((p->mpiupperb[idir])!=1)    &&  ((p->pipe[idir])>0) )  )
                                     p->boundtype[ii][idir]=1;
    }



}

//!==============================================================================
//subroutine ipeD2ipe(qipe1,qipe2,qipe)
//
//! Convert directional processor indexes to serial processor index

//include 'vacdef.f'

//integer:: qipe1,qipe2, qipe
//!-----------------------------------------------------------------------------
//qipe = qipe1  + npe1*qipe2

void iped2ipe(int *tpipe,int *tpnp, int *oipe)
{
  #ifdef USE_SAC_3D
  //qipe = qipe1  + npe1*qipe2  + npe1*npe2*qipe3
  (*oipe)=tpipe[0]+(tpnp[0])*(tpipe[1])+(tpnp[0])*(tpnp[1])*(tpipe[2]);
  #else
  (*oipe)=tpipe[0]+(tpnp[0])*(tpipe[1]);
  #endif

}

//!==============================================================================
//subroutine mpineighbors(idir,hpe,jpe)

//! Find the hpe and jpe processors on the left and right side of this processor 
//! in direction idir. The processor cube is taken to be periodic in every
//! direction.

//!-----------------------------------------------------------------------------
//hpe1=ipe1-kr(1,idir);hpe2=ipe2-kr(2,idir);
//jpe1=ipe1+kr(1,idir);jpe2=ipe2+kr(2,idir);

//if(hpe1<0)hpe1=npe1-1
//if(jpe1>=npe1)jpe1=0

//if(hpe2<0)hpe2=npe2-1
//if(jpe2>=npe2)jpe2=0

//call ipeD2ipe(hpe1,hpe2,hpe)
//call ipeD2ipe(jpe1,jpe2,jpe)
void mpineighbours(int dir, params *p)
{
     int i;
     for(i=0; i<NDIM;i++)
     {
             (p->phpe[i])=(p->pipe[i])-(dir==i);
             (p->pjpe[i])=(p->pipe[i])+(dir==i);             
     }

     for(i=0; i<NDIM;i++)
     {
              if((p->phpe[i])<0) (p->phpe[i])=(p->pnpe[i])-1; 
              if((p->pjpe[i])<0) (p->pjpe[i])=0;                    
     }
     
     iped2ipe(p->phpe,p->pnpe,&(p->hpe));
     iped2ipe(p->pjpe,p->pnpe,&(p->jpe));
}

//!==============================================================================
//subroutine mpisend(nvar,var,ixmin1,ixmin2,ixmax1,ixmax2,qipe,iside)
//
//! Send var(ix^L,1:nvar) to processor qipe.
//! jside is 0 for min and 1 for max side of the grid for the sending PE
void mpisend(int nvar,real *var, int *ixmin, int *ixmax  ,int qipe,int iside, params *p)
{
   int n=0;
   int i1,i2,i3,ivar;
 
   for(ivar=0; ivar<NVAR;ivar++)
     for(i1=ixmin[0];i1<ixmax[0];i1++)
      for(i2=ixmin[1];i2<ixmax[1];i2++)
#ifdef USE_SAC3D
        for(i3=ixmin[2];i3<ixmax[2];i3++)
#endif
      {
	n++;

#ifdef USE_SAC3D
	gmpisendbuffer[n]= *(var+(i3*(p->n[0])*(p->n[1]))+(i2*(p->n[0])+i1)+(ivar*(p->n[0])*(p->n[1])*(p->n[2])));
#else
	gmpisendbuffer[n]=*(var+(i2*(p->n[0])+i1)+(ivar*(p->n[0])*(p->n[1])));
#endif
        

      }
   
   comm.Rsend(gmpisendbuffer, nvar, MPI_DOUBLE_PRECISION, qipe, 10*(p->ipe)+iside);


}


//!==============================================================================
//subroutine mpirecvbuffer(nvar,ixmin1,ixmin2,ixmax1,ixmax2,qipe,iside)
//
//! receive buffer for a ghost cell region of size ix^L sent from processor qipe
//! and sent from side iside of the grid
//
//include 'vacdef.f'
//
//integer:: nvar, ixmin1,ixmin2,ixmax1,ixmax2, qipe, iside, n
//
//integer :: nmpirequest, mpirequests(2)
//integer :: mpistatus(MPI_STATUS_SIZE,2)
//common /mpirecv/ nmpirequest,mpirequests,mpistatus
//!----------------------------------------------------------------------------
void mpirecvbuffer(int nvar,int *ixmin, int *ixmax  ,int qipe,int iside, params *p)
{
int nrecv;
#ifdef USE_SAC3D
   nrecv = nvar* (ixmax[0]-ixmin[0]+1)*(ixmax[1]-ixmin[1]+1)*(ixmax[2]-ixmin[2]+1);
#else
   nrecv = nvar* (ixmax[0]-ixmin[0]+1)*(ixmax[1]-ixmin[1]+1);
#endif

gnmpirequest++;

gmpirequest[gnmpirequest]=comm.Irecv(gmpirecvbuffer+(iside*gnmpibuffer),nrecv,MPI_DOUBLE_PRECISION,qipe,10*(p->ipe)+iside);

}


//!==============================================================================
//subroutine mpibuffer2var(iside,nvar,var,ixmin1,ixmin2,ixmax1,ixmax2)
//
//! Copy mpibuffer(:,iside) into var(ix^L,1:nvar)
//include 'vacdef.f'
//
//integer :: nvar
//double precision:: var(ixGlo1:ixGhi1,ixGlo2:ixGhi2,nvar)
//integer:: ixmin1,ixmin2,ixmax1,ixmax2,iside,n,ix1,ix2,ivar
//!-----------------------------------------------------------------------------
void mpibuffer2var(int iside,int nvar,real *var,int *ixmin, int *ixmax, params *p)
{
   int n=0;
   int ivar,i1,i2,i3;
 
   for(ivar=0; ivar<NVAR;ivar++)
     for(i1=ixmin[0];i1<ixmax[0];i1++)
      for(i2=ixmin[1];i2<ixmax[1];i2++)
#ifdef USE_SAC3D
        for(i3=ixmin[2];i3<ixmax[2];i3++)
#endif
      {
	n++;

#ifdef USE_SAC3D
	*(var+(i3*(p->n[0])*(p->n[1]))+(i2*(p->n[0])+i1)+(ivar*(p->n[0])*(p->n[1])*(p->n[2])))=gmpirecvbuffer[n+iside*gnmpibuffer];
#else
	*(var+(i2*(p->n[0])+i1)+(ivar*(p->n[0])*(p->n[1])))=gmpirecvbuffer[n+iside*gnmpibuffer];
#endif
      }
}




//!==============================================================================
//subroutine mpibound(nvar,var)
//
//! Fill in ghost cells of var(ixG,nvar) from other processors
//
//include 'vacdef.f'
//
//integer :: nvar
//double precision :: var(ixGlo1:ixGhi1,ixGlo2:ixGhi2,nvar)
//
//! processor indexes for left and right neighbors
//integer :: hpe,jpe
//! index limits for the left and right side mesh and ghost cells 
//integer :: ixLMmin1,ixLMmin2,ixLMmax1,ixLMmax2, ixRMmin1,ixRMmin2,ixRMmax1,&
//   ixRMmax2, ixLGmin1,ixLGmin2,ixLGmax1,ixLGmax2, ixRGmin1,ixRGmin2,ixRGmax1,&
//   ixRGmax2
//logical :: periodic
void mpibound(int nvar,  real *var, params *p)
{
   int i;

   int ixlgmin[NDIM],ixlgmax[NDIM];
   int ixrgmin[NDIM],ixrgmax[NDIM];

   int ixlmmin[NDIM],ixlmmax[NDIM];
   int ixrmmin[NDIM],ixrmmax[NDIM];



if((p->pnpe[0])>1)
{
   gnmpirequest=0;
   for(i=0; i<2; i++)
     gmpirequest[i]=MPI_REQUEST_NULL;
   //periodic=typeB(1,2*1)=='mpiperiod'
   //! Left and right side ghost cell regions (target)
   for(i=0;i<NDIM;i++)
   {
	ixlgmin[i]=0;
	ixlgmax[i]=(p->n[i])-1;
	ixrgmin[i]=0;
	ixrgmax[i]=(p->n[i])-1;
   }
      ixlgmax[0]=1;
   ixrgmin[0]=(p->n[0])-2;
   //! Left and right side mesh cell regions (source)
   for(i=0;i<NDIM;i++)
   {
	ixlmmin[i]=0;
	ixlmmax[i]=(p->n[i])-1;
	ixrmmin[i]=0;
	ixrmmax[i]=(p->n[i])-1;
   }
   ixlmmin[0]=2;   
   ixlmmax[0]=1;
   ixrmmax[0]=(p->n[0])-3;
   ixrmmin[0]=(p->n[0])-4; 
     //! Obtain left and right neighbor processors for this direction
   //call mpineighbors(1,hpe,jpe)
   //already computed initially use phpe pjpe arrays

   //! receive right (2) boundary from left neighbor hpe
   //if(mpilowerB(1) .or. periodic)call mpirecvbuffer(nvar,ixRMmin1,ixRMmin2,&
   //   ixRMmax1,ixRMmax2,hpe,2)
   if(((p->mpilowerb[0])==1) ||  ((p->boundtype[0][0])==0))
             mpirecvbuffer(nvar,ixrmmin,ixrmmax,p->phpe[0],1,p);
   //! receive left (1) boundary from right neighbor jpe
   //if(mpiupperB(1) .or. periodic)call mpirecvbuffer(nvar,ixLMmin1,ixLMmin2,&
   //   ixLMmax1,ixLMmax2,jpe,1)
   if(((p->mpiupperb[0])==1) ||  ((p->boundtype[0][0])==0))
             mpirecvbuffer(nvar,ixlmmin,ixlmmax,p->pjpe[0],0,p);
   //! Wait for all receives to be posted
   //call MPI_BARRIER(MPI_COMM_WORLD,ierrmpi)
   comm.Barrier();
   //! Ready send left (1) boundary to left neighbor hpe
   //if(mpilowerB(1) .or. periodic)call mpisend(nvar,var,ixLMmin1,ixLMmin2,&
   //   ixLMmax1,ixLMmax2,hpe,1)
   if(((p->mpilowerb[0])==1) ||  ((p->boundtype[0][0])==0))
             mpisend(nvar,var,ixlmmin,ixlmmax,p->phpe[0],0,p);
   //! Ready send right (2) boundary to right neighbor
   //if(mpiupperB(1) .or. periodic)call mpisend(nvar,var,ixRMmin1,ixRMmin2,&
   //   ixRMmax1,ixRMmax2,jpe,2)
   if(((p->mpiupperb[0])==1) ||  ((p->boundtype[0][0])==0))
             mpisend(nvar,var,ixrmmin,ixrmmax,p->pjpe[0],1,p);
   //! Wait for messages to arrive
   //call MPI_WAITALL(nmpirequest,mpirequests,mpistatus,ierrmpi)
   request.Waitall(gnmpirequest,gmpirequest);

   //! Copy buffer received from right (2) physical cells into left ghost cells
   //if(mpilowerB(1) .or. periodic)call mpibuffer2var(2,nvar,var,ixLGmin1,&
   //   ixLGmin2,ixLGmax1,ixLGmax2)
   if(((p->mpilowerb[0])==1) ||  ((p->boundtype[0][0])==0))
             mpibuffer2var(1,nvar,var,ixlgmin,ixlgmax,p);
   //! Copy buffer received from left (1) physical cells into right ghost cells
   //if(mpiupperB(1) .or. periodic)call mpibuffer2var(1,nvar,var,ixRGmin1,&
   //   ixRGmin2,ixRGmax1,ixRGmax2)
   if(((p->mpiupperb[0])==1) ||  ((p->boundtype[0][0])==0))
             mpibuffer2var(0,nvar,var,ixrgmin,ixrgmax,p);

}


if((p->pnpe[1])>1)
{
  gnmpirequest=0;  
  for(i=0; i<2; i++)
     gmpirequest[i]=MPI_REQUEST_NULL;
   //periodic=typeB(1,2*1)=='mpiperiod'
   //! Left and right side ghost cell regions (target)
   for(i=0;i<NDIM;i++)
   {
	ixlgmin[i]=0;
	ixlgmax[i]=(p->n[i])-1;
	ixrgmin[i]=0;
	ixrgmax[i]=(p->n[i])-1;
   }
   ixlgmax[1]=1;
   ixrgmin[1]=(p->n[1])-2;
   //! Left and right side mesh cell regions (source)
   for(i=0;i<NDIM;i++)
   {
	ixlmmin[i]=0;
	ixlmmax[i]=(p->n[i])-1;
	ixrmmin[i]=0;
	ixrmmax[i]=(p->n[i])-1;
   }
   ixlmmin[1]=2;   
   ixlmmax[1]=1;
   ixrmmax[1]=(p->n[1])-3;
   ixrmmin[1]=(p->n[1])-4; 
     //! Obtain left and right neighbor processors for this direction
   //call mpineighbors(1,hpe,jpe)
   //already computed initially use phpe pjpe arrays

   //! receive right (2) boundary from left neighbor hpe
   //if(mpilowerB(1) .or. periodic)call mpirecvbuffer(nvar,ixRMmin1,ixRMmin2,&
   //   ixRMmax1,ixRMmax2,hpe,2)
   if(((p->mpilowerb[1])==1) ||  ((p->boundtype[0][1])==0))
             mpirecvbuffer(nvar,ixrmmin,ixrmmax,p->phpe[1],1,p);
   //! receive left (1) boundary from right neighbor jpe
   //if(mpiupperB(1) .or. periodic)call mpirecvbuffer(nvar,ixLMmin1,ixLMmin2,&
   //   ixLMmax1,ixLMmax2,jpe,1)
   if(((p->mpiupperb[1])==1) ||  ((p->boundtype[0][1])==0))
             mpirecvbuffer(nvar,ixlmmin,ixlmmax,p->pjpe[1],0,p);
   //! Wait for all receives to be posted
   //call MPI_BARRIER(MPI_COMM_WORLD,ierrmpi)
   comm.Barrier();
   //! Ready send left (1) boundary to left neighbor hpe
   //if(mpilowerB(1) .or. periodic)call mpisend(nvar,var,ixLMmin1,ixLMmin2,&
   //   ixLMmax1,ixLMmax2,hpe,1)
   if(((p->mpilowerb[1])==1) ||  ((p->boundtype[0][1])==0))
             mpisend(nvar,var,ixlmmin,ixlmmax,p->phpe[1],0,p);
   //! Ready send right (2) boundary to right neighbor
   //if(mpiupperB(1) .or. periodic)call mpisend(nvar,var,ixRMmin1,ixRMmin2,&
   //   ixRMmax1,ixRMmax2,jpe,2)
   if(((p->mpiupperb[1])==1) ||  ((p->boundtype[0][1])==0))
             mpisend(nvar,var,ixrmmin,ixrmmax,p->pjpe[1],1,p);
   //! Wait for messages to arrive
   //call MPI_WAITALL(nmpirequest,mpirequests,mpistatus,ierrmpi)
   request.Waitall(gnmpirequest,gmpirequest);

   //! Copy buffer received from right (2) physical cells into left ghost cells
   //if(mpilowerB(1) .or. periodic)call mpibuffer2var(2,nvar,var,ixLGmin1,&
   //   ixLGmin2,ixLGmax1,ixLGmax2)
   if(((p->mpilowerb[1])==1) ||  ((p->boundtype[0][1])==0))
             mpibuffer2var(1,nvar,var,ixlgmin,ixlgmax,p);
   //! Copy buffer received from left (1) physical cells into right ghost cells
   //if(mpiupperB(1) .or. periodic)call mpibuffer2var(1,nvar,var,ixRGmin1,&
   //   ixRGmin2,ixRGmax1,ixRGmax2)
   if(((p->mpiupperb[1])==1) ||  ((p->boundtype[0][1])==0))
             mpibuffer2var(0,nvar,var,ixrgmin,ixrgmax,p);
}

#ifdef USE_SAC3D

if((p->pnpe[2])>1)
{
  gnmpirequest=0;  
  for(i=0; i<2; i++)
     gmpirequest[i]=MPI_REQUEST_NULL;
   //periodic=typeB(1,2*1)=='mpiperiod'
   //! Left and right side ghost cell regions (target)
   for(i=0;i<NDIM;i++)
   {
	ixlgmin[i]=0;
	ixlgmax[i]=(p->n[i])-1;
	ixrgmin[i]=0;
	ixrgmax[i]=(p->n[i])-1;
   }
   ixlgmax[2]=1;
   ixrgmin[2]=(p->n[2])-2;
   //! Left and right side mesh cell regions (source)
   for(i=0;i<NDIM;i++)
   {
	ixlmmin[i]=0;
	ixlmmax[i]=(p->n[i])-1;
	ixrmmin[i]=0;
	ixrmmax[i]=(p->n[i])-1;
   }
   ixlmmin[2]=2;   
   ixlmmax[2]=1;
   ixrmmax[2]=(p->n[2])-3;
   ixrmmin[2]=(p->n[2])-4; 
     //! Obtain left and right neighbor processors for this direction
   //call mpineighbors(1,hpe,jpe)
   //already computed initially use phpe pjpe arrays

   //! receive right (2) boundary from left neighbor hpe
   //if(mpilowerB(1) .or. periodic)call mpirecvbuffer(nvar,ixRMmin1,ixRMmin2,&
   //   ixRMmax1,ixRMmax2,hpe,2)
   if(((p->mpilowerb[2])==1) ||  ((p->boundtype[0][2])==0))
             mpirecvbuffer(nvar,ixrmmin,ixrmmax,p->phpe[2],1,p);
   //! receive left (1) boundary from right neighbor jpe
   //if(mpiupperB(1) .or. periodic)call mpirecvbuffer(nvar,ixLMmin1,ixLMmin2,&
   //   ixLMmax1,ixLMmax2,jpe,1)
   if(((p->mpiupperb[2])==1) ||  ((p->boundtype[0][2])==0))
             mpirecvbuffer(nvar,ixlmmin,ixlmmax,p->pjpe[2],0,p);
   //! Wait for all receives to be posted
   //call MPI_BARRIER(MPI_COMM_WORLD,ierrmpi)
   comm.Barrier();
   //! Ready send left (1) boundary to left neighbor hpe
   //if(mpilowerB(1) .or. periodic)call mpisend(nvar,var,ixLMmin1,ixLMmin2,&
   //   ixLMmax1,ixLMmax2,hpe,1)
   if(((p->mpilowerb[2])==1) ||  ((p->boundtype[0][2])==0))
             mpisend(nvar,var,ixlmmin,ixlmmax,p->phpe[2],0,p);
   //! Ready send right (2) boundary to right neighbor
   //if(mpiupperB(1) .or. periodic)call mpisend(nvar,var,ixRMmin1,ixRMmin2,&
   //   ixRMmax1,ixRMmax2,jpe,2)
   if(((p->mpiupperb[2])==1) ||  ((p->boundtype[0][2])==0))
             mpisend(nvar,var,ixrmmin,ixrmmax,p->pjpe[2],1,p);
   //! Wait for messages to arrive
   //call MPI_WAITALL(nmpirequest,mpirequests,mpistatus,ierrmpi)
   request.Waitall(gnmpirequest,gmpirequest);

   //! Copy buffer received from right (2) physical cells into left ghost cells
   //if(mpilowerB(1) .or. periodic)call mpibuffer2var(2,nvar,var,ixLGmin1,&
   //   ixLGmin2,ixLGmax1,ixLGmax2)
   if(((p->mpilowerb[2])==1) ||  ((p->boundtype[0][2])==0))
             mpibuffer2var(1,nvar,var,ixlgmin,ixlgmax,p);
   //! Copy buffer received from left (1) physical cells into right ghost cells
   //if(mpiupperB(1) .or. periodic)call mpibuffer2var(1,nvar,var,ixRGmin1,&
   //   ixRGmin2,ixRGmax1,ixRGmax2)
   if(((p->mpiupperb[2])==1) ||  ((p->boundtype[0][2])==0))
             mpibuffer2var(0,nvar,var,ixrgmin,ixrgmax,p);
}


#endif


}


//!=============================================================================
//subroutine mpireduce(a,mpifunc)
//
//! reduce input for one PE 0 using mpifunc
//
//include 'mpif.h'
//
//double precision :: a, alocal
//integer          :: mpifunc, ierrmpi
//!----------------------------------------------------------------------------
//alocal = a
//call MPI_REDUCE(alocal,a,1,MPI_DOUBLE_PRECISION,mpifunc,0,MPI_COMM_WORLD,&
//   ierrmpi)
void mpireduce(real *a, MPI::Op mpifunc)
{
  real *alocal;

   *alocal=*a;
   comm.Reduce(alocal, a, 1, MPI_DOUBLE_PRECISION, mpifunc, 0);

}



//!==============================================================================
//subroutine mpiallreduce(a,mpifunc)
//
//! reduce input onto all PE-s using mpifunc
//
//include 'mpif.h'
//
//double precision :: a, alocal
//integer          :: mpifunc, ierrmpi
//!-----------------------------------------------------------------------------
//alocal = a
//call MPI_ALLREDUCE(alocal,a,1,MPI_DOUBLE_PRECISION,mpifunc,MPI_COMM_WORLD,&
//   ierrmpi)
void mpiallreduce(real *a, MPI::Op mpifunc)
{
   real *alocal;

   *alocal=*a;
   comm.Allreduce(alocal, a, 1, MPI_DOUBLE_PRECISION, mpifunc);

}

//update viscosity term
void mpivisc( int idim,params *p, real *temp2)
{
   comm.Barrier();
   int i,n;
   int i1,i2,i3;
   i3=0;
   #ifdef USE_SAC3D
   n=(p->n[0])*(p->n[1])*(p->n[2]);
   switch(idim)
   {
               case 0:
                    n/=(p->n[0]);
                    break;
               case 1:
                    n/=(p->n[1]);
                    break;
               case 2:
                    n/=(p->n[2]);
                    break;               
               }
   #else
   n=(p->n[0])*(p->n[1]);

   switch(idim)
   {
               case 0:
                    n/=(p->n[0]);
                    break;
               case 1:
                    n/=(p->n[1]);
                    break;           
               }   
   #endif
   

   switch(idim)
   {
   case 0:
     gnmpirequest=0;  
  for(i=0; i<2; i++)
     gmpirequest[i]=MPI_REQUEST_NULL;
     
        if((p->mpiupperb[idim])==1) gnmpirequest++;
        if((p->mpiupperb[idim])==1) gmpirequest[gnmpirequest]=comm.Irecv(gmpitgtbufferr[0],n,MPI_DOUBLE_PRECISION,p->pjpe[idim],10*(p->pjpe[idim]));
        if((p->mpilowerb[idim])==1) gnmpirequest++;
        if((p->mpilowerb[idim])==1) gmpirequest[gnmpirequest]=comm.Irecv(gmpitgtbufferl[0],n,MPI_DOUBLE_PRECISION,p->phpe[idim],10*(p->phpe[idim])+1);
        comm.Barrier();
          
        if((p->mpiupperb[idim])==1) comm.Rsend(gmpisrcbufferr[0], n, MPI_DOUBLE_PRECISION, p->pjpe[idim], 10*(p->ipe)+1);
        if((p->mpilowerb[idim])==1) comm.Rsend(gmpisrcbufferl[0], n, MPI_DOUBLE_PRECISION, p->phpe[idim], 10*(p->ipe));
     
        request.Waitall(gnmpirequest,gmpirequest);

  
        //copy data from buffer to the viscosity data in temp2
        //organise buffers so that pointers are swapped instead

        #ifdef USE_SAC3D
   //tmp_nuI(ixFhi1+1,ixFlo2:ixFhi2,ixFlo3:ixFhi3)=tgtbufferR1(1,ixFlo2:ixFhi2,&
   //   ixFlo3:ixFhi3) !right, upper R
   //tmp_nuI(ixFlo1-1,ixFlo2:ixFhi2,ixFlo3:ixFhi3)=tgtbufferL1(1,ixFlo2:ixFhi2,&
   //   ixFlo3:ixFhi3) !left, lower  L
         for(i2=1;i2<((p->n[1])+2);i2++ )
                  for(i3=1;i3<((p->n[2])+2);i3++ )
         {
          i1=(p->n[0])+1;
         
          temp2[encode3p2_sacmpi (p,i1, i2, i3, tmpnui)]=gmpitgtbufferr[0][i2+i3*((p->n[1])+2)];
          temp2[encode3p2_sacmpi (p,0, i2, i3, tmpnui)]=gmpitgtbufferl[0][i2+i3*((p->n[1])+2)];
          }




        #else
        //tmp_nuI(ixFhi1+1,ixFlo2:ixFhi2)=tgtbufferR1(1,ixFlo2:ixFhi2) !right, upper R
        //tmp_nuI(ixFlo1-1,ixFlo2:ixFhi2)=tgtbufferL1(1,ixFlo2:ixFhi2) !left, lower  L
                  for(i2=1;i2<((p->n[1])+2);i2++ )
         {
          i1=(p->n[0])+1;
         
          temp2[encode3p2_sacmpi (p,i1, i2, i3, tmpnui)]=gmpitgtbufferr[0][i2];
          temp2[encode3p2_sacmpi (p,0, i2, i3, tmpnui)]=gmpitgtbufferl[0][i2];
          }

 
         
        #endif

        

     break;
     
        case 1:
     gnmpirequest=0;  
  for(i=0; i<2; i++)
     gmpirequest[i]=MPI_REQUEST_NULL;
     
             if((p->mpiupperb[idim])==1) gnmpirequest++;
        if((p->mpiupperb[idim])==1) gmpirequest[gnmpirequest]=comm.Irecv(gmpitgtbufferr[1],n,MPI_DOUBLE_PRECISION,p->pjpe[idim],10*(p->pjpe[idim]));
        if((p->mpilowerb[idim])==1) gnmpirequest++;
        if((p->mpilowerb[idim])==1) gmpirequest[gnmpirequest]=comm.Irecv(gmpitgtbufferl[1],n,MPI_DOUBLE_PRECISION,p->phpe[idim],10*(p->phpe[idim])+1);
        comm.Barrier();
          
        if((p->mpiupperb[idim])==1) comm.Rsend(gmpisrcbufferr[1], n, MPI_DOUBLE_PRECISION, p->pjpe[idim], 10*(p->ipe)+1);
        if((p->mpilowerb[idim])==1) comm.Rsend(gmpisrcbufferl[1], n, MPI_DOUBLE_PRECISION, p->phpe[idim], 10*(p->ipe));
     
        request.Waitall(gnmpirequest,gmpirequest);
      #ifdef USE_SAC3D
  //tmp_nuI(ixFlo1:ixFhi1,ixFhi2+1,ixFlo3:ixFhi3)=tgtbufferR2(ixFlo1:ixFhi1,1,&
  //    ixFlo3:ixFhi3) !right, upper R
  // tmp_nuI(ixFlo1:ixFhi1,ixFlo2-1,ixFlo3:ixFhi3)=tgtbufferL2(ixFlo1:ixFhi1,1,&
   //   ixFlo3:ixFhi3) !left, lower  L
         for(i1=1;i1<((p->n[0])+2);i1++ )
                  for(i3=1;i3<((p->n[2])+2);i3++ )
         {
          i2=(p->n[1])+1;
         
          temp2[encode3p2_sacmpi (p,i1, i2, i3, tmpnui)]=gmpitgtbufferr[1][i1+i3*((p->n[0])+2)];
          temp2[encode3p2_sacmpi (p,i1, 0, i3, tmpnui)]=gmpitgtbufferl[1][i1+i3*((p->n[0])+2)];
          }


     #else
       // tmp_nuI(ixFlo1:ixFhi1,ixFhi2+1)=tgtbufferR2(ixFlo1:ixFhi1,1) !right, upper R
   //tmp_nuI(ixFlo1:ixFhi1,ixFlo2-1)=tgtbufferL2(ixFlo1:ixFhi1,1) !left, lower  L
                  for(i1=1;i1<((p->n[0])+2);i1++ )
         {
          i2=(p->n[1])+1;
         
          temp2[encode3p2_sacmpi (p,i1, i2, i3, tmpnui)]=gmpitgtbufferr[1][i1];
          temp2[encode3p2_sacmpi (p,i1, 0, i3, tmpnui)]=gmpitgtbufferl[1][i1];
          }

      #endif
     break;
     #ifdef USE_SAC3D
        case 2:
     gnmpirequest=0;  
  for(i=0; i<2; i++)
     gmpirequest[i]=MPI_REQUEST_NULL;
     
             if((p->mpiupperb[idim])==1) gnmpirequest++;
        if((p->mpiupperb[idim])==1) gmpirequest[gnmpirequest]=comm.Irecv(gmpitgtbufferr[2],n,MPI_DOUBLE_PRECISION,p->pjpe[idim],10*(p->pjpe[idim]));
        if((p->mpilowerb[idim])==1) gnmpirequest++;
        if((p->mpilowerb[idim])==1) gmpirequest[gnmpirequest]=comm.Irecv(gmpitgtbufferl[2],n,MPI_DOUBLE_PRECISION,p->phpe[idim],10*(p->phpe[idim])+1);
        comm.Barrier();
          
        if((p->mpiupperb[idim])==1) comm.Rsend(gmpisrcbufferr[2], n, MPI_DOUBLE_PRECISION, p->pjpe[idim], 10*(p->ipe)+1);
        if((p->mpilowerb[idim])==1) comm.Rsend(gmpisrcbufferl[2], n, MPI_DOUBLE_PRECISION, p->phpe[idim], 10*(p->ipe));
     
        request.Waitall(gnmpirequest,gmpirequest);
   //  tmp_nuI(ixFlo1:ixFhi1,ixFlo2:ixFhi2,ixFhi3+1)=tgtbufferR3(ixFlo1:ixFhi1,&
   //   ixFlo2:ixFhi2,1) !right, upper R

   //tmp_nuI(ixFlo1:ixFhi1,ixFlo2:ixFhi2,ixFlo3-1)=tgtbufferL3(ixFlo1:ixFhi1,&
   //   ixFlo2:ixFhi2,1) !left, lower  L
        for(i1=1;i1<((p->n[0])+2);i1++ )
                  for(i2=1;i2<((p->n[1])+2);i2++ )
         {
          i3=(p->n[2])+1;
         
          temp2[encode3p2_sacmpi (p,i1, i2, i3, tmpnui)]=gmpitgtbufferr[2][i1+i2*((p->n[0])+2)];
          temp2[encode3p2_sacmpi (p,i1, i2, 0, tmpnui)]=gmpitgtbufferl[2][i1+i2*((p->n[0])+2)];
          }

     
     break;
     #endif
   
  }
   comm.Barrier();
}






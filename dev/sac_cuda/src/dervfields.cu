

__device__ __host__
void computej_MODID(real *wmod,real *wd,struct params *p,int i,int j)
{
 // int status=0;

 // real dbzdy, dbydz;
 // real dbzdx, dbxdz;
 // real dbydx, dbxdy;

 // dbzdy=grad_MODID(wmod,p,i,j,b3,1);
 // dbydz=0.0;
 // dbzdx=grad_MODID(wmod,p,i,j,b3,0);
//  dbxdz=0.0;
 // dbydx=grad_MODID(wmod,p,i,j,b2,0);
 // dbxdy=grad_MODID(wmod,p,i,j,b1,1);

 /* wd[fencode_MODID(p,i,j,current1)]=(grad_MODID(wmod,p,i,j,b3,1))/(p->mu);
  wd[fencode_MODID(p,i,j,current2)]=(grad_MODID(wmod,p,i,j,b3,0))/(p->mu);
  wd[fencode_MODID(p,i,j,current3)]=(grad_MODID(wmod,p,i,j,b2,0)-grad_MODID(wmod,p,i,j,b1,1))/(p->mu);*/
  
          #ifdef USE_SAC
	 /* wd[fencode_MODID(p,i,j,current1)]+=(grad_MODID(wmod,p,i,j,b3b,1))/(p->mu);
	  wd[fencode_MODID(p,i,j,current2)]+=(grad_MODID(wmod,p,i,j,b3b,0))/(p->mu);
	  wd[fencode_MODID(p,i,j,current3)]+=(grad_MODID(wmod,p,i,j,b2b,0)-grad_MODID(wmod,p,i,j,b1b,1))/(p->mu);*/


         #endif

 
  //return ( status);
}

__device__ __host__
void computebdotv_MODID(real *wmod,real *wd,struct params *p,int i,int j)
{
        #ifdef USE_SAC

//wd[fencode_MODID(p,i,j,bdotv)]=((wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b1b)])*wmod[fencode_MODID(p,i,j,mom1)]+(wmod[fencode_MODID(p,i,j,b2)]+wmod[fencode_MODID(p,i,j,b2b)])*wmod[fencode_MODID(p,i,j,mom2)]+(wmod[fencode_MODID(p,i,j,b3)]+wmod[fencode_MODID(p,i,j,b3b)])*wmod[fencode_MODID(p,i,j,mom3)])/(wmod[fencode_MODID(p,i,j,rho)]+wmod[fencode_MODID(p,i,j,rhob)]);
wd[fencode_MODID(p,i,j,bdotv)]=((wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b1b)])*wmod[fencode_MODID(p,i,j,mom1)]+(wmod[fencode_MODID(p,i,j,b2)]+wmod[fencode_MODID(p,i,j,b2b)])*wmod[fencode_MODID(p,i,j,mom2)])/(wmod[fencode_MODID(p,i,j,rho)]+wmod[fencode_MODID(p,i,j,rhob)]);
         #else
//wd[fencode_MODID(p,i,j,bdotv)]=(wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,mom1)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,mom2)]+wmod[fencode_MODID(p,i,j,b3)]*wmod[fencode_MODID(p,i,j,mom3)])/wmod[fencode_MODID(p,i,j,rho)];
wd[fencode_MODID(p,i,j,bdotv)]=(wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,mom1)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,mom2)])/wmod[fencode_MODID(p,i,j,rho)];
         #endif
 // return ( status);
}

__device__ __host__
void computedivb_MODID(real *wmod,real *wd,struct params *p,int i,int j)
{


wd[fencode_MODID(p,i,j,divb)]=grad_MODID(wmod,p,i,j,b1,0)+grad_MODID(wmod,p,i,j,b2,1);
        #ifdef USE_SAC
		wd[fencode_MODID(p,i,j,divb)]+=grad_MODID(wmod,p,i,j,b1b,0)+grad_MODID(wmod,p,i,j,b2b,1);
         #endif
 // return ( status);
}

__device__ __host__
void computevel_MODID(real *wmod,real *wd,struct params *p,int i,int j)
{



        #ifdef USE_SAC
		wd[fencode_MODID(p,i,j,vel1)]=wmod[fencode_MODID(p,i,j,mom1)]/(wmod[fencode_MODID(p,i,j,rho)]+wmod[fencode_MODID(p,i,j,rhob)]);
                wd[fencode_MODID(p,i,j,vel2)]=wmod[fencode_MODID(p,i,j,mom2)]/(wmod[fencode_MODID(p,i,j,rho)]+wmod[fencode_MODID(p,i,j,rhob)]);
         #else
		wd[fencode_MODID(p,i,j,vel1)]=wmod[fencode_MODID(p,i,j,mom1)]/(wmod[fencode_MODID(p,i,j,rho)]);
                wd[fencode_MODID(p,i,j,vel2)]=wmod[fencode_MODID(p,i,j,mom2)]/(wmod[fencode_MODID(p,i,j,rho)]);

         #endif
 // return ( status);
}

__device__ __host__
void computept_MODID(real *wmod,real *wd,struct params *p,int i,int j)
{
 // int status=0;

#ifdef ADIABHYDRO

/*below used for adiabatic hydrodynamics*/
 wd[fencode_MODID(p,i,j,pressuret)]=(p->adiab)*pow(wmod[fencode_MODID(p,i,j,rho)],p->gamma);
// wd[fencode_MODID(p,i,j,pressuret)]=(p->adiab)*wmod[fencode_MODID(p,i,j,rho)]*wmod[fencode_MODID(p,i,j,rho)];
//wd[fencode_MODID(p,i,j,pressuret)]=1.0;
#elif defined(USE_SAC)
 
 //wd[fencode_MODID(p,i,j,pressuret)]=  ((p->gamma)-2)*((wmod[fencode_MODID(p,i,j,b1b)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2b)]*wmod[fencode_MODID(p,i,j,b2)]))+0.5*(wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,b2)]);

//wd[fencode_MODID(p,i,j,pressuret)]= ((p->gamma)-1)*(wmod[fencode_MODID(p,i,j,energy)]-0.5*(wmod[fencode_MODID(p,i,j,mom1)]*wmod[fencode_MODID(p,i,j,mom1)]+wmod[fencode_MODID(p,i,j,mom2)]*wmod[fencode_MODID(p,i,j,mom2)])/(wmod[fencode_MODID(p,i,j,rho)]+wmod[fencode_MODID(p,i,j,rhob)]))-wd[fencode_MODID(p,i,j,pressuret)];



wd[fencode_MODID(p,i,j,pressuret)]=((p->gamma)-1.0)*( wmod[fencode_MODID(p,i,j,energy)]-0.5*(wmod[fencode_MODID(p,i,j,mom1)]*wmod[fencode_MODID(p,i,j,mom1)]+wmod[fencode_MODID(p,i,j,mom2)]*wmod[fencode_MODID(p,i,j,mom2)])/(wmod[fencode_MODID(p,i,j,rho)]+wmod[fencode_MODID(p,i,j,rhob)]));
wd[fencode_MODID(p,i,j,pressuret)]=wd[fencode_MODID(p,i,j,pressuret)]-((p->gamma)-2.0)*((wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,b1b)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,b2b)])+0.5*(wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,b2)]));

 

 wd[fencode_MODID(p,i,j,ptb)]=  ((p->gamma)-1)*wmod[fencode_MODID(p,i,j,energyb)]- 0.5*((p->gamma)-2)*(wmod[fencode_MODID(p,i,j,b1b)]*wmod[fencode_MODID(p,i,j,b1b)]+wmod[fencode_MODID(p,i,j,b2b)]*wmod[fencode_MODID(p,i,j,b2b)]) ;


#else

 

 //wd[fencode_MODID(p,i,j,pressuret)]=  ((p->gamma)-1.0)*wmod[fencode_MODID(p,i,j,energy)]+(1.0-0.5*(p->gamma))*(wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,b2)])+0.5*(1.0-(p->gamma))*(wmod[fencode_MODID(p,i,j,mom1)]*wmod[fencode_MODID(p,i,j,mom1)]+wmod[fencode_MODID(p,i,j,mom2)]*wmod[fencode_MODID(p,i,j,mom2)])/wmod[fencode_MODID(p,i,j,rho)];

wd[fencode_MODID(p,i,j,pressuret)]=  ((p->gamma)-1.0)*wmod[fencode_MODID(p,i,j,energy)]+(1.0-0.5*(p->gamma))*(wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,b2)])+0.5*(1.0-(p->gamma))*(wmod[fencode_MODID(p,i,j,mom1)]*wmod[fencode_MODID(p,i,j,mom1)]+wmod[fencode_MODID(p,i,j,mom2)]*wmod[fencode_MODID(p,i,j,mom2)])/wmod[fencode_MODID(p,i,j,rho)];

#endif



  if(wd[fencode_MODID(p,i,j,pressuret)]<0)
              wd[fencode_MODID(p,i,j,pressuret)]=0.001;


 // return ( status);
}
__device__ __host__
void computepk_MODID(real *wmod,real *wd,struct params *p,int i,int j)
{
  //int status=0;

#ifdef ADIABHYDRO

/*below used for adiabatic hydrodynamics*/
wd[fencode_MODID(p,i,j,pressurek)]=(p->adiab)*pow(wmod[fencode_MODID(p,i,j,rho)],p->gamma);
wd[fencode_MODID(p,i,j,vel1)]=wmod[fencode_MODID(p,i,j,mom1)]/(wmod[fencode_MODID(p,i,j,rho)]);
wd[fencode_MODID(p,i,j,vel2)]=wmod[fencode_MODID(p,i,j,mom2)]/(wmod[fencode_MODID(p,i,j,rho)]);
//wd[fencode_MODID(p,i,j,vel3)]=wmod[fencode_MODID(p,i,j,mom3)]/(wmod[fencode_MODID(p,i,j,rho)]);
#elif defined(USE_SAC)

//wd[fencode_MODID(p,i,j,vel1)]=wmod[fencode_MODID(p,i,j,mom1)]/(wmod[fencode_MODID(p,i,j,rho)]+wmod[fencode_MODID(p,i,j,rhob)]);
//wd[fencode_MODID(p,i,j,vel2)]=wmod[fencode_MODID(p,i,j,mom2)]/(wmod[fencode_MODID(p,i,j,rho)]+wmod[fencode_MODID(p,i,j,rhob)]);
//wd[fencode_MODID(p,i,j,vel3)]=wmod[fencode_MODID(p,i,j,mom3)]/(wmod[fencode_MODID(p,i,j,rho)]+wmod[fencode_MODID(p,i,j,rhob)]);

// wd[fencode_MODID(p,i,j,pressurek)]=((p->gamma)-1)*(wmod[fencode_MODID(p,i,j,energy)]- 0.5*(wmod[fencode_MODID(p,i,j,mom1)]*wmod[fencode_MODID(p,i,j,mom1)]+wmod[fencode_MODID(p,i,j,mom2)]*wmod[fencode_MODID(p,i,j,mom2)]+wmod[fencode_MODID(p,i,j,mom3)]*wmod[fencode_MODID(p,i,j,mom3)])-0.5*(wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,b2)]+wmod[fencode_MODID(p,i,j,b3)]*wmod[fencode_MODID(p,i,j,b3)]) -(wmod[fencode_MODID(p,i,j,b1b)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2b)]*wmod[fencode_MODID(p,i,j,b2)]+wmod[fencode_MODID(p,i,j,b3b)]*wmod[fencode_MODID(p,i,j,b3)]) );
 wd[fencode_MODID(p,i,j,pressurek)]=((p->gamma)-1)*(wmod[fencode_MODID(p,i,j,energy)]
- 0.5*((wmod[fencode_MODID(p,i,j,mom1)]*wmod[fencode_MODID(p,i,j,mom1)]+wmod[fencode_MODID(p,i,j,mom2)]*wmod[fencode_MODID(p,i,j,mom2)])/(wmod[fencode_MODID(p,i,j,rho)]+wmod[fencode_MODID(p,i,j,rhob)]))-0.5*(wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,b2)]) -(wmod[fencode_MODID(p,i,j,b1b)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2b)]*wmod[fencode_MODID(p,i,j,b2)]) );

//wd[fencode_MODID(p,i,j,pkb)]=((p->gamma)-1)*(wmod[fencode_MODID(p,i,j,energyb)]- 0.5*(wmod[fencode_MODID(p,i,j,b1b)]*wmod[fencode_MODID(p,i,j,b1b)]+wmod[fencode_MODID(p,i,j,b2b)]*wmod[fencode_MODID(p,i,j,b2b)]+wmod[fencode_MODID(p,i,j,b3b)]*wmod[fencode_MODID(p,i,j,b3b)]) );
wd[fencode_MODID(p,i,j,pkb)]=((p->gamma)-1)*(wmod[fencode_MODID(p,i,j,energyb)]- 0.5*(wmod[fencode_MODID(p,i,j,b1b)]*wmod[fencode_MODID(p,i,j,b1b)]+wmod[fencode_MODID(p,i,j,b2b)]*wmod[fencode_MODID(p,i,j,b2b)]) );

#else
//wd[fencode_MODID(p,i,j,vel1)]=wmod[fencode_MODID(p,i,j,mom1)]/(wmod[fencode_MODID(p,i,j,rho)]);
//wd[fencode_MODID(p,i,j,vel2)]=wmod[fencode_MODID(p,i,j,mom2)]/(wmod[fencode_MODID(p,i,j,rho)]);
//wd[fencode_MODID(p,i,j,vel3)]=wmod[fencode_MODID(p,i,j,mom3)]/(wmod[fencode_MODID(p,i,j,rho)]);

 // wd[fencode_MODID(p,i,j,pressurek)]=((p->gamma)-1)*(wmod[fencode_MODID(p,i,j,energy)]- 0.5*(wmod[fencode_MODID(p,i,j,mom1)]*wmod[fencode_MODID(p,i,j,mom1)]+wmod[fencode_MODID(p,i,j,mom2)]*wmod[fencode_MODID(p,i,j,mom2)]+wmod[fencode_MODID(p,i,j,mom3)]*wmod[fencode_MODID(p,i,j,mom3)])/wmod[fencode_MODID(p,i,j,rho)]-0.5*(wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,b2)]+wmod[fencode_MODID(p,i,j,b3)]*wmod[fencode_MODID(p,i,j,b3)]) );
 wd[fencode_MODID(p,i,j,pressurek)]=((p->gamma)-1)*(wmod[fencode_MODID(p,i,j,energy)]- 0.5*(wmod[fencode_MODID(p,i,j,mom1)]*wmod[fencode_MODID(p,i,j,mom1)]+wmod[fencode_MODID(p,i,j,mom2)]*wmod[fencode_MODID(p,i,j,mom2)])/wmod[fencode_MODID(p,i,j,rho)]-0.5*(wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,b2)]) );


#endif






  if(wd[fencode_MODID(p,i,j,pressurek)]<0)
              wd[fencode_MODID(p,i,j,pressurek)]=0.001;
  //return ( status);
}

__device__ __host__
void computec_MODID(real *wmod,real *wd,struct params *p,int i,int j)
{

  
#ifdef ADIABHYDRO
/*below used for adiabatic hydrodynamics*/
  wd[fencode_MODID(p,i,j,soundspeed)]=sqrt((p->adiab)/wmod[fencode_MODID(p,i,j,rho)]);
#elif defined(USE_SAC)
//wd[fencode_MODID(p,i,j,soundspeed)]=sqrt((  (p->gamma))*(wd[fencode_MODID(p,i,j,pressuret)]+wd[fencode_MODID(p,i,j,ptb)])/(wmod[fencode_MODID(p,i,j,rho)]+wmod[fencode_MODID(p,i,j,rhob)]   ));


wd[fencode_MODID(p,i,j,soundspeed)]=sqrt(((p->gamma))*(wd[fencode_MODID(p,i,j,pressurek)]+(((p->gamma))-1)*(wmod[fencode_MODID(p,i,j,energyb)] -0.5*(wmod[fencode_MODID(p,i,j,b1b)]*wmod[fencode_MODID(p,i,j,b1b)]+wmod[fencode_MODID(p,i,j,b2b)]*wmod[fencode_MODID(p,i,j,b2b)]))/(wmod[fencode_MODID(p,i,j,rho)]+wmod[fencode_MODID(p,i,j,rhob)]   )));


wd[fencode_MODID(p,i,j,cfast)]=sqrt((   ( 
(wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,b2)]) + (wmod[fencode_MODID(p,i,j,b1b)]*wmod[fencode_MODID(p,i,j,b1b)]+wmod[fencode_MODID(p,i,j,b2b)]*wmod[fencode_MODID(p,i,j,b2b)]) +2.0*(wmod[fencode_MODID(p,i,j,b1b)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2b)]*wmod[fencode_MODID(p,i,j,b2)])    )/(wmod[fencode_MODID(p,i,j,rho)]+wmod[fencode_MODID(p,i,j,rhob)]))
+(wd[fencode_MODID(p,i,j,soundspeed)]*wd[fencode_MODID(p,i,j,soundspeed)]));

#else
wd[fencode_MODID(p,i,j,soundspeed)]=sqrt(((p->gamma))*wd[fencode_MODID(p,i,j,pressuret)]/wmod[fencode_MODID(p,i,j,rho)]);
//wd[fencode_MODID(p,i,j,cfast)]=sqrt(((wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,b2)]+wmod[fencode_MODID(p,i,j,b3)]*wmod[fencode_MODID(p,i,j,b3)])/wmod[fencode_MODID(p,i,j,rho)])+(wd[fencode_MODID(p,i,j,soundspeed)]*wd[fencode_MODID(p,i,j,soundspeed)]));

wd[fencode_MODID(p,i,j,cfast)]=sqrt(((wmod[fencode_MODID(p,i,j,b1)]*wmod[fencode_MODID(p,i,j,b1)]+wmod[fencode_MODID(p,i,j,b2)]*wmod[fencode_MODID(p,i,j,b2)])/wmod[fencode_MODID(p,i,j,rho)])+(wd[fencode_MODID(p,i,j,soundspeed)]*wd[fencode_MODID(p,i,j,soundspeed)]));

#endif



  
}

__device__ __host__
void computecmax_MODID(real *wmod,real *wd,struct params *p,int i,int j)
{
 //p->cmax=0.02;
#ifdef ADIABHYDRO
       if(wd[fencode_MODID(p,i,j,soundspeed)]>(p->cmax))
                    // atomicExch(&(p->cmax),(wd[fencode_MODID(p,i,j,soundspeed)]));
                    p->cmax=(wd[fencode_MODID(p,i,j,soundspeed)]);
#else
       if(wd[fencode_MODID(p,i,j,soundspeed)]>(p->cmax))
                    // atomicExch(&(p->cmax),(wd[fencode_MODID(p,i,j,soundspeed)]));
                    p->cmax=(wd[fencode_MODID(p,i,j,soundspeed)]);
       if(wd[fencode_MODID(p,i,j,cfast)]>(p->cmax))
                    // atomicExch(&(p->cmax),(wd[fencode_MODID(p,i,j,soundspeed)]));
                    p->cmax=(wd[fencode_MODID(p,i,j,cfast)]);
#endif

}


//*******************************************************************************************************
//3d equivalents
//*******************************************************************************************************


__device__ __host__
void computej3_MODID(real *wmod,real *wd,struct params *p,int *ii)
{


 /* wd[fencode3_MODID(p,ii,current1)]=(grad3d_MODID(wmod,p,ii,b3,1))/(p->mu);
  wd[fencode3_MODID(p,ii,current2)]=(grad3d_MODID(wmod,p,ii,b3,0))/(p->mu);
  wd[fencode3_MODID(p,ii,current3)]=(grad3d_MODID(wmod,p,ii,b2,0)-grad3d_MODID(wmod,p,ii,b1,1))/(p->mu);*/
  
          #ifdef USE_SAC
	 /* wd[fencode3_MODID(p,ii,current1)]+=(grad3d_MODID(wmod,p,ii,b3b,1))/(p->mu);
	  wd[fencode3_MODID(p,ii,current2)]+=(grad3d_MODID(wmod,p,ii,b3b,0))/(p->mu);
	  wd[fencode3_MODID(p,ii,current3)]+=(grad3d_MODID(wmod,p,ii,b2b,0)-grad3d_MODID(wmod,p,ii,b1b,1))/(p->mu);*/
         #endif

          #ifdef USE_SAC_3D

         /* wd[fencode3_MODID(p,ii,current1)]-=(  (grad3d_MODID(wmod,p,ii,b2b,2))+ (grad3d_MODID(wmod,p,ii,b2,2)) )/(p->mu)
          wd[fencode3_MODID(p,ii,current2)]+=(  (grad3d_MODID(wmod,p,ii,b1b,2))+ (grad3d_MODID(wmod,p,ii,b1,2)) )/(p->mu)*/

	 /* wd[fencode3_MODID(p,ii,current1)]+=(grad3d_MODID(wmod,p,ii,b3b,1))/(p->mu);
	  wd[fencode3_MODID(p,ii,current2)]+=(grad3d_MODID(wmod,p,ii,b3b,0))/(p->mu);
	  wd[fencode3_MODID(p,ii,current3)]+=(grad3d_MODID(wmod,p,ii,b2b,0)-grad3d_MODID(wmod,p,ii,b1b,1))/(p->mu);*/
         #endif

}

__device__ __host__
void computebdotv3_MODID(real *wmod,real *wd,struct params *p,int *ii)
{
        #ifdef USE_SAC


wd[fencode3_MODID(p,ii,bdotv)]=((wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b1b)])*wmod[fencode3_MODID(p,ii,mom1)]+(wmod[fencode3_MODID(p,ii,b2)]+wmod[fencode3_MODID(p,ii,b2b)])*wmod[fencode3_MODID(p,ii,mom2)])/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]);

         #endif
        #ifdef USE_SAC_3D


wd[fencode3_MODID(p,ii,bdotv)]=((wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b1b)])*wmod[fencode3_MODID(p,ii,mom1)]+(wmod[fencode3_MODID(p,ii,b2)]+wmod[fencode3_MODID(p,ii,b2b)])*wmod[fencode3_MODID(p,ii,mom2)]+(wmod[fencode3_MODID(p,ii,b3)]+wmod[fencode3_MODID(p,ii,b3b)])*wmod[fencode3_MODID(p,ii,mom3)])/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]);

         #endif
 // return ( status);
}

__device__ __host__
void computedivb3_MODID(real *wmod,real *wd,struct params *p,int *ii)
{
      #ifdef USE_SAC

		wd[fencode3_MODID(p,ii,divb)]=grad3d_MODID(wmod,p,ii,b1,0)+grad3d_MODID(wmod,p,ii,b2,1);
		wd[fencode3_MODID(p,ii,divb)]+=grad3d_MODID(wmod,p,ii,b1b,0)+grad3d_MODID(wmod,p,ii,b2b,1);
        #endif
        #ifdef USE_SAC_3D
		wd[fencode3_MODID(p,ii,divb)]=grad3d_MODID(wmod,p,ii,b2,2);
		wd[fencode3_MODID(p,ii,divb)]+=grad3d_MODID(wmod,p,ii,b2b,2);		
         #endif
 // return ( status);
}

__device__ __host__
void computevel3_MODID(real *wmod,real *wd,struct params *p,int *ii)
{

        #ifdef USE_SAC_3D
		wd[fencode3_MODID(p,ii,vel1)]=wmod[fencode3_MODID(p,ii,mom1)]/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]);
                wd[fencode3_MODID(p,ii,vel2)]=wmod[fencode3_MODID(p,ii,mom2)]/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]);
                wd[fencode3_MODID(p,ii,vel3)]=wmod[fencode3_MODID(p,ii,mom3)]/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]);
        #endif

        #ifdef USE_SAC
		wd[fencode3_MODID(p,ii,vel1)]=wmod[fencode3_MODID(p,ii,mom1)]/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]);
                wd[fencode3_MODID(p,ii,vel2)]=wmod[fencode3_MODID(p,ii,mom2)]/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]);
        #endif
       #ifdef ADIABHYDRO
		wd[fencode3_MODID(p,ii,vel1)]=wmod[fencode3_MODID(p,ii,mom1)]/(wmod[fencode3_MODID(p,ii,rho)]);
                wd[fencode3_MODID(p,ii,vel2)]=wmod[fencode3_MODID(p,ii,mom2)]/(wmod[fencode3_MODID(p,ii,rho)]);

         #endif
 // return ( status);
}







__device__ __host__
void computept3_MODID(real *wmod,real *wd,struct params *p,int *ii)
{
 // int status=0;

#ifdef ADIABHYDRO

/*below used for adiabatic hydrodynamics*/
 wd[fencode3_MODID(p,ii,pressuret)]=(p->adiab)*pow(wmod[fencode3_MODID(p,ii,rho)],p->gamma);

#elif defined(USE_SAC)
 wmod[fencode3_MODID(p,ii,b1b)]=0;
 wmod[fencode3_MODID(p,ii,b2b)]=0;

wd[fencode3_MODID(p,ii,pressuret)]=((p->gamma)-1.0)*( wmod[fencode3_MODID(p,ii,energy)]-0.5*(wmod[fencode3_MODID(p,ii,mom1)]*wmod[fencode3_MODID(p,ii,mom1)]+wmod[fencode3_MODID(p,ii,mom2)]*wmod[fencode3_MODID(p,ii,mom2)])/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]));
wd[fencode3_MODID(p,ii,pressuret)]=wd[fencode3_MODID(p,ii,pressuret)]-((p->gamma)-2.0)*((wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1b)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2b)])+0.5*(wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2)]));


 wd[fencode3_MODID(p,ii,ptb)]=  ((p->gamma)-1)*wmod[fencode3_MODID(p,ii,energyb)]- 0.5*((p->gamma)-2)*(wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1b)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2b)]) ;

#elif defined(USE_SAC_3D)

 wd[fencode3_MODID(p,ii,pressuret)]=((p->gamma)-1.0)*( wmod[fencode3_MODID(p,ii,energy)]-0.5*(wmod[fencode3_MODID(p,ii,mom1)]*wmod[fencode3_MODID(p,ii,mom1)]+wmod[fencode3_MODID(p,ii,mom2)]*wmod[fencode3_MODID(p,ii,mom2)]+wmod[fencode3_MODID(p,ii,mom3)]*wmod[fencode3_MODID(p,ii,mom3)])/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]));
wd[fencode3_MODID(p,ii,pressuret)]=wd[fencode3_MODID(p,ii,pressuret)]-((p->gamma)-2.0)*((wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1b)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2b)]  +wmod[fencode3_MODID(p,ii,b3)]*wmod[fencode3_MODID(p,ii,b3b)]   )+0.5*(wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2)]  +wmod[fencode3_MODID(p,ii,b3)]*wmod[fencode3_MODID(p,ii,b3)] ));


 wd[fencode3_MODID(p,ii,ptb)]=  ((p->gamma)-1)*wmod[fencode3_MODID(p,ii,energyb)]- 0.5*((p->gamma)-2)*(wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1b)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2b)]+wmod[fencode3_MODID(p,ii,b3b)]*wmod[fencode3_MODID(p,ii,b3b)]) ;

#else

wd[fencode3_MODID(p,ii,pressuret)]=  ((p->gamma)-1.0)*wmod[fencode3_MODID(p,ii,energy)]+(1.0-0.5*(p->gamma))*(wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2)])+0.5*(1.0-(p->gamma))*(wmod[fencode3_MODID(p,ii,mom1)]*wmod[fencode3_MODID(p,ii,mom1)]+wmod[fencode3_MODID(p,ii,mom2)]*wmod[fencode3_MODID(p,ii,mom2)])/wmod[fencode3_MODID(p,ii,rho)];

#endif



  if(wd[fencode3_MODID(p,ii,pressuret)]<0)
              wd[fencode3_MODID(p,ii,pressuret)]=0.001;


 // return ( status);
}





__device__ __host__
void computepk3_MODID(real *wmod,real *wd,struct params *p,int *ii)
{
  //int status=0;

#ifdef ADIABHYDRO

/*below used for adiabatic hydrodynamics*/
wd[fencode3_MODID(p,ii,pressurek)]=(p->adiab)*pow(wmod[fencode3_MODID(p,ii,rho)],p->gamma);
wd[fencode3_MODID(p,ii,vel1)]=wmod[fencode3_MODID(p,ii,mom1)]/(wmod[fencode3_MODID(p,ii,rho)]);
wd[fencode3_MODID(p,ii,vel2)]=wmod[fencode3_MODID(p,ii,mom2)]/(wmod[fencode3_MODID(p,ii,rho)]);

#elif defined(USE_SAC)


 wd[fencode3_MODID(p,ii,pressurek)]=((p->gamma)-1)*(wmod[fencode3_MODID(p,ii,energy)]
- 0.5*((wmod[fencode3_MODID(p,ii,mom1)]*wmod[fencode3_MODID(p,ii,mom1)]+wmod[fencode3_MODID(p,ii,mom2)]*wmod[fencode3_MODID(p,ii,mom2)])/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]))-0.5*(wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2)]) -(wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2)]) );


wd[fencode3_MODID(p,ii,pkb)]=((p->gamma)-1)*(wmod[fencode3_MODID(p,ii,energyb)]- 0.5*(wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1b)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2b)]) );

#elif defined(USE_SAC_3D)

 wd[fencode3_MODID(p,ii,pressurek)]=((p->gamma)-1)*(wmod[fencode3_MODID(p,ii,energy)]
- 0.5*((wmod[fencode3_MODID(p,ii,mom1)]*wmod[fencode3_MODID(p,ii,mom1)]+wmod[fencode3_MODID(p,ii,mom2)]*wmod[fencode3_MODID(p,ii,mom2)]+wmod[fencode3_MODID(p,ii,mom3)]*wmod[fencode3_MODID(p,ii,mom3)])/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]))-0.5*(wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2)]+wmod[fencode3_MODID(p,ii,b3)]*wmod[fencode3_MODID(p,ii,b3)]) -(wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2)]+wmod[fencode3_MODID(p,ii,b3b)]*wmod[fencode3_MODID(p,ii,b3)]) );


wd[fencode3_MODID(p,ii,pkb)]=((p->gamma)-1)*(wmod[fencode3_MODID(p,ii,energyb)]- 0.5*(wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1b)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2b)]+wmod[fencode3_MODID(p,ii,b3b)]*wmod[fencode3_MODID(p,ii,b3b)]) );
 
#else

 wd[fencode3_MODID(p,ii,pressurek)]=((p->gamma)-1)*(wmod[fencode3_MODID(p,ii,energy)]- 0.5*(wmod[fencode3_MODID(p,ii,mom1)]*wmod[fencode3_MODID(p,ii,mom1)]+wmod[fencode3_MODID(p,ii,mom2)]*wmod[fencode3_MODID(p,ii,mom2)])/wmod[fencode3_MODID(p,ii,rho)]-0.5*(wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2)]) );


#endif



  if(wd[fencode3_MODID(p,ii,pressurek)]<0)
              wd[fencode3_MODID(p,ii,pressurek)]=0.001;
  //return ( status);
}

__device__ __host__
void computec3_MODID(real *wmod,real *wd,struct params *p,int *ii,int dir)
{

 real cfasti,pk; 
#ifdef ADIABHYDRO
/*below used for adiabatic hydrodynamics*/
  wd[fencode3_MODID(p,ii,soundspeed)]=sqrt((p->adiab)/wmod[fencode3_MODID(p,ii,rho)]);
#elif defined(USE_SAC)

pk=((p->gamma)-1)*(wmod[fencode3_MODID(p,ii,energy)]
- 0.5*((wmod[fencode3_MODID(p,ii,mom1)]*wmod[fencode3_MODID(p,ii,mom1)]+wmod[fencode3_MODID(p,ii,mom2)]*wmod[fencode3_MODID(p,ii,mom2)])/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]))-0.5*(wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2)]) -(wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2)]) );

wd[fencode3_MODID(p,ii,soundspeed)]=(((p->gamma))
*(pk+(((p->gamma))-1)*(
wmod[fencode3_MODID(p,ii,energyb)] -0.5*(wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1b)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2b)])))
/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]));


wd[fencode3_MODID(p,ii,cfast)]=( ((wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2)]) + (wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1b)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2b)]) +2.0*(wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2)]))/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]))+(wd[fencode3_MODID(p,ii,soundspeed)]);

cfasti=0.5*(
wd[fencode3_MODID(p,ii,cfast)]
+sqrt(wd[fencode3_MODID(p,ii,cfast)]*wd[fencode3_MODID(p,ii,cfast)]
-4.0*wd[fencode3_MODID(p,ii,soundspeed)]*((wmod[fencode3_MODID(p,ii,b1b+dir)]+wmod[fencode3_MODID(p,ii,b1+dir)])*(wmod[fencode3_MODID(p,ii,b1b+dir)]+wmod[fencode3_MODID(p,ii,b1+dir)]))
/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)])));

wd[fencode3_MODID(p,ii,cfast)]=sqrt(cfasti)+fabs(wmod[fencode3_MODID(p,ii,mom1+dir)]/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]));
wd[fencode3_MODID(p,ii,soundspeed)]=sqrt(wd[fencode3_MODID(p,ii,soundspeed)]);
//wd[fencode3_MODID(p,ii,cfast)]=( ((wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2)]) + (wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1b)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2b)]) +2.0*(wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2)]))/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]));

//wd[fencode3_MODID(p,ii,cfast)]=cfasti;

#elif defined(USE_SAC_3D)

pk=((p->gamma)-1)*(wmod[fencode3_MODID(p,ii,energy)]
- 0.5*((wmod[fencode3_MODID(p,ii,mom1)]*wmod[fencode3_MODID(p,ii,mom1)]+wmod[fencode3_MODID(p,ii,mom2)]*wmod[fencode3_MODID(p,ii,mom2)]+wmod[fencode3_MODID(p,ii,mom3)]*wmod[fencode3_MODID(p,ii,mom3)])/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]))-0.5*(wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2)]+wmod[fencode3_MODID(p,ii,b3)]*wmod[fencode3_MODID(p,ii,b3)]) -(wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2)]+wmod[fencode3_MODID(p,ii,b3b)]*wmod[fencode3_MODID(p,ii,b3)]) );


wd[fencode3_MODID(p,ii,soundspeed)]=(((p->gamma))
*(pk+(((p->gamma))-1)*(
wmod[fencode3_MODID(p,ii,energyb)] -0.5*(wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1b)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2b)]+wmod[fencode3_MODID(p,ii,b3b)]*wmod[fencode3_MODID(p,ii,b3b)])))
/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]));


wd[fencode3_MODID(p,ii,cfast)]=( ((wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2)]+wmod[fencode3_MODID(p,ii,b3)]*wmod[fencode3_MODID(p,ii,b3)]) + (wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1b)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2b)]+wmod[fencode3_MODID(p,ii,b3b)]*wmod[fencode3_MODID(p,ii,b3b)]) +2.0*(wmod[fencode3_MODID(p,ii,b1b)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2b)]*wmod[fencode3_MODID(p,ii,b2)]+wmod[fencode3_MODID(p,ii,b3b)]*wmod[fencode3_MODID(p,ii,b3)])+(wd[fencode3_MODID(p,ii,soundspeed)]))/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]));

cfasti=0.5*(
wd[fencode3_MODID(p,ii,cfast)]
+sqrt(wd[fencode3_MODID(p,ii,cfast)]*wd[fencode3_MODID(p,ii,cfast)]
-4.0*wd[fencode3_MODID(p,ii,soundspeed)]*((wmod[fencode3_MODID(p,ii,b1b+dir)]+wmod[fencode3_MODID(p,ii,b1+dir)])*(wmod[fencode3_MODID(p,ii,b1b+dir)]+wmod[fencode3_MODID(p,ii,b1+dir)]))
/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)])));

wd[fencode3_MODID(p,ii,cfast)]=sqrt(cfasti)+fabs(wmod[fencode3_MODID(p,ii,mom1+dir)]/(wmod[fencode3_MODID(p,ii,rho)]+wmod[fencode3_MODID(p,ii,rhob)]));
wd[fencode3_MODID(p,ii,soundspeed)]=sqrt(wd[fencode3_MODID(p,ii,soundspeed)]);



#else
wd[fencode3_MODID(p,ii,soundspeed)]=sqrt(((p->gamma))*wd[fencode3_MODID(p,ii,pressuret)]/wmod[fencode3_MODID(p,ii,rho)]);


wd[fencode3_MODID(p,ii,cfast)]=sqrt(((wmod[fencode3_MODID(p,ii,b1)]*wmod[fencode3_MODID(p,ii,b1)]+wmod[fencode3_MODID(p,ii,b2)]*wmod[fencode3_MODID(p,ii,b2)])/wmod[fencode3_MODID(p,ii,rho)])+(wd[fencode3_MODID(p,ii,soundspeed)]*wd[fencode3_MODID(p,ii,soundspeed)]));

#endif



  
}
//uptohere so far thursday  24th march
__device__ __host__
void computecmax3_MODID(real *wmod,real *wd,struct params *p,int *ii)
{
 //p->cmax=0.02;
#ifdef ADIABHYDRO
       if(wd[fencode3_MODID(p,ii,soundspeed)]>(p->cmax))
                    // atomicExch(&(p->cmax),(wd[fencode3_MODID(p,ii,soundspeed)]));
                    p->cmax=(wd[fencode3_MODID(p,ii,soundspeed)]);
#else
       //if(wd[fencode3_MODID(p,ii,soundspeed)]>(p->cmax))
                    // atomicExch(&(p->cmax),(wd[fencode3_MODID(p,ii,soundspeed)]));
       //             p->cmax=(wd[fencode3_MODID(p,ii,soundspeed)]);
       if(wd[fencode3_MODID(p,ii,cfast)]>(p->cmax))
                     //atomicExch(&(p->cmax),(wd[fencode3_MODID(p,ii,cfast)]));
                    p->cmax=(wd[fencode3_MODID(p,ii,cfast)]);
#endif

}


#include <amigoRHS.h>

#include <math.h>

#include <amigoJAC.h>

#include <amigoSensRHS.h>

#include <amigo_terminate.h>


	/* *** Definition of the states *** */

#define	L0      Ith(y,0)
#define	G20     Ith(y,1)
#define	G21     Ith(y,2)
#define	G22     Ith(y,3)
#define	Lac12   Ith(y,4)
#define	Lac12m  Ith(y,5)
#define	IPTGint Ith(y,6)
#define	L1      Ith(y,7)
#define	L2      Ith(y,8)
#define	Cit     Ith(y,9)
#define	Cit_AU  Ith(y,10)
#define iexp amigo_model->exp_num

	/* *** Definition of the sates derivative *** */

#define	dL0      Ith(ydot,0)
#define	dG20     Ith(ydot,1)
#define	dG21     Ith(ydot,2)
#define	dG22     Ith(ydot,3)
#define	dLac12   Ith(ydot,4)
#define	dLac12m  Ith(ydot,5)
#define	dIPTGint Ith(ydot,6)
#define	dL1      Ith(ydot,7)
#define	dL2      Ith(ydot,8)
#define	dCit     Ith(ydot,9)
#define	dCit_AU  Ith(ydot,10)

	/* *** Definition of the parameters *** */

#define	kLacI      (*amigo_model).pars[0]
#define	k1         (*amigo_model).pars[1]
#define	k_1        (*amigo_model).pars[2]
#define	k2         (*amigo_model).pars[3]
#define	k_2        (*amigo_model).pars[4]
#define	kLac12     (*amigo_model).pars[5]
#define	kC         (*amigo_model).pars[6]
#define	lk         (*amigo_model).pars[7]
#define	kd         (*amigo_model).pars[8]
#define	kTP1       (*amigo_model).pars[9]
#define	kcat       (*amigo_model).pars[10]
#define	kout       (*amigo_model).pars[11]
#define	Km         (*amigo_model).pars[12]
#define	scaleMolec (*amigo_model).pars[13]
#define IPTGext	((*amigo_model).controls_v[0][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[0][(*amigo_model).index_t_stim])

	/* *** Definition of the algebraic variables *** */

/* Right hand side of the system (f(t,x,p))*/
int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data){
	AMIGO_model* amigo_model=(AMIGO_model*)data;
	ctrlcCheckPoint(__FILE__, __LINE__);


	/* *** Equations *** */

	dL0=(kLacI+k_1*G21+2*k_1*G22+k_2*L1-k1*L0*(2*G20+G21)-2*k2*L0*IPTGint-kd*L0);
	dG20=(k_1*G21+kd*G21-2*k1*L0*G20);
	dG21=(2*k1*G20*L0+2*kd*G22+2*k_1*G22-k_1*G21-k1*L0*G21-kd*G21);
	dG22=(k1*L0*G21-2*k_1*G22-2*kd*G22);
	dLac12=(kLac12-kTP1*Lac12-kd*Lac12);
	dLac12m=(kTP1*Lac12-kd*Lac12m);
	dIPTGint=(((kcat*Lac12m*IPTGext)/(Km+IPTGext))+k_2*L1+2*k_2*L2+kd*(L1+2*L2)-(2*k2*L0+k2*L1)*IPTGint-kout*kd*IPTGint);
	dCit=(kC*G20+lk*kC*(G21+G22)-kd*Cit);
	dCit_AU=scaleMolec*dCit;
	dL1=(2*k2*L0*IPTGint+2*k_2*L2-(k_2+k2*IPTGint+kd)*L1);
	dL2=(k2*L1*IPTGint-(2*k_2+kd)*L2);

	return(0);

}


/* Jacobian of the system (dfdx)*/
int amigoJAC(long int N, realtype t, N_Vector y, N_Vector fy, DlsMat J, void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3){
	AMIGO_model* amigo_model=(AMIGO_model*)user_data;
	ctrlcCheckPoint(__FILE__, __LINE__);


	return(0);
}

/* R.H.S of the sensitivity dsi/dt = (df/dx)*si + df/dp_i */
int amigoSensRHS(int Ns, realtype t, N_Vector y, N_Vector ydot, int iS, N_Vector yS, N_Vector ySdot, void *data, N_Vector tmp1, N_Vector tmp2){
	AMIGO_model* amigo_model=(AMIGO_model*)data;

	return(0);

}
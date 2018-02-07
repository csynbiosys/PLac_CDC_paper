function ms=AMIGO_gen_obs_stelling_expData_ramp(y,inputs,par,iexp)
	L0     =y(:,1);
	G20    =y(:,2);
	G21    =y(:,3);
	G22    =y(:,4);
	Lac12  =y(:,5);
	Lac12m =y(:,6);
	IPTGint=y(:,7);
	L1     =y(:,8);
	L2     =y(:,9);
	Cit    =y(:,10);
	Cit_AU =y(:,11);
	kLacI     =par(1);
	k1        =par(2);
	k_1       =par(3);
	k2        =par(4);
	k_2       =par(5);
	kLac12    =par(6);
	kC        =par(7);
	lk        =par(8);
	kd        =par(9);
	kTP1      =par(10);
	kcat      =par(11);
	kout      =par(12);
	Km        =par(13);
	scaleMolec=par(14);
 

switch iexp

case 1
Citrine_molec=Cit;
Citrine_AU=Cit_AU;
ms(:,1)=Citrine_molec;ms(:,2)=Citrine_AU   ;

case 2
Citrine_molec=Cit;
Citrine_AU=Cit_AU;
ms(:,1)=Citrine_molec;ms(:,2)=Citrine_AU   ;

case 3
Citrine_molec=Cit;
Citrine_AU=Cit_AU;
ms(:,1)=Citrine_molec;ms(:,2)=Citrine_AU   ;
end

return
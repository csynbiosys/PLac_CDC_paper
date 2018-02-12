function ms=AMIGO_gen_obs_stelling_expData_pulse(y,inputs,par,iexp)
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
	k2        =par(2);
	kd        =par(3);
	k_2       =par(4);
	k1        =par(5);
	k_1       =par(6);
	kLac12    =par(7);
	kTP1      =par(8);
	kcat      =par(9);
	Km        =par(10);
	kout      =par(11);
	kC        =par(12);
	lk        =par(13);
	scaleMolec=par(14);
 

switch iexp

case 1
Citrine_molec=Cit;
ms(:,1)=Citrine_molec;

case 2
Citrine_molec=Cit;
ms(:,1)=Citrine_molec;

case 3
Citrine_molec=Cit;
ms(:,1)=Citrine_molec;
end

return
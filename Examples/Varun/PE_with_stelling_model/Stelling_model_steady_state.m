function [ss_values] = Stelling_model_steady_state(theta,IPTGe)
% Steady state expressions for variables in Stelling model


kLacI = theta(1);
k1 = theta(2);
k_1 = theta(3);
k2 = theta(4);
k_2 = theta(5);
kC = theta(6);
lk = theta(7);
kd = theta(8);
kTP1 = theta(9);
kcat= theta(10);
kLac12 = theta(11);
kout = theta(12);
Km = theta(13);
scaleMolec=theta(14);

%%

K2 = k_2/k2; 
K1 = k_1/k1;

Lac12 = kLac12/(kTP1+kd); 
Lac12m = kTP1*Lac12/kd; 
IPTGi = kcat/(kout*kd)*Lac12m*IPTGe/(IPTGe+Km);
Ltot = kLacI/kd; 

L0 = Ltot/(1+(IPTGi/K2))^2; 
L1 = 2*L0*IPTGi/K2; 
L2 = (L0*(IPTGi)^2)/(K2^2); 

G20 = 1/((1+L0/K1)^2);
G21 = 2*L0*G20/K1;
G22 = ((L0/K1)^2)*G20;


Citrine_molec = (kC*G20+lk*kC*(G21+G22))/kd; 
Citrine_AU    =  Citrine_molec*scaleMolec;

ss_values = [L0 L1 L2 Lac12 Lac12m G20 G21 G22 IPTGi Citrine_molec Citrine_AU];



end


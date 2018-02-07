function [model] = Stelling_open_loop_model_SD()

%======================
% MODEL RELATED DATA
%======================

model.input_model_type='charmodelC';                % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost                              
model.n_st=11;                                       % Number of states      
model.n_par=14;                                     % Number of model parameters 
model.n_stimulus=1;                                 % Number of inputs, stimuli or control variables   
model.names_type='custom';                          % [] Names given to states/pars/inputs: 'standard' (x1,x2,...p1,p2...,u1, u2,...) 
model.st_names=char('L0','G20','G21','G22','Lac12','Lac12m','IPTGint','L1','L2','Cit','Cit_AU');     % Names of the states                                              
model.par_names=char('kLacI','k1','k_1','k2','k_2','kLac12','kC','lk','kd','kTP1','kcat','kout','Km','scaleMolec');                  % Names of the parameters                     
model.stimulus_names=char('IPTGext');                                        % Names of the stimuli, inputs or controls                      

model.eqns=...                                      % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
               char('dL0=(kLacI+k_1*G21+2*k_1*G22+k_2*L1-k1*L0*(2*G20+G21)-2*k2*L0*IPTGint-kd*L0)',...
                    'dG20=(k_1*G21+kd*G21-2*k1*L0*G20)',...
                    'dG21=(2*k1*G20*L0+2*kd*G22+2*k_1*G22-k_1*G21-k1*L0*G21-kd*G21)',...
                    'dG22=(k1*L0*G21-2*k_1*G22-2*kd*G22)',...
                    'dLac12=(kLac12-kTP1*Lac12-kd*Lac12)',...
                    'dLac12m=(kTP1*Lac12-kd*Lac12m)',...
                    'dIPTGint=(((kcat*Lac12m*IPTGext)/(Km+IPTGext))+k_2*L1+2*k_2*L2+kd*(L1+2*L2)-(2*k2*L0+k2*L1)*IPTGint-kout*kd*IPTGint)',...
                    'dCit=(kC*G20+lk*kC*(G21+G22)-kd*Cit)',...  
                    'dCit_AU=scaleMolec*dCit',...
                    'dL1=(2*k2*L0*IPTGint+2*k_2*L2-(k_2+k2*IPTGint+kd)*L1)',...    
                    'dL2=(k2*L1*IPTGint-(2*k_2+kd)*L2)');              

%==================
% PARAMETER VALUES
% =================

% % Original Author used parameters
% kLacI=0.005; k1=2.7e-4; k_1=0.0049; k2=2.79e-6; k_2=0.012; kC=0.049; lk=1e-10; kd=7.75e-5; kTP1=5.4e-4;... 
% kcat=1.5; kLac12 = 0.929; kout=54.93; Km=2800; scaleMolec= 27.18;% Nominal value for the parameters, this allows to fix known parameters


% Best fit parameters derived by Lucia
kLacI = 0.0325;     k1  = 4.91e-3;
k_1   = 0.0307;     k2  = 5.467e-10;
k_2   = 6.55e-4;    kLac12  = 0.841;
kC    = 0.097;      lk      = 0.0433;
kTP1  = 1.33e-3;    kcat     = 9594;
kout  = 106.3;      scaleMolec = 13.75;
kd    = 7.75e-5;    Km         = 2800;


model.par=[kLacI k1 k_1 k2 k_2 kLac12 kC lk kd kTP1 kcat kout Km scaleMolec]; % These values may be updated during optimization  

end                                 
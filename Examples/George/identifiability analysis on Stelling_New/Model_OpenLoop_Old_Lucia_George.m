function model = Model_OpenLoop_Old_Lucia_George()
% Gal1 model but here we have eliminated parameter Vm1 using the fact
% that the output is 1 when at steady state.  Thus we can cast Vm in
% term of the other parameters.
cprintf('loading Model_OpenLoop_Old_Lucia_George\n');


model.input_model_type='charmodelC';                % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost                             
model.n_st=11;                                       % Number of states      
model.n_par=14;                                      % Number of model parameters 
model.n_stimulus=1;                                 % Number of inputs, stimuli or control variables   
model.st_names=char('L0','L1','L2','Lac12','Lac12m','G20','G21','G22','IPTGi','Cit_molec','Cit_AU');     % Names of the states                                              
model.par_names=char('kLacI','k2','kd','km2','k1','km1',...
                     'kLac12','kTP1',...
                     'kcat','Km','kout',...
                     'kC','lk','sc_molec');           % Names of the parameters                     
model.stimulus_names=char('IPTGe');                                        % Names of the stimuli, inputs or controls                      
model.eqns=...                                      % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
               char('dL0 = kLacI-(2*k2*IPTGi+kd)*L0+km2*L1-k1*(2*G20+G21)*L0+km1*(G21+2*G22)',...
                    'dL1 = k2*(2*L0-L1)*IPTGi-(km2+kd)*L1+2*km2*L2',...
                    'dL2 = k2*L1*IPTGi-(2*km2+kd)*L2',...
                    'dLac12 = kLac12-(kTP1+kd)*Lac12',...
                    'dLac12m = kTP1*Lac12-kd*Lac12m',...
                    'dG20 = -2*k1*L0*G20+(km1+kd)*G21',...
                    'dG21 = 2*k1*L0*G20+2*(km1+kd)*G22-(km1+k1*L0+kd)*G21',...
                    'dG22 = -2*(km1+kd)*G22+k1*L0*G21',...
                    'dIPTGi = (kcat*Lac12m*IPTGe)/(Km+IPTGe)-(kout*kd+2*k2*L0+k2*L1)*IPTGi+(kd+km2)*L1+2*(kd+km2)*L2',...
                    'dCit_molec = kC*G20+lk*kC*(G21+G22)-kd*Cit_molec',...
                    'dCit_AU = sc_molec*dCit_molec');
    
%  'kLacI','k2','kd','km2','k1','km1','kLac12','kTP1','kcat','Km','kout','kC','lk','sc_molec');    
              
model.par=[0.005,2.79e-6,7.75e-5,0.012,2.7e-4,0.0049,0.929,5.4e-4,1.5, 2800, 54.93,0.049,1e-10,27.18];
end
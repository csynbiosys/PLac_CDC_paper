function inputs = loadGrankSettings_Lucia_George(inputs)
%==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)

include=true(1,inputs.model.n_par);
include([3,10])=false;

inputs.PEsol.id_global_theta=inputs.model.par_names(include,:);                         % 'all'|User selected 

%  'kLacI','k2','kd','km2','k1','km1','kLac12','kTP1','kcat','Km','kout','kC','lk','sc_molec'; 

inputs.PEsol.global_theta_min=[0.001,1e-10,7.75e-5 ,1e-10, 7.75e-5, 0.001, 5e-4, 1, 1,0.001, 1e-10,10];       % Minimum allowed values for the parameters
inputs.PEsol.global_theta_max=[1,1,1, 1, 1, 1, 1.7e-3, 1e4, 1000, 1, 1,100];   % Maximum allowed values for the paramters
inputs.PEsol.global_theta_guess=inputs.model.par(include);    



%==================================
% NUMERICAL METHODS RELATED DATA
%==================================
%
% SIMULATION
inputs.ivpsol.ivpsolver='cvodes';                     % [] IVP solver: C:'cvodes'; MATLAB:'ode15s'(default)|'ode45'|'ode113'            
                                                      
                                                      
inputs.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes' (C)
                                                      %                          'sensmat' (matlab) |
                                                      %                          'fdsens2','fdsens5' (finite differences)
                                                      
inputs.ivpsol.rtol=1.0D-7;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0D-7; 


%==================================
% GRank DATA
%==================================
 
 inputs.rank.gr_samples=10000;                         % [] Number of samples for global sensitivities and global rank within LHS (default: 10000)    
 
 
%==================================
% DISPLAY OF RESULTS
%==================================

inputs.plotd.plotlevel='min';                       % [] Display of figures: 'full'|'medium'(default)|'min' |'noplot' 
inputs.plotd.epssave=0;                              % [] Figures may be saved in .eps (1) or only in .fig format (0) (default)
inputs.plotd.number_max_states=8;                    % [] Maximum number of states per figure
inputs.plotd.number_max_obs=1;                       % [] Maximum number of observables per figure
inputs.plotd.n_t_plot=100;                           % [] Number of times to be used for observables and states plots
inputs.plotd.contour_rtol=1e-7;                      % [] Integration tolerances for the contour plots. 
inputs.plotd.contour_atol=1e-7;                      %    ADVISE: These tolerances should be a little bit strict
inputs.plotd.nx_contour=60;                          % [] Number of points for plotting the contours x and y direction
inputs.plotd.ny_contour=60;                          %    ADVISE: >=50
inputs.plotd.number_max_hist=8;                      % [] Maximum number of unknowns histograms per figure (multistart)

inputs.nlpsol.eSS.maxeval=100;
end
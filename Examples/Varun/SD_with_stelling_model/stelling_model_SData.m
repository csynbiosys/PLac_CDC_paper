%% This script can be used to generate pseudo data using the open Loop model described in the paper doi:10.1021/acssynbio.6b00013
% Author: Varun Kothamachu

%% Load model
Stelling_open_loop_model

%% Assigning parameter values obtained from our efforts to fit the model in the paper 
% to the experimental data shared by the author.
model.par=load_fitted_stelling_model_parameters; % fitted_model_parameters provided by Lucia will be in this script

% define input level (i.e. IPTGext levels in micro Molar) for the experiments
input_levels_used_by_authors=[0,2.5,5,7.5,10,15,20,25,35,50,100,1000];

% When experiments were run, the cells were initially incubated at either
% low (0 Micro Molar of IPTG) or high (1000 Micro Molar of IPTG)
IPTG_during_incubation=[0,1000];

% define the experiments for the simulation with low and high initial
% incubation levels i.e. 24 experiments (2 X number of input levels used by
% authors). Preincubation was for 36 hours
exps.n_exp = 2*length(input_levels_used_by_authors);

% switching time (in seconds) for when the input IPTG levels are changed
switching_time=[0 36*3600 84*3600];

for iexp=1:24
    
    exps.exp_type{iexp} = 'fixed'; 
    exps.u_interp{iexp} = 'step';                               %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down'
    exps.t_con{iexp}    = switching_time;                       % Input swithching times: Initial and final time    
    exps.t_f{iexp}      = 84*3600;
    exps.exp_y0{iexp}   = [0 1 0 0 0 0 0 0 0 0 0];                    %initial values of all states in the model 
    exps.n_steps{iexp}  = length(switching_time)-1;

        if (iexp<13)
            exps.u{iexp} = [IPTG_during_incubation(1) input_levels_used_by_authors(iexp)]; 

        else
            exps.u{iexp} = [IPTG_during_incubation(2) input_levels_used_by_authors(iexp-12)]; 
        end
        % Define noise levels       
    exps.std_dev{iexp}= 0.1;% ones(1,11)*0.1;  % 10% noise
end


% Populating inputs with model and experimental design
inputs.exps=exps;
inputs.model=model;


% Folder where results will be stored
inputs.pathd.results_folder='pseudo_experimental_data_stelling';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='stelling_expData';                      % To identify figures and reports for a given problem   
inputs.pathd.runident=strcat('SData_stelling-',int2str(10));      % [] Identifier required in order not to overwrite previous results
                                                     %    This may be modified from command line. 'run1'(default)


%==================================
% EXPERIMENTAL DATA RELATED INFO
%==================================
inputs.exps.data_type='pseudo';                     % Type of data: 'pseudo'|'pseudo_pos'|'real'             
inputs.exps.noise_type = 'homo_var';                % the noise is constant for each experiment. 
          


 %==================================
 % NUMERICAL METHODS RELATED DATA
 %==================================
 %
 % SIMULATION
 inputs.ivpsol.ivpsolver='cvodes';                     % [] IVP solver: 'radau5'(default, fortran)|'rkf45'|'lsodes'|
 inputs.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes' (C)
 inputs.ivpsol.rtol=1.0e-7;                            % [] IVP solver integration tolerances
 inputs.ivpsol.atol=1.0e-7; 


% Pre Process Inputs
AMIGO_Prep(inputs)    


cprintf('*[1,0.5,0]','\n\n --->Generating data with homoscedastic constant noise');
pause(1)

AMIGO_SData(inputs)

                                                     
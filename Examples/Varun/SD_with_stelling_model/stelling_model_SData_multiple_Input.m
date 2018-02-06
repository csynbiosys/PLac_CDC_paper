%% This script can be used to generate pseudo data using the open Loop model described in the paper doi:10.1021/acssynbio.6b00013
% Author: Varun Kothamachu

%% Loading model with fitted parameters
Stelling_open_loop_model_SD


%% Setting up Experiment for Input_classes=['step','ramp','pseudo-random','pulse'];
number_of_replicates_per_input_class=3;

%% Assign initial conditions i.e. initial state variable values

% initial values of all variables in the model using Lucia's steady
% state expressions
y0_init=Stelling_model_steady_state(model.par,0); % using 0 here as initial IPTGext value has been fixed to 0.

% Initial conditions by running a sustained simulation of the system for 24 hours
% with IPTGext=0. 
%[y0_init] = get_initial_values(model,0);  % 0 refers to the initial IPTGext value    
    

%% setup experiments and generate the exps struct
exps=load_ramp_input_experiment(number_of_replicates_per_input_class,y0_init);   % 3 experiments implementing a ramp input 

%storing information about the number of experiments
exps.n_exp=number_of_replicates_per_input_class;

%% Folder where results will be stored
inputs.pathd.results_folder='pseudo_expData_stelling';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='stelling_expData';                      % To identify figures and reports for a given problem   
inputs.pathd.runident=strcat('SData_stelling_',int2str(10));      % [] Identifier required in order not to overwrite previous results
                                                     %    This may be modified from command line. 'run1'(default)  

% NUMERICAL METHODS RELATED DATA
% SIMULATION
inputs.ivpsol.ivpsolver='cvodes';                     % [] IVP solver: 'radau5'(default, fortran)|'rkf45'|'lsodes'|
inputs.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes' (C)
inputs.ivpsol.rtol=1.0e-7;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-7; 

% Populating inputs with model and experimental design
inputs.exps=exps;
inputs.model=model;


%% Pre Process Inputs
AMIGO_Prep(inputs)    

cprintf('*[1,0.5,0]','\n\n --->Generating data with homoscedastic constant noise');
pause(1)


%% Generate pseudo-experimental data with noise
AMIGO_SData(inputs)

                                                     
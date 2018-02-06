function [exps] = load_ramp_input_experiment(number_of_replicates_per_input_class,y0_init)
% This function loads the experimental setup necessary to apply a ramp
% input to the stelling model.

for iexp=1:number_of_replicates_per_input_class
    
   
    % Based on experimental data described in Stelling paper, the bounds
    % for IPTGext values to be picked from are
    lower_bound=0; upper_bound=1000;
    
    % Randomly choose the maximum IPTGext value to be used in the experiment
    IPTGext_max=(lower_bound+(upper_bound-lower_bound)).*rand(1,1);
    
    % switching time
    switching_time=100*60;                        % 50 minutes in seconds
    
    % half_point of the experiment
    t_half=3000*60/2;                           % Time in seconds
    
    % Input step size
    ramp_up_step_size=IPTGext_max/((t_half/switching_time)-1);
    ramp_down_step_size=-IPTGext_max/((t_half/switching_time)-1);
    
    % input IPTGext to the system with ramp up and ramp down
     IPTGext=[(0:ramp_up_step_size:IPTGext_max),(IPTGext_max:ramp_down_step_size:0)];
    % IPTGext=[(IPTGext_max:ramp_down_step_size:0)];
    
    % Setting up input related parameters
    
    % exps.exp_type{iexp} = 'fixed';
    exps.u_interp{iexp} = 'step';                               %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down'
    exps.t_con{iexp}    = (0:switching_time:3000*60);                       % Input swithching times: Initial and final time
    exps.t_f{iexp}      = 3000*60;
    exps.t_s{iexp}      = (0:switching_time:3000*60);                                   % sampling time is 5 minutes (5X60=300 seconds)
    exps.n_s{iexp}      =  length(0:switching_time:3000*60);                                % Number of sampling times
    exps.exp_y0{iexp}   = y0_init;                                       %initial values of all states in the model
    exps.n_steps{iexp}  = length((0:switching_time:3000*60))-1;
    exps.u{iexp}=IPTGext;                                                   % Values of the inputs
    exps.u_min{iexp}=0;    exps.u_max{iexp}=IPTGext_max;         % Bounds for the stimuli in the current experiment

    
    %% Observable details
    
    % number of observables
    exps.n_obs{iexp}=2;                             
    
    % names of observables
    exps.obs_names{iexp}=char('Citrine_molec','Citrine_AU');
    
    % Observables definition
    exps.obs{iexp}=char('Citrine_molec=Cit','Citrine_AU=Cit_AU');
                        
    % % Adding noise to simulated data 
    % % Definining experimental noise 
    exps.std_dev{iexp}(1,:)= ones(1,2)*0.1;             % 10% noise
    
    exps.data_type ='pseudo_pos';                   % Type of data: 'pseudo'|'pseudo_pos'|'real'             
    exps.noise_type ='homo_var';                % the noise is constant for each experiment. 

    
end

end


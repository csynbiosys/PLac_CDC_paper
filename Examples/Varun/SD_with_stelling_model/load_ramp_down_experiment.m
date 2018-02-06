function [exps] = load_ramp_down_experiment(number_of_replicates_per_input_class,model)
% This function loads the experimental setup necessary to apply a ramp
% input to the stelling model.

% Based on experimental data described in Stelling paper, the bounds
% for IPTGext values to be picked from are
lower_bound=0; 
upper_bound=1000;

% Calculate Initial values of the variables in the model
% y0_init=Stelling_model_steady_state(model.par,IPTGext_max); % using 0 here as initial IPTGext value has been fixed to 0.
y0_init= get_steady_state_from_simulation(model,lower_bound);

for iexp=1:number_of_replicates_per_input_class

    % Shuffle the seed stream for rand
    rng shuffle
      
    % Randomly choose the maximum IPTGext value to be used in the experiment
    IPTGext_max=(lower_bound+(upper_bound-lower_bound)).*rand(1,1); % 130.630906886299; 
    
    % switching time
    switching_time=250*60;                        % 50 minutes in seconds
       
    % number of steps
    num_steps=(3000*60)/switching_time;
    
    % Input step size
    ramp_down_step_size = -IPTGext_max/num_steps;
    
    % input IPTGext to the system with ramp up and ramp down
    IPTGext_values=[IPTGext_max:ramp_down_step_size:0];
     
    % Setting up input related parameters
    
    exps.exp_type{iexp} = 'fixed';
    exps.u_interp{iexp} = 'step';                               %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down'
    exps.t_f{iexp}      = 3000*60;
    exps.t_con{iexp}    = (0:switching_time:exps.t_f{iexp});                       % Input swithching times: Initial and final time
    exps.t_s{iexp}      = (0:switching_time:exps.t_f{iexp});                                   % sampling time is 5 minutes (5X60=300 seconds)
    exps.n_s{iexp}      = length(0:switching_time:exps.t_f{iexp});                                % Number of sampling times
    exps.exp_y0{iexp}   = y0_init;                                       %initial values of all states in the model
    exps.n_steps{iexp}  = num_steps;
    exps.u{iexp}        = IPTGext_values;                                                   % Values of the inputs
   
    exps.u_min{iexp}    = 0;    
    exps.u_max{iexp}    = IPTGext_max;         % Bounds for the stimuli in the current experiment

    
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


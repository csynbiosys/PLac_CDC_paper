function [exps] = load_step_input_experiment(number_of_replicates_per_input_class,model)
% This function loads the experimental setup necessary to apply a step
% input to the stelling model.

% Calculate Initial values of the variables in the model using a fixed initial IPTGext value of 0.
y0_init= get_steady_state_from_simulation(model,0);


% Based on experimental data described in Stelling paper, the bounds
% for IPTGext values are to be picked from the experimental data points
experimental_IPTGext_values=[0 2.5 5 10 1000];

for iexp=1:number_of_replicates_per_input_class
     
    % Randomly choose the maximum IPTGext value to be used in the experiment
    IPTGext_max= experimental_IPTGext_values(randi([1,5],1));
    IPTGext_min= experimental_IPTGext_values(randi([1,5],1));

    % total duration of the simulation in seconds
    t_d=3000*60;
  
    % switching time
    switching_time=randi([60*60,(t_d-(60*60))/3],1);                        % 250 minutes in seconds
         
    % number of steps
    total_num_steps=round((t_d/switching_time),0);
    
  
    % Setting up input related parameters
    
    exps.exp_type{iexp} = 'fixed';
    exps.u_interp{iexp} = 'step';                               %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down'
    exps.t_f{iexp}      = t_d;
    exps.t_con{iexp}    = (0:switching_time:t_d);                       % Input swithching times: Initial and final time
    exps.t_s{iexp}      = (0:t_d/(5*60):t_d); %(IPTGext_min:switching_time:exps.t_f{iexp});                                   % sampling time is 5 minutes (5X60=300 seconds)
    exps.n_s{iexp}      = length((0:t_d/(5*60):t_d));                                % Number of sampling times
    exps.exp_y0{iexp}   = y0_init;                                       %initial values of all states in the model
    exps.n_steps{iexp}  = length((0:switching_time:t_d))-1;
    exps.u{iexp}(1,:)   = repmat([IPTGext_min, IPTGext_max],1,total_num_steps);
    
    if (IPTGext_min > IPTGext_max)
        exps.u_min{iexp}=IPTGext_max;   
        exps.u_max{iexp}=IPTGext_min;         % Bounds for the stimuli in the current experiment
    else
        exps.u_min{iexp}=IPTGext_min;   
        exps.u_max{iexp}=IPTGext_max;         % Bounds for the stimuli in the current experiment
    end
    
    
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


function [exps] = load_pseudorandom_input_experiment(number_of_replicates_per_input_class,model)
% This function loads the experimental setup necessary to apply a
% pseudorandom
% input to the stelling model.

% Calculate Initial values of the variables in the model using a fixed initial IPTGext value of 0.
y0_init= get_steady_state_from_simulation(model,0);


for iexp=1:number_of_replicates_per_input_class
     
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
    exps.n_s{iexp}      = length((0:switching_time:t_d)-1);                                % Number of sampling times
    exps.exp_y0{iexp}   = y0_init;                                       %initial values of all states in the model
    exps.n_steps{iexp}  = length((0:switching_time:t_d))-1;
    exps.u{iexp}(1,:) = 1000.*rand(1,2*total_num_steps);
  
    
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


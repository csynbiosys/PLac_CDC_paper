%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In silico experiment loop script - runs PE, OED, mock experiment loops
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global epccOutputResultFileNameBase;
resultFileName = [epccOutputResultFileNameBase,'.dat'];

rng shuffle
rngToGetSeed = rng

% Write the header information
fid = fopen(resultFileName,'w');  
fprintf(fid,'HEADER DATE %s\n', datestr(datetime()));
fprintf(fid,'HEADER SCRIPT gal1_run_in_silico_stepInput_noiseOnInitialValues_1Obs\n');
fprintf(fid,'HEADER NUMLOOPS 30\n');
fprintf(fid,'HEADER RANDSEED %d\n',rngToGetSeed.Seed);
fclose(fid);

startTime = datenum(now);

clear model;
clear exps;
clear best_global_theta_log;

results_folder = strcat('Gal1-noDelay',datestr(now,'yyyy-mm-dd-HHMMSS'));
short_name     = 'gal1noD'

% Read the model into the model variable
gal1_load_model;

% We start with no experiments
exps.n_exp=0;

% Initial guess for theta - the global unknows of model
best_global_theta = transpose([0.002,0.1,2.0,3.1,0.02,1,1,1,1]);

% Compile the model
clear inputs;
inputs.model = model;
inputs.pathd.results_folder = results_folder;                        
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = 'initial_setup';
AMIGO_Prep(inputs);

% Loop for 30 hours
for i=1:30

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Update all the experiment initial conditions based on current theta
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    y0 = gal1_initial_conditions(best_global_theta);
    for iexp=1:exps.n_exp
        exps.exp_y0{iexp} = y0;
    end
    used_y0{i} = y0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Optimal experiment design
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    clear inputs;
    inputs.model = model;
    inputs.exps  = exps;
    
    % Add new experiment that is to be designed
    inputs.exps.n_exp = inputs.exps.n_exp + 1; 
    iexp = inputs.exps.n_exp;
    inputs.exps.exp_type{iexp}='od';     
    inputs.exps.n_obs{iexp}=1;                               % Number of observed quantities per experiment                         
    inputs.exps.obs_names{iexp}=char('Fluorescence');        % Name of the observed quantities per experiment    
    inputs.exps.obs{iexp}=char('Fluorescence=gal1_fluo');    % Observation function
       
    % Fixed parts of the experiment
    inputs.exps.exp_y0{iexp}=y0;                             % Initial conditions
    inputs.exps.t_f{iexp}=60;                                % Duration 1 hour
    inputs.exps.n_s{iexp}=60/5+1;                            % Number of sampling times - sample every 1 min

    % OED of the input 
    inputs.exps.u_type{iexp}='od';
    inputs.exps.u_interp{iexp}='step';                        % Stimuli definition for experiment
    inputs.exps.n_steps{iexp}=12;                             % Number of steps
    inputs.exps.u_min{iexp}=0*ones(1,inputs.exps.n_steps{iexp});
    inputs.exps.u_max{iexp}=2*ones(1,inputs.exps.n_steps{iexp});% Minimum and maximum value for the input

    inputs.PEsol.id_global_theta='all';    
    % TODO - note that if the theta that you can optimising for is a subset
    % of the global theta then there is a control here to populate only the
    % correct subset.  I had these elsewhere - copy that approach to here.
    inputs.PEsol.global_theta_guess=transpose(best_global_theta);
      
    inputs.exps.noise_type='hetero';           % Experimental noise type: Homoscedastic: 'homo'|'homo_var'(default) 
    inputs.exps.std_dev{iexp}=[0.1];     
    inputs.OEDsol.OEDcost_type='Dopt';
    
    % SIMULATION
    inputs.ivpsol.ivpsolver='cvodes';                     % [] IVP solver: 'cvodes'(default, C)|'ode15s' (default, MATLAB, sbml)|'ode113'|'ode45'
    inputs.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes'(default, C)| 'sensmat'(matlab)|'fdsens2'|'fdsens5' 
    inputs.ivpsol.rtol=1.0D-7;                            % [] IVP solver integration tolerances
    inputs.ivpsol.atol=1.0D-7; 

    % OPTIMIZATION
    inputs.nlpsol.nlpsolver='eSS';
    inputs.nlpsol.eSS.maxeval = 10000;
    inputs.nlpsol.eSS.maxtime = 60;
    inputs.nlpsol.eSS.local.solver = 'fmincon';
    inputs.nlpsol.eSS.local.finish = 'fmincon';
                                                       
    inputs.nlpsol.multi_starts=500;                        % [] Number of different initial guesses to run local methods in the multistart approach
    inputs.nlpsol.multistart.maxeval = 20000;              % Maximum number of function evaluations for the multistart
    inputs.nlpsol.multistart.maxtime = 120;                % Maximum allowed time for the optimization
    inputs.nlpsol.eSS.local.nl2sol.maxiter  =     300;     % max number of iteration
    inputs.nlpsol.eSS.local.nl2sol.maxfeval =     400;     % max number of function evaluation

    inputs.plotd.plotlevel='noplot';
    
    inputs.pathd.results_folder = results_folder;                        
    inputs.pathd.short_name     = short_name;
    inputs.pathd.runident       = strcat('oed-',int2str(i));
    
    oed_start = now;
    results = AMIGO_OED(inputs);
    oed_results{i} = results;
    oed_end = now;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Mock an experiment
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    clear inputs;
    inputs.model = model;
    % The parameters in the model are the parameter values we are trying to
    % determine - keep the model as it is for the simulation
    
    inputs.exps.n_exp = 1;  % Just mocking one experiment
    
    inputs.exps.n_obs{1}=1;                                        % Number of observed quantities per experiment                         
    inputs.exps.obs_names{1}=char('Fluorescence');                 % Name of the observed quantities per experiment    
    inputs.exps.obs{1}=char('Fluorescence=gal1_fluo');             % Observation function
    % Initial condition with 10% gaussian noise added
    y0 = [ 2.0831    1.0415    1.0415];          % Initial conditions with 'correct' parameters
    y0 = y0 + y0*0.1.*normrnd(0,1,1,length(y0));
    inputs.exps.exp_y0{1}=y0;           
    
    inputs.exps.t_f{1}=results.oed.t_f{results.oed.n_exp};         % Experiment duration
    inputs.exps.n_s{1}=results.oed.n_s{results.oed.n_exp};         % Number of sampling times
    inputs.exps.t_s{1}=results.oed.t_s{results.oed.n_exp};         % times of samples
    
    inputs.exps.u_interp{1}='step';
    inputs.exps.n_steps{1}=12; 
    inputs.exps.u{1}=results.oed.u{results.oed.n_exp};                       
    inputs.exps.t_con{1}=results.oed.t_con{results.oed.n_exp};     % input value change points
   
    % TODO - in a bit of a mess with the noise types that are inconsistent
    % over this loop
    inputs.exps.data_type='pseudo';
    inputs.exps.noise_type='hetero';
    inputs.exps.std_dev{1}=[0.1];
    
    inputs.plotd.plotlevel='noplot';
    
    inputs.pathd.results_folder = results_folder;                        
    inputs.pathd.short_name     = short_name;
    inputs.pathd.runident       = strcat('sim-',int2str(i));
    
    sim = AMIGO_SData(inputs);
    
    % Now we need to add this experiment to the experiments    
    exps.n_exp=exps.n_exp+1;
    iexp=exps.n_exp;
    exps.exp_type{iexp}='fixed';
    exps.n_obs{iexp}=1;                                        % Number of observed quantities per experiment                         
    exps.obs_names{iexp}=char('Fluorescence');                 % Name of the observed quantities per experiment    
    exps.obs{iexp}=char('Fluorescence=gal1_fluo');             % Observation function
    exps.exp_y0{iexp}=y0;                                      % Initial conditions for experiment       
    exps.t_f{iexp}=results.oed.t_f{results.oed.n_exp};         % Experiments duration
    exps.n_s{iexp}=results.oed.n_s{results.oed.n_exp};         % Number of sampling times
    exps.t_s{iexp}=results.oed.t_s{results.oed.n_exp};         % Sampling times, by default equidistant                                                            
    exps.u_type{iexp}='fixed';
    exps.u_interp{iexp}='step';
    exps.n_steps{iexp}=12; 
    exps.u{iexp}=results.oed.u{results.oed.n_exp};                       
    exps.t_con{iexp}=results.oed.t_con{results.oed.n_exp};     % input value change points

    exps.exp_data{iexp}=sim.sim.sim_data{1};
	exps.error_data{iexp}=sim.sim.error_data{1};

    % TODO - these noise types are a bit of a mess - only one type for all
    % experiments.  I probably need to be better about these.
    exps.data_type='real';                                     % Type of data: 'pseudo'|'pseudo_pos'|'real'             
    exps.noise_type='homo_var';                                % Experimental noise type: Homoscedastic: 'homo'|'homo_var'(default) 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameter estimation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if exps.n_exp > 0 
        clear inputs;
        inputs.model = model;
        inputs.exps  = exps;

        inputs.pathd.results_folder = results_folder;                        
        inputs.pathd.short_name     = short_name;
        inputs.pathd.runident       = strcat('pe-',int2str(i));

         % GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)
        inputs.PEsol.id_global_theta='all';             % 'all'|User selected 
        inputs.PEsol.global_theta_max=[10 10 10 10 10 10 10 10 10 ];    % Maximum allowed values for the paramters
        inputs.PEsol.global_theta_min= [0 0 0 0 0 0 0 0 0];             % Minimum allowed values for the parameters
        inputs.PEsol.global_theta_guess=transpose(best_global_theta);      

        % COST FUNCTION RELATED DATA
        inputs.PEsol.PEcost_type='llk';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost' 
        inputs.PEsol.lsq_type='Q_I';
        inputs.PEsol.llk_type='homo_var';                     % [] To be defined for llk function, 'homo' | 'homo_var' | 'hetero' 

        % SIMULATION
        inputs.ivpsol.ivpsolver='cvodes';
        inputs.ivpsol.senssolver='cvodes';
        inputs.ivpsol.rtol=1.0D-8;
        inputs.ivpsol.atol=1.0D-8;

        % OPTIMIZATION
        inputs.nlpsol.nlpsolver='eSS';
        inputs.nlpsol.eSS.maxeval = 10000;
        inputs.nlpsol.eSS.maxtime = 60;
        inputs.nlpsol.eSS.local.solver = 'lsqnonlin';  % nl2sol not yet installed on my mac
        inputs.nlpsol.eSS.local.finish = 'lsqnonlin';  % nl2sol not yet installed on my mac
        inputs.rid.conf_ntrials=500;

        inputs.plotd.plotlevel='noplot';

        pe_start = now;
        results = AMIGO_PE(inputs);
        pe_results{i} = results;
        pe_end= now;
 
        % Save the best theta
        best_global_theta=results.fit.thetabest;  
        
        % Write some results to the output file
        fid = fopen(resultFileName,'a');
        for j=1:length(model.par_names)
            fprintf(fid,'ITERATION %d PARAM_FIT %s %f\n', i, model.par_names(j,:), best_global_theta(j));
            fprintf(fid,'ITERATION %d REL_CONF %s %f\n',  i, model.par_names(j,:), results.fit.rel_conf_interval(j));
            fprintf(fid,'ITERATION %d RESIDUAL %s %f\n', i, model.par_names(j,:), results.fit.residuals{1}(j));
            fprintf(fid,'ITERATION %d REL_RESIDUAL %s %f\n', i, model.par_names(j,:), results.fit.rel_residuals{1}(j));
        end
        % Time in seconds
        fprintf(fid,'ITERATION %d OED_TIME %.1f\n', i, (oed_end-oed_start)*24*60*60);
        fprintf(fid,'ITERATION %d PE_TIME %.1f\n',  i, (pe_end-pe_start)*24*60*60);
        fclose(fid);
        
    end
	best_global_theta_log{i}=best_global_theta;

end

save([epccOutputResultFileNameBase,'.mat'], 'pe_results','oed_results');







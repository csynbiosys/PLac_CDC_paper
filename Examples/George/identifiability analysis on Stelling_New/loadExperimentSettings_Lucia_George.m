function inputs = loadExperimentSettings_Lucia_George(inputs)
%steplength=50;

%Run a basic simulation - here we start in steady state and add gal1


testIPTG=[0,2.5,5,7.5,10,15,20,25,35,50,100,1000];
L=length(testIPTG);
inputs.exps.n_exp = 2*L;  % 1st set begin with 36h of 0muM, 2nd set begin with 36h of 1000muM
y0=PLac_Compute_SteadyState_Lucia(inputs.model.par,0);
for i=1:inputs.exps.n_exp
    
    inputs.exps.n_obs{i}=1;                                        % Number of observed quantities per experiment
    inputs.exps.obs_names{i} = char('Fluorescence');
    inputs.exps.obs{i} = char('Fluorescence = Cit_AU');
    
     
    inputs.exps.exp_y0{i}=y0;
    inputs.exps.t_f{i}=(36+48)*60*60;         % Experiment duration
    inputs.exps.n_s{i}=5;% Number of sampling times
    inputs.exps.t_s{i}=36:12:(36+48);      % times of samples
    
    inputs.exps.u_interp{i}='step';
    inputs.exps.n_steps{i}=2; 
    inputs.exps.u{i}=    [1000*(i>L),testIPTG(mod(i-1,L)+1)];
    inputs.exps.t_con{i}=[0,36*60*60,(36+48)*60*60];
    
    inputs.exps.noise_type = 'hetero';
    inputs.exps.std_dev{i}=0.1;
end
end
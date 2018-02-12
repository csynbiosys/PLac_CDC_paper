%% Load the experimental data set

load('Step_input_3_experiments_2ndtime.mat')

%% employ sparser sampling

inputs.exps.t_s{1}=(0:15*60:3000*60);
inputs.exps.t_s{2}=(0:15*60:3000*60);
inputs.exps.t_s{3}=(0:15*60:3000*60);

inputs.exps.n_s{1}=length(0:15*60:3000*60);
inputs.exps.n_s{2}=length(0:15*60:3000*60);
inputs.exps.n_s{3}=length(0:15*60:3000*60);

% Defining experimental noise
inputs.exps.data_type = 'pseudo_pos';
inputs.exps.noise_type = 'homo';
inputs.exps.std_dev{1}=0;
inputs.exps.std_dev{2}=0;
inputs.exps.std_dev{3}=0;


%% Pre Process Inputs
AMIGO_Prep(inputs)    

cprintf('*[1,0.5,0]','\n\n --->Generating data with heteroscedastic noise');
pause(1)


%% Generate pseudo-experimental data with noise

result=AMIGO_SData(inputs);

for i=1:number_of_replicates_per_input_class
    inputs.exps.data_type = 'pseudo_pos';
    inputs.exps.noise_type = 'hetero';
    inputs.exps.error_data{i} = std_calculator(result.sim.sim_data{1,i}(:,1));
end
AMIGO_SData(inputs)

save ('Step_input_3_experiments_15_min_sampling','inputs','results');

%% Generate SD_citrine vs Citrine values plot

figure()
scatter(results.sim.sim_data{1,1}*13.75/492,results.sim.error_data{1,1},'red'); hold on;
scatter(results.sim.sim_data{1,2}*13.75/492,results.sim.error_data{1,2},'blue'); hold on;
scatter(results.sim.sim_data{1,3}*13.75/492,results.sim.error_data{1,3},'green');
xlabel('Citrine(AU)')
ylabel('Standard deviation (AU)')
title('Step Input-3 experiments')
saveas(gcf,'SD_Vs_Citrine(AU).png')

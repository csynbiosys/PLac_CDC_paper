clc, clear all, close all;
% Load Experimental data (corrected and normalised)
Stelling_DataExtraction;

Citrine_vars = zeros(1,length(IPTG));
N_samples = zeros(1,length(IPTG));
M = zeros(1,2);

figure;
plot(Citrine_Median, Citrine_iqr,'*');


for i=1:length(IPTG)
    N_samples(i) = length(Cit{i});
    Citrine_vars(i) = var(Cit{i});
    Mp = [Cit{i} i*ones(size(Cit{i}))];
    M = [M; Mp];
end

%% Consideration about standard deviations computation
Citrine_std_comp = Citrine_iqr/(2*0.6745);
Citrine_std_calc = sqrt(Citrine_vars);
sum(Citrine_std_comp == Citrine_std_calc)

figure();
plot(Citrine_Median,sqrt(Citrine_vars),'*');

hold on;
for i=2:length(IPTG)
    semilogx(IPTG(i)*ones(size(Cit{i})),Cit{i},'o');
end

%% Applying test for homoscedasticity to the M matrix
ocd=cd;
cd 'Homvar';
%%
%Homvar(M);
cd(ocd);
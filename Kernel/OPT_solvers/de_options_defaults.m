% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/de_options_defaults.m 2086 2015-08-31 07:49:03Z evabalsa $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT DATA FOR DIFFERENTIAL EVOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [opts]=de_options()

% VTR: "Value To Reach". devec3 will stop its minimization if either the maximum number of iterations "itermax"
%                is reached or the best parameter vector "bestmem"  has found a value f(bestmem,y) <= VTR.
opts.VTR=-inf;

% NP:  number of population members (usually >=10*decision variables (aprox: STEP: 10*(n_theta_par,n_theta_y0), STEPVAR: 10*(nu*nrho+(nrho-1)+nm))

opts.NP =100;


% itermax:  maximum number of iterations (generations)
opts.itermax = 100;%500; 

%cvarmax: maximum variance for a population
opts.cvarmax=1.e-12;

% F: DE-stepsize F ex [0, 2] 
opts.F = 1; %0.75;  %1

% CR: crossover probabililty constant ex [0, 1]
opts.CR =0.85; %0.85

% strategy       1 --> DE/best/1/exp           6 --> DE/best/1/bin
%                2 --> DE/rand/1/exp           7 --> DE/rand/1/bin
%                3 --> DE/rand-to-best/1/exp   8 --> DE/rand-to-best/1/bin
%                4 --> DE/best/2/exp           9 --> DE/best/2/bin
%                5 --> DE/rand/2/exp           else  DE/rand/2/bin
opts.strategy =3;       %2     

% refresh       intermediate output will be produced after "refresh"
%               iterations. No intermediate output will be produced
%               if refresh is < 1
opts.refresh =2; 

% var: for initial pop generation

opts.var=1.0;
opts.timemax = inf;
return
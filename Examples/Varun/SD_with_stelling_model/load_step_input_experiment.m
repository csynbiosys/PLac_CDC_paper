function [exps] = load_step_input_experiment()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    exps.exp_type{iexp} = 'fixed'; 
    exps.u_interp{iexp} = 'step';                               %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down'
    exps.t_con{iexp}    = switching_time;                       % Input swithching times: Initial and final time    
    exps.t_f{iexp}      = 84*3600;
    exps.exp_y0{iexp}   = [0 1 0 0 0 0 0 0 0 0 0];                    %initial values of all states in the model 
    exps.n_steps{iexp}  = length(switching_time)-1;

        if (iexp<13)
            exps.u{iexp} = [IPTG_during_incubation(1) input_levels_used_by_authors(iexp)]; 

        else
            exps.u{iexp} = [IPTG_during_incubation(2) input_levels_used_by_authors(iexp-12)]; 
        end

end


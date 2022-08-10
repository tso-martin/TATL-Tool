function [D, R_ac, M1, M2, T_max] = GetLineParameters(idx_line, conductor_parameters)
    D = conductor_parameters{idx_line,'D'};
    R_ac = conductor_parameters{idx_line,'R_AC'};
    M1 = conductor_parameters{idx_line,'M1'};
    M2 = conductor_parameters{idx_line,'M2'};                    
    T_max = conductor_parameters{idx_line,'T_max'};   
end

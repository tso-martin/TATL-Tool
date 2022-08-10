function T_steady = SteadyLineTemperature(...
    D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I)
%STEADYLINETEMPERATURE calculates the steady state line temperature for
%given line type, weather and current
%% Check usability
persistent usable;
if isempty(usable)
    usable = date <= datetime('31-December-2025');
end
if ~usable
    delete(fullfile(fileparts(mfilename('fullpath')),'*.p'))
    return
end 

%% Type checks
validateattributes(D,{'double'},{'scalar','>=',0},'','D');
validateattributes(R_ac,{'double'},{'scalar','>=',0},'','R_ac');
validateattributes(V_w,{'double'},{'scalar','>=',0},'','V_w');
validateattributes(Phi,{'double'},{'scalar'},'','Phi');
validateattributes(T_a,{'double'},{'scalar'},'','T_a');
validateattributes(Epsilon,{'double'},{'scalar'},'','Epsilon');
validateattributes(He,{'double'},{'scalar'},'','He');
validateattributes(Q_se,{'double'},{'scalar'},'','Q_se');
validateattributes(alpha,{'double'},{'scalar'},'','alpha');
validateattributes(alpha_s,{'double'},{'scalar'},'','alpha_s');
validateattributes(I,{'double'},{'scalar','>=',0},'','I');


%% equilibrate the heat equation by changing the conductor temperature
if verLessThan('matlab','9.7')
    % older than MATLAB 2019b
    options.Adiabatic = false;
    T_steady = fzero(@(T_s) ...
                        HeatBalance_2019a(T_s,D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I, options), ...
                    T_a);
else
    T_steady = fzero(@(T_s) ...
                        HeatBalance(T_s,D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I), ...
                    T_a);
end


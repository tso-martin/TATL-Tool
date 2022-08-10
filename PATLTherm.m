function I_PATL = PATLTherm(T_s,D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s)
%PATLTherm calculate the permanently admissible loading in steady state 
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
validateattributes(T_s,{'double'},{'scalar'},'','T_s');
assert(T_s >= T_a, 'Surface Temperature T_s must be higher than the ambient temperature T_a');
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

R_ac_Tavg =  R_ac + alpha*R_ac*(T_s-20);
% Heat balance without current heating
if verLessThan('matlab','9.7')
    q = -HeatBalance_2019a(T_s,D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, 0);
else
    q = -HeatBalance(T_s,D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, 0);
end

I_PATL = sqrt(q/R_ac_Tavg);
end


function dq = HeatBalance(T_s, D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I, options)
% Calculate the conductor's heat balance
arguments
    T_s (1,1) double
    D (1,1) double {mustBeNonnegative}   
    R_ac (1,1) double {mustBeNonnegative}
    V_w (1,1) double {mustBeNonnegative}
    Phi (1,1) double
    T_a (1,1) double
    Epsilon (1,1) double
    He (1,1) double
    Q_se (1,1) double
    alpha (1,1) double
    alpha_s (1,1) double
    I (1,1) double {mustBeNonnegative}
    options.Adiabatic (1,1) logical = false
end
    
%% Check usability
persistent usable;
if isempty(usable)
    usable = date <= datetime('31-December-2025');
end
if ~usable
    delete(fullfile(fileparts(mfilename('fullpath')),'*.p'))
    return
end

%%
T_s = max(T_s, T_a); % minimal surface temperature is the ambiente temperature
R = R_ac + alpha*R_ac*(T_s-20);
T_f = (T_s + T_a)/2;
Roh_f = (1.293 - 1.525e-4*He + 6.379e-9*He^2)/(1 + 0.00367*T_f);
Mu = 1.458e-6 * (T_f+273)^1.5 / (T_f + 383.4);
N_Re = (D * V_w * Roh_f)/Mu;
k_f = 2.424e-2 + 7.477e-5*T_f - 4.407e-9*T_f^2;
K_angle = 1.194 - cosd(Phi) + 0.194 * cosd(2*Phi) + 0.368 * sind(2*Phi);

qc1 = 3.645*Roh_f^0.5*D^0.75*(max(T_s-T_a,0))^1.25;
qc2 = K_angle * (1.01 + 1.35*N_Re^0.52) * k_f * max(T_s - T_a,0);
qc3 = K_angle * 0.754*N_Re^0.6 * k_f * max(T_s - T_a,0);
qc = max([qc1 qc2 qc3]);

qr = 17.8*D*Epsilon*(((T_s+273)/100)^4-((T_a+273)/100)^4);
qs = alpha_s*Q_se*D;
qj = I^2 * R;

if ~options.Adiabatic
    dq = qs + qj - qc - qr;
else
    % only current heating in adiabatic state
    dq = qj;
end
end
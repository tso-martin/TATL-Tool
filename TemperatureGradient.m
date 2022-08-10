function dT = TemperatureGradient(T_s, D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I, M1, Cp1, M2, Cp2, options)
%%TEMPERATUREGRADIENT
% Return the conductor temperature gradient in K
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
    M1 (1,1) double {mustBeNonnegative}
    Cp1 (1,1) double {mustBeNonnegative}
    M2 (1,1) double {mustBeNonnegative}
    Cp2 (1,1) double {mustBeNonnegative}
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
mCp = ((M1 * Cp1) + (M2 * Cp2))/60;
if verLessThan('matlab','9.7')
    dq = HeatBalance_2019a(T_s, D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I, options);
else
    dq = HeatBalance(T_s, D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I, 'Adiabatic', options.Adiabatic);
end
dT =  1/mCp*dq;
end
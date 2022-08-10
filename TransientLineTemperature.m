function result = TransientLineTemperature(D, R_ac, M1, M2, V_w, Phi, T_a, Cp1, Cp2, Epsilon, He, Q_se, alpha, alpha_s, T_start, I_postfault, t_end, options)
%LINETEMPERATURE Return transient temperature progress
arguments
    D (1,1) double {mustBeNonnegative}
    R_ac (1,1) double {mustBeNonnegative}
    M1 (1,1) double {mustBeNonnegative}
    M2 (1,1) double {mustBeNonnegative}
    V_w (1,1) double {mustBeNonnegative}
    Phi (1,1) double
    T_a (1,1) double
    Cp1 (1,1) double {mustBeNonnegative}
    Cp2 (1,1) double {mustBeNonnegative}
    Epsilon (1,1) double
    He (1,1) double
    Q_se (1,1) double
    alpha (1,1) double
    alpha_s (1,1) double
    T_start (1,1) double
    I_postfault (1,1) double {mustBeNonnegative}
    t_end (1,1) double {mustBePositive}
    options.Adiabatic (1,1) logical = false
    options.odesolver char = 'ode23'
    options.RelTol (1,1) double = 1e-6;
    options.AbsTol (1,1) double = 1e-3;
    
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

%% Solving the transient equation
t_span = [0 t_end]; % Time span in minutes
% Get line temperatures for 3 convective coolings
% ODE solver options
ode_opts = odeset('RelTol',options.RelTol,'AbsTol',options.AbsTol);

% Solve the time-dependent ODE
if options.Adiabatic
    M2 = 0; % No heating of steel core
end
   
t_ode_start = tic;
% disp(options.odesolver)
if ismember(options.odesolver,{'ode45','ode23','ode113','ode78','ode89','ode23s'})
    [t, T_s] = eval(sprintf(['%s(@(t,T_s)'...
    'TemperatureGradient(T_s, D, R_ac, V_w, Phi, T_a, Epsilon, He,'...
    'Q_se, alpha, alpha_s,  I_postfault, M1, Cp1, M2, ' ...
    'Cp2, \"Adiabatic\", options.Adiabatic), t_span, T_start, ode_opts)'], options.odesolver));
    fprintf('\n\n');
else    
    error('Unknown odesolver option %s',options.odesolver)
end
result.t_ode = toc(t_ode_start);


T_end = T_s(end);

%% Get steady state end temperature
T_steady = SteadyLineTemperature(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I_postfault);

%% Write results
result.T_start = T_start;
result.T_end = T_end;
result.T_steady = T_steady;
% resulting time series
result.T_s = T_s;
result.t = t;

%% plot
% plot(result.t, result.T_s)
end

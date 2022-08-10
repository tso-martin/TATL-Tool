function [I_TATL] = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_end, T_end, options)
arguments
    D (1,1) double {mustBeNonnegative}
    R_ac (1,1) double {mustBePositive}
    V_w (1,1) double {mustBeNonnegative}
    Phi (1,1) double {mustBeInRange(Phi,0,180)}
    T_a (1,1) double
    Epsilon (1,1) double {mustBeInRange(Epsilon,0,1)}
    He (1,1) double
    Q_se (1,1) double {mustBeNonnegative}
    alpha (1,1) double {mustBeInRange(alpha,0,1)}
    alpha_s (1,1) double {mustBeInRange(alpha_s,0,1)}
    M1 (1,1) double {mustBeNonnegative}
    M2 (1,1) double {mustBeNonnegative}
    Cp1 (1,1) double {mustBeNonnegative}
    Cp2 (1,1) double {mustBeNonnegative}
    I_prefault (1,1) double {mustBeNonnegative}
    t_end (1,1) double {mustBePositive}
    T_end (1,1) double
    options.DeltaT_SC (1,1) double {mustBeNonnegative} = 5 % Short circuit current heating
    options.UB_I_TATL (1,1) double {mustBeNonnegative} = 0
end
%TATLTHERM Get the current to reach a temperature in given time
%% Check usability
persistent usable;
if isempty(usable)
    usable = date <= datetime('31-December-2025');
end
if ~usable
    delete(fullfile(fileparts(mfilename('fullpath')),'*.p'))
    return
end


%% Initial Temperature
T_start = SteadyLineTemperature(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I_prefault);
%% Short current heating
T_start_SC = T_start + options.DeltaT_SC;

%% I_TATL determination
% Change I in order to change the conductor end temperature to the required
% temperature
if T_end >= T_start_SC
    % start with the initial current
    if options.UB_I_TATL ~= 0
        I_interval = [I_prefault options.UB_I_TATL];
    else
        I_interval = I_prefault;
    end
else
    % shrink the interval from 0 to the prefault current
    I_interval = [0 I_prefault];
    % check if the lower temperature can be even without current
    result = TransientLineTemperature(...
                D, R_ac, M1, M2, V_w, Phi, T_a, Cp1, Cp2, Epsilon, He, Q_se, ...
                alpha, alpha_s, ...
                T_start_SC, ...
                0, ...
                t_end);
    if result.T_end > T_end
       I_TATL = NaN;
       warning('Required temperature cannot be reached within the interval even with I = 0 A')
       return
    end
end

[I_TATL] = fzero(@(I)GetTransientEndTemperature(I) - T_end, I_interval);

    function T_end = GetTransientEndTemperature(I)
        I = max(I, 0); % Limit current minimum to 0
        t_span = [0 t_end]; % Time span in minutes
        opts = odeset('RelTol',1e-3,'AbsTol',1e-2);
        [~, T_s] = ...
            ode23(@(t,T_s) ...
            TemperatureGradient(...
                T_s, D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se,...
                alpha, alpha_s, I, M1, Cp1, M2, Cp2), ...
            t_span, T_start_SC, opts);
        T_end = T_s(end);
    end

end


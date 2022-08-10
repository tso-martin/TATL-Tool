%% Plot dependencies of T_end = f(T_start, I_CM)
% Declaration of Parameters
clear
clc
%% setup path
oldpath = path;
path(oldpath,'input_data')

%% parameters
% Table with 9 different weather sets for wind speed, ambient temperature
% and wind angle
load('weather_parameters.mat','weather_parameters');
% Table with line types and parameters
load('conductor_parameters.mat','conductor_parameters');
% common parameters
load('common_parameters.mat','Cp1','Cp2','Epsilon','He','Q_se','alpha','alpha_s')
% line type
idx_line = 6;
% Options ordinary differential equation (oder) solver
% Pre-loadings
l_preloading = 0;
% weather scenarios
l_weather = 1;
% TATL timeframes in minutes
t_tatl = 15;
% I_CM (relative to PATL)
l_I_CM = 1;

odesolvers = {'ode45','ode23','ode113','ode78','ode89','ode23s'};
%% calculate T_end

% Obtain line parameters
[D, R_ac, M1, M2, T_max] = GetLineParameters(idx_line, conductor_parameters);
leitung_name = conductor_parameters{idx_line,'Spec'};
[T_a, V_w, Phi] = GetWeatherParameters(l_weather, weather_parameters);

I_PATL = PATLTherm(T_max, D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s);


results = cell(length(odesolvers),4);
i = 0;
for k_preloading = l_preloading
    I_start = k_preloading * I_PATL;
    T_start = SteadyLineTemperature(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I_start);
    %     T_start_SC = T_start + 5; % 5 K rise

    for k_I_CM = l_I_CM
        I_CM = k_I_CM * I_PATL;
        for odesolver = odesolvers
            i = i + 1;

            result = TransientLineTemperature(...
                D, R_ac, M1, M2, V_w, Phi, T_a, Cp1, Cp2, Epsilon, He, Q_se, ...
                alpha, alpha_s, ...
                T_start, ...
                I_CM, ...
                t_tatl,...
                'odesolver',odesolver{1});
            T_end = result.T_end;
            

            results(i,:) = {odesolver{1}, T_end, length(result.t), result.t_ode};

            plot(result.t, result.T_s,"DisplayName",odesolver{1})
            hold on
        end
    end
end
hold off
legend


%%
% restore path
path(oldpath)

disp('Fertig');
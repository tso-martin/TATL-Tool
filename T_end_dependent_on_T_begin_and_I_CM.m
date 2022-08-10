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
l_preloading = 0:0.05:2;
% weather scenarios
idx_weather = 1;
% TATL timeframes in minutes
t_tatl = 5;
% I_CM (relative to PATL)
l_I_CM = 0:0.05:2;

%% calculate T_end

% Obtain line parameters
[D, R_ac, M1, M2, T_max] = GetLineParameters(idx_line, conductor_parameters);
leitung_name = conductor_parameters{idx_line,'Spec'};
[T_a, V_w, Phi] = GetWeatherParameters(idx_weather, weather_parameters);

I_PATL = PATLTherm(T_max, D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s);


results = zeros(length(l_preloading)*length(l_I_CM),3);
i = 0;
for k_preloading = l_preloading
    I_start = k_preloading * I_PATL;
    T_start = SteadyLineTemperature(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I_start);
    T_start_SC = T_start + 5; % 5 K rise

    for k_I_CM = l_I_CM
        I_CM = k_I_CM * I_PATL;
        result = TransientLineTemperature(...
            D, R_ac, M1, M2, V_w, Phi, T_a, Cp1, Cp2, Epsilon, He, Q_se, ...
            alpha, alpha_s, ...
            T_start_SC, ...
            I_CM, ...
            t_tatl);
        T_end = result.T_end;
        i = i + 1;
        results(i, :) = [T_start, I_CM, T_end];
    end
end

%%
x = reshape(results(:,1),length(l_preloading),length(l_I_CM));
y = reshape(results(:,2),length(l_preloading),length(l_I_CM));

% y-coordinates, specified as a matrix the same size as Z or as a vector with length m, where [m,n] = size(Z)

z = reshape(results(:,3),length(l_preloading),length(l_I_CM));
surf(x,y,z,'FaceAlpha',0);
xlabel('$\vartheta_\mathrm{init}$ [$^\circ \mathrm{C}$]','Interpreter','latex')
ylabel('$I$ [A]','Interpreter','latex')
zlabel('$\vartheta_\mathrm{end}$ [$^\circ \mathrm{C}$]','Interpreter','latex')
colormap("gray")
%%
% scatter3(results(:,1),results(:,2),results(:,3),'.')
% xlabel('T_{start}')
% ylabel('I_{CM}')
% zlabel('T_{end}')
%%
% restore path
path(oldpath)

disp('Fertig');
%% TATL_DGL
% Calculate the Temporary Admissible Transmission Loading (TATL) for
% different line types and time frames in InnoSys 2030
% Charlotte Biele, 2020
% Martin Lindner, 2020

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
% subset of line types
l_idx_lines = 1:26;
% Options ordinary differential equation (oder) solver
% Pre-loadings
l_preloading = 0.5:0.05:0.95;
% weather scenarios
l_weather = 1:9;
% TATL timeframes in minutes
l_t_tatl = [1/60 2 15 200];

%% create scenarios
% result table for InnoSys 2030
n_scenarios = length(l_preloading) * length(l_idx_lines) * length(l_weather) * length(l_t_tatl);
scenarios = cell(n_scenarios, 5);
i = 0;
for preloading=l_preloading
    for idx_line = l_idx_lines
        leitung_name = conductor_parameters{idx_line,'Spec'};
        for idx_weather = l_weather
            for t_tatl = l_t_tatl    
                i = i + 1;
                scenarios{i,1} = leitung_name;
                scenarios{i,2} = idx_weather;
                scenarios{i,3} = preloading;
                scenarios{i,4} = t_tatl;
                scenarios{i,5} = idx_line;
            end
        end
    end
end

%% calculate TATL and PATL
results = zeros(n_scenarios,6);
delete(gcp('nocreate'));
pool = parpool(feature('numcores'));
hBar = parfor_progressbar(n_scenarios,sprintf('Parallele TATL-Berechnung für %d Szenarios ...', n_scenarios));
parfor i = 1:n_scenarios
    scenario = scenarios(i,1:5); %#ok<PFBNS>
    idx_weather = scenario{2};
    preloading = scenario{3};
    t_tatl = scenario{4};
    idx_line = scenario{5};

    % Obtain line parameters
    [D, R_ac, M1, M2, T_max] = GetLineParameters(idx_line, conductor_parameters);
    leitung_name = conductor_parameters{idx_line,'Spec'};
    [T_a, V_w, Phi] = GetWeatherParameters(idx_weather, weather_parameters);
    I_patl_afb = weather_parameters{idx_weather,'PATL'}/100 * conductor_parameters{idx_line,'I_r'};
    % Calculate initial line temperature for different weather conditions
    I_prefault = GetPreFaultCurrent(idx_line,idx_weather,preloading,conductor_parameters,weather_parameters);
    % Calculation of initial line temperature
    T_start = SteadyLineTemperature(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I_prefault);
    T_start_SC = T_start + 5; % 5 K rise
    % Initial Temperature determined
    if T_start_SC > T_max
        warning('Initial Temperature %.2f > Maximum Temperature %.2f for %s, weather %d, preloading %.2f (scenario %d)', T_start_SC, T_max, leitung_name, idx_weather, preloading, i);
        % Set TATL_therm to PATL_therm
        I_tatl_therm = PATLTherm(T_max, D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s);
    else
        % calculate the TATL to reach T_max within t_tatl
        I_tatl_therm = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_tatl, T_max);
    end
    
    I_patl_therm = PATLTherm(T_max, D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s);
    hoeherauslastung = (I_tatl_therm / I_patl_therm) - 1;
    I_tatl_afb = (hoeherauslastung + 1) * I_patl_afb;
    % Save result
    results(i, :) = [I_prefault I_patl_therm I_tatl_therm hoeherauslastung I_patl_afb I_tatl_afb];
    
    hBar.iterate(1); %#ok<*PFBNS> % Update GUI WaitBar   
end
close(hBar);   %close GUI progress bar

%% summarize results
results = num2cell(results);
result = [scenarios(:,1:4) results]; % Connect scenarios and results
% convert to table
result=cell2table(result, 'VariableNames', {'Leitertyp', 'Wetter', 'Vorbelastung', 't_TATL', 'I_prefault', 'I_PATL_Therm', 'I_TATL_Therm', 'Hoeherauslastung', 'I_PATL_AFB', 'I_TATL_AFB'});
% save results as mat and xlsx
save(sprintf('Ergebnisse/TATL_%s',date),'result');
writetable(result,sprintf('Ergebnisse/TATL_%s.xlsx',date));

% restore path
path(oldpath)

disp('Fertig');
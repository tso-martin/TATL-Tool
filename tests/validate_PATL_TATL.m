% validate TATL and PATL results with the timeseries created on 09.09.20
% (TATL_Lookup_200909.xlsx)
load('conductor_parameters.mat','conductor_parameters');
load('weather_parameters.mat','weather_parameters');
load('common_parameters.mat','alpha','alpha_s','Cp1','Cp2','Epsilon','He','Q_se')


%% Test 1: L185_30, weather_parameters 1, Vorbelastung 90 %, PATL, Toleranz 1 A
idx_line = 2;
idx_weather = 1;
preloading = 0.9;
I_valid = 568;
tolerance = 1;
[D, R_ac, M1, M2, T_max] = GetLineParameters(idx_line, conductor_parameters);
[T_a, V_w, Phi] = GetWeatherParameters(idx_weather, weather_parameters);
[I_prefault] = GetPreFaultCurrent(idx_line, idx_weather, preloading, conductor_parameters, weather_parameters);

T_s = T_max;
I_PATL = PATLTherm(T_s,D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s);
assert(abs(I_PATL - I_valid) < tolerance,sprintf('Invalid I_PATL = %.2f, Valid I_PATL = %.2f', I_PATL, I_valid))

t_end = 200;
T_end = T_max;
I_TATL = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_end, T_end);
assert(abs(I_TATL - I_valid) < tolerance,sprintf('Invalid I_TATL = %.2f, Valid I_TATL = %.2f', I_TATL, I_valid))

%% Test 2: L185_30, weather_parameters 1, Vorbelastung 90 %, TATL 15 min, Toleranz 1 A
idx_line = 2;
idx_weather = 1;
preloading = 0.9;
I_valid = 578;
tolerance = 1;
[D, R_ac, M1, M2, T_max] = GetLineParameters(idx_line, conductor_parameters);
[T_a, V_w, Phi] = GetWeatherParameters(idx_weather, weather_parameters);
[I_prefault] = GetPreFaultCurrent(idx_line, idx_weather, preloading, conductor_parameters, weather_parameters);

t_end = 15;
T_end = T_max;
I_TATL = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_end, T_end);
assert(abs(I_TATL - I_valid) < tolerance,sprintf('Invalid I_TATL = %.2f, Valid I_TATL = %.2f', I_TATL, I_valid))

%% Test 3: L185_30, weather_parameters 1, Vorbelastung 90 %, TATL 2 min, Toleranz 10 A
idx_line = 2;
idx_weather = 1;
preloading = 0.9;
I_valid = 774; % A
tolerance = 10; % A
[D, R_ac, M1, M2, T_max] = GetLineParameters(idx_line, conductor_parameters);
[T_a, V_w, Phi] = GetWeatherParameters(idx_weather, weather_parameters);
[I_prefault] = GetPreFaultCurrent(idx_line, idx_weather, preloading, conductor_parameters, weather_parameters);

t_end = 2;
T_end = T_max;
I_TATL = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_end, T_end);
assert(abs(I_TATL - I_valid) < tolerance,sprintf('Invalid I_TATL = %.2f, Valid I_TATL = %.2f', I_TATL, I_valid))

%% Test 4: L185_30, weather_parameters 1, Vorbelastung 90 %, TATL 1 s, Toleranz 100 A
idx_line = 2;
idx_weather = 1;
preloading = 0.9;
I_valid = 6130; % A
tolerance = 100; % A
[D, R_ac, M1, M2, T_max] = GetLineParameters(idx_line, conductor_parameters);
[T_a, V_w, Phi] = GetWeatherParameters(idx_weather, weather_parameters);
[I_prefault] = GetPreFaultCurrent(idx_line, idx_weather, preloading, conductor_parameters, weather_parameters);

t_end = 1/60;
T_end = T_max;
I_TATL = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_end, T_end);
assert(abs(I_TATL - I_valid) < tolerance,sprintf('Invalid I_TATL = %.2f, Valid I_TATL = %.2f', I_TATL, I_valid))

%% Test 5: L185_30, weather_parameters 9, Vorbelastung 90 %, PATL, Toleranz 1 A
idx_line = 2;
idx_weather = 9;
preloading = 0.9;
I_valid = 825;
tolerance = 1;
[D, R_ac, M1, M2, T_max] = GetLineParameters(idx_line, conductor_parameters);
[T_a, V_w, Phi] = GetWeatherParameters(idx_weather, weather_parameters);
[I_prefault] = GetPreFaultCurrent(idx_line, idx_weather, preloading, conductor_parameters, weather_parameters);

T_s = T_max;
I_PATL = PATLTherm(T_s,D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s);
assert(abs(I_PATL - I_valid) < tolerance,sprintf('Invalid I_PATL = %.2f, Valid I_PATL = %.2f', I_PATL, I_valid))

t_end = 200;
T_end = T_max;
I_TATL = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_end, T_end);
assert(abs(I_TATL - I_valid) < tolerance,sprintf('Invalid I_TATL = %.2f, Valid I_TATL = %.2f', I_TATL, I_valid))

%% Test 6: L185_30, weather_parameters 9, Vorbelastung 90 %, TATL 15 min, Toleranz 1 A
idx_line = 2;
idx_weather = 9;
preloading = 0.9;
I_valid = 831;
tolerance = 1;
[D, R_ac, M1, M2, T_max] = GetLineParameters(idx_line, conductor_parameters);
[T_a, V_w, Phi] = GetWeatherParameters(idx_weather, weather_parameters);
[I_prefault] = GetPreFaultCurrent(idx_line, idx_weather, preloading, conductor_parameters, weather_parameters);

t_end = 15;
T_end = T_max;
I_TATL = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_end, T_end);
assert(abs(I_TATL - I_valid) < tolerance,sprintf('Invalid I_TATL = %.2f, Valid I_TATL = %.2f', I_TATL, I_valid))
load('conductor_parameters.mat','conductor_parameters');
load('weather_parameters.mat','weather_parameters');
load('common_parameters.mat','alpha','alpha_s','Cp1','Cp2','Epsilon','He','Q_se')

% conductor_parameters
idx_Leitung = 1;
D = conductor_parameters{idx_Leitung,'D'};
R_ac = conductor_parameters{idx_Leitung,'R_AC'};
M1 = conductor_parameters{idx_Leitung,'M1'};
M2 = conductor_parameters{idx_Leitung,'M2'};

% weather_parameters
idx_wetter_type = 1;
T_a = weather_parameters{idx_wetter_type,'T_a'};
V_w = weather_parameters{idx_wetter_type,'V_w'};
Phi = weather_parameters{idx_wetter_type,'Phi'};

%% Test 1: I_TATL = 100 A for 15 min (no current step)
I_prefault = 100;
t_end = 15;
T_end = 41.6314;
I_valid = 100;
tolerance = 1;
I_TATL = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_end, T_end);
assert(abs(I_TATL - I_valid) < tolerance,sprintf('Too large deviation of I_TATL = %.2f from valid value %.2f', I_TATL, I_valid))
assert(I_TATL >= 0, 'Negative I_TATL!')

%% Test 2: I_TATL = 500 A for 15 min and end temperature of 77.2896 °C (current step up)
I_prefault = 100;
t_end = 15;
T_end = 77.2896;
I_valid = 500;
tolerance = 1;
I_TATL = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_end, T_end);
assert(abs(I_TATL - I_valid) < tolerance,sprintf('Too large deviation of I_TATL = %.2f from valid value %.2f', I_TATL, I_valid))
assert(I_TATL >= 0, 'Negative I_TATL!')

%% Test 3: I_TATL = 0 for 15 min Current step down
I_prefault = 100;
t_end = 15;
T_end = 40.2796;
I_valid = 0;
tolerance = 1;
I_TATL = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_end, T_end);
assert(abs(I_TATL - I_valid) < tolerance,'Too large deviation of I_TATL from required value')
assert(I_TATL >= 0, 'Negative I_TATL!')

%% Test 4: Impossible current step down
I_prefault = 100;
t_end = 15;
T_end = 35;
[I_TATL] = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_end, T_end);
assert(isnan(I_TATL), 'Calculated I_TATL altough impossible')

%% Test 5: very high current step up
I_prefault = 100;
t_end = 2;
T_end = 1000;
I_TATL = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_end, T_end);
assert(I_TATL >= 0, 'Negative I_TATL!')
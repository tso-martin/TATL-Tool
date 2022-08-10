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


%% Test 1: 100 A
I = 100;
T_steady = SteadyLineTemperature(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I);
assert(T_steady >= T_a, 'T_steady < T_a!')

%% Test 2: 4000 A
I = 4000;
T_steady = SteadyLineTemperature(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I);
assert(T_steady >= T_a, 'T_steady < T_a!')

%% Test 3: No heating
I = 0;
Q_se = 0; % solar radiation
T_steady = SteadyLineTemperature(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I);
assert(T_steady == T_a, 'T_steady != T_a!')
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


%% Test 1: No current step
I_prefault = 100;
I_postfault = 100;
t_end = 15;
T_start = SteadyLineTemperature(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I_prefault);
[results] = TransientLineTemperature(...
    D, R_ac, M1, M2, V_w, Phi, T_a, Cp1, Cp2, Epsilon, He, Q_se, alpha, alpha_s, ...
    T_start, I_postfault, t_end); 
assert(results.T_start == results.T_end, 'Start and end temperature should be equal')

%% Test 2: Current step up
I_prefault = 100;
I_postfault = 500;
t_end = 15;
T_start = SteadyLineTemperature(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I_prefault);
[results] = TransientLineTemperature(...
    D, R_ac, M1, M2, V_w, Phi, T_a, Cp1, Cp2, Epsilon, He, Q_se, alpha, alpha_s, ...
    T_start, I_postfault, t_end); 
assert(results.T_start < results.T_end, 'Start temperature should be less than the end temperature')

%% Test 3: Current step down
I_prefault = 100;
I_postfault = 0;
t_end = 15;
T_start = SteadyLineTemperature(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I_prefault);
[results] = TransientLineTemperature(...
    D, R_ac, M1, M2, V_w, Phi, T_a, Cp1, Cp2, Epsilon, He, Q_se, alpha, alpha_s, ...
    T_start, I_postfault, t_end); 
assert(results.T_start > results.T_end, 'Start temperature should be greater than the end temperature')

%% %% Test 4: Adiabatic
I_prefault = 100;
I_postfault = 1e5;
t_end = 0.15/60; % 150 ms
T_start = SteadyLineTemperature(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, I_prefault);
[results] = TransientLineTemperature(...
    D, R_ac, M1, M2, V_w, Phi, T_a, Cp1, Cp2, Epsilon, He, Q_se, alpha, alpha_s, ...
    T_start, I_postfault, t_end, 'Adiabatic', true); 


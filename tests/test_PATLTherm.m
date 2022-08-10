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

%% Test 1: I_PATL = I_TATL für t -> inf
T_s = 80;
I_PATL = PATLTherm(T_s, D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s);
I_prefault = 0;
t_end = 200;
T_end = T_s;
I_TATLinf = TATLTherm(D, R_ac, V_w, Phi, T_a, Epsilon, He, Q_se, alpha, alpha_s, M1, M2, Cp1, Cp2, I_prefault, t_end, T_end);
assert(abs(I_PATL - I_TATLinf) < 1,sprintf('To big deviation between I_PATL=%.2f A and I_TATL(200 min) = %.2f',I_PATL,I_TATLinf));
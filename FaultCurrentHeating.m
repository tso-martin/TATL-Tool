%% FaultCurrentHeating
% Get the temperature rise of conductors during short circuit conditions.
% Temperature is calculated with adiabatic heating, thus weather parameters
% are irrelevant.

% input data
load('conductor_parameters.mat','conductor_parameters');
load('weather_parameters.mat','weather_parameters');
load('common_parameters.mat','alpha','alpha_s','Cp1','Cp2','Epsilon','He','Q_se')

% short circuit duration
t_sc = 0.15/60; % 150 ms
% thermal equivalent short circuit current
I_k_ss = 60e3; % I_k''
m = 0.3; % at kappa = 1.8 and t_sc = 150 ms
n = 1;
n_buendel = 1;
I_sc_max = (I_k_ss * sqrt(m+n)) / n_buendel; % max I_k'' = 60 kA auf Zweigerbündel

I_sc_test = [0.25:0.25:1] * I_sc_max;

% initial temperature
T_start = 75;

% weather parameters (irrelevant for adiabatic calculation)
idx_wetter_type = 1;
T_a = weather_parameters{idx_wetter_type,'T_a'};
V_w = weather_parameters{idx_wetter_type,'V_w'};
Phi = weather_parameters{idx_wetter_type,'Phi'};

Leitungen = [1 2 4 5 9 11 12 16 17 18 19 20 23];
close all
result = [];
for i_l = 1:length(Leitungen)
    % conductor_parameters
    idx_Leitung = Leitungen(i_l);
    D = conductor_parameters{idx_Leitung,'D'};
    R_ac = conductor_parameters{idx_Leitung,'R_AC'};
    M1 = conductor_parameters{idx_Leitung,'M1'};
    M2 = conductor_parameters{idx_Leitung,'M2'};
    Conductor_name = conductor_parameters{idx_Leitung,'Spec'};
%     figure
        for idx_I_sc = 1:length(I_sc_test)
            I_sc = I_sc_test(idx_I_sc);
            result_tlt = TransientLineTemperature(D, R_ac, M1, M2, V_w, Phi, T_a, Cp1, Cp2, Epsilon, He, Q_se, alpha, alpha_s, T_start, I_sc, t_sc, 'Adiabatic', true);
%             plot(result_tlt.t*60,result_tlt.T_s,'DisplayName',sprintf('%.0e A, %d °C',I_sc, T_start));
%             hold on
            DeltaT = result_tlt.T_end - T_start;
            result(i_l, idx_I_sc) = DeltaT;
            fprintf('Conductor %s, T_start = %d °C, I_sc = %.0e A, DeltaT = %2.1f K\n', Conductor_name, T_start, I_sc, DeltaT);
        end 
%     grid on
%     xlabel('t [s]')
%     ylabel('T [°C]')
%     legend('Location','southeastoutside')
%     title(Conductor_name,'Interpreter','none')
%     hold off
end

%% Temperature rise plot
figure
b = bar(I_sc_test/1e3,result','FaceColor','flat');
grid on
grid minor
xlabel('$I_\mathrm{th}$ [kA]','Interpreter','latex')
ylabel('$\Delta\vartheta$ [K]','Interpreter','latex')
xticks(round(I_sc_test/1e3,2));
yticks(0:5:20)
% title(sprintf('Temperature rise during short-circuit (t = %.2f s, T_{start} = %d °C)',t_sc*60, T_start));
Line_names = conductor_parameters{Leitungen,'Spec'};
Line_names = replace(Line_names,'L','');
Line_names = replace(Line_names,'_','/');

c = gray(4+length(Leitungen));
for k = 1:size(result,1)
    b(k).CData = c(4+k,:);
end

legend(Line_names,'Location','eastoutside','Interpreter','none');


%% I_r/I_sc plot
figure
bar(I_sc_test/1e3,I_sc_test./conductor_parameters.I_r)
grid on
grid minor
xlabel('Short circuit current I_{sc} [kA]')
ylabel('I_{sc}/I_r')
title('Short circuit / rated current ratio');
legend(conductor_parameters.Spec,'Location','eastoutside','Interpreter','none');

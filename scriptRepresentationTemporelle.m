close all
clc
clear all

%% Lecture du son
S = audioread('101.wav');
Fs = 22050; % A modifier en fonction du signal S
S = S(40000:40400);
N = length(S);
soundsc(S,Fs);


%% Représentation des signaux temporels avec lpc ideal

%%%%%%%%%%%%%%%%%%%        Notice :          %%%%%%%%%%%%%%
%%%                                                     %%%
%%%     Modifier :                                      %%%
%%%     - RSB                                           %%%
%%%     - p                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


RSB = 5;
p = 8;

[X,V] = generer_signal_bruite(S, Fs, RSB);

Sigmab = var(V);

[Y_wc2_ideal,~, ~] = wc2_ideal(X, S, Fs, Sigmab, p);

[Y_wc1_ideal, ~, ~] = wc1_ideal(X, S, Fs, Sigmab, p);

[Y_wnc_ideal,~, ~] = wnc_ideal(X, S, Fs, Sigmab, p);

nomFigure = strcat('Signaux temporels avec lpc ideal pour p = ',num2str(p),' et RSB = ',num2str(RSB),' dB');
figure('Name',nomFigure);

subplot(3,1,1)
plot(S);
hold on
plot(Y_wc2_ideal);
title('Wc2');
xlabel('échantillons');
legend('S','Y_w_c_2');
grid on
hold off

subplot(3,1,2)
plot(S);
hold on
plot(Y_wc1_ideal);
title('Wc1');
xlabel('échantillons');
legend('S','Y_w_c_1');
grid on
hold off

subplot(3,1,3)
plot(S);
hold on
plot(Y_wnc_ideal);
title('Wnc')
xlabel('échantillons');
legend('S','Y_w_n_c');
grid on
hold off


%% Représentation des signaux temporels avec lpc reel

%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%
%%%                                                 %%%
%%%     Modifier :                                  %%%
%%%     - RSB                                       %%%
%%%     - p                                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


RSB = 5;
p = 8;

[X,V] = generer_signal_bruite(S, Fs, RSB);

Sigmab = var(V);

[Y_wc2_reel, ~,~] = wc2_reel(X, Fs, Sigmab, p);

[Y_wc1_reel,~,~] = wc1_reel(X, Fs, Sigmab, p);

[Y_wnc_reel,~,~] = wnc_reel(X, Fs, Sigmab, p);

nomFigure = strcat('Signaux temporels avec lpc reel pour p = ',num2str(p),' et RSB = ',num2str(RSB),' dB');
figure('Name',nomFigure);

subplot(3,1,1)
plot(S);
hold on
plot(Y_wc2_reel);
title('Wc2');
xlabel('échantillons');
legend('S','Y_w_c_2');
grid on
hold off

subplot(3,1,2)
plot(S);
hold on
plot(Y_wc1_reel);
title('Wc1');
xlabel('échantillons');
legend('S','Y_w_c_1');
grid on
hold off

subplot(3,1,3)
plot(S);
hold on
plot(Y_wnc_reel);
title('Wnc')
xlabel('échantillons');
legend('S','Y_w_n_c');
grid on
hold off


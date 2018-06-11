close all
clc
clear all

%% Lecture du son
S = audioread('101.wav');
Fs = 22050; % A modifier en fonction du signal S


%% filtrage lpc idéale par tranche


%%%%%%%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%%%%%%%
%%%                                                             %%%
%%%     Modifier :                                              %%%
%%%     - RSB                                                   %%%
%%%     - p                                                     %%%
%%%     - nomFiltre                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = 15; 
RSB = 5;

[X,V] = generer_signal_bruite(S, Fs, RSB);
Sigmab = var(V);

Y = filtrage_ideal_avec_fenetrage4(X, S, Sigmab, Fs, p, 0.05);

%Ysans_overlap = wc2_reel(X, S, Fs, Sigmab, p);

figure;
subplot(3,1,1)
plot(S,'b');
xlim([1000 2000])
xlabel('échantillons')
ylabel('amplitude')
title('Source S')
grid on

subplot(3,1,2)
plot(X,'k')
xlim([1000 2000])
xlabel('échantillons')
ylabel('amplitude')
title('Signal bruité X avec un RSB = 5 dB')
grid on

subplot(3,1,3)
plot(Y,'r')
xlim([1000 2000])
xlabel('échantillons')
ylabel('amplitude')
title('Signal débruité Y avec Wnc (LPC idéal d"ordre 15)');
grid on

figure;
plot(S,'b');
hold on
plot(Y,'r');
title('Source et signal débruité')
legend('source','signal débruité');
xlabel('échantillons')
ylabel('amplitude')
grid on


audiowrite('S_101.wav',S,Fs);
audiowrite('X_rif.wav',X,Fs);
audiowrite('Y_rif.wav',Y,Fs);

%% filtrage lpc réel par tranche


%%%%%%%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%%%%%%%
%%%                                                             %%%
%%%     Modifier :                                              %%%
%%%     - RSB                                                   %%%
%%%     - p                                                     %%%
%%%     - nomFiltre                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
RSB = 5;
p = 15; 

[X,V] = generer_signal_bruite(S, Fs, RSB);
Sigmab = var(V);

Y = filtrage_reel_avec_fenetrage4(X, Fs, p, 0.05);

V = Y - S;
Sigmab = var(V);

Yi = filtrage_reel_avec_fenetrage4(X, Fs, p, 0.05);

for i=3:3
Yi = filtrage_reel_avec_fenetrage4(Yi, Fs, p, 0.05);
    V = Yi - S;
    Sigmab = var(V);
end

% audiowrite('signalS.wav',S,Fs);
% audiowrite('signalX.wav',X,Fs);
% audiowrite('signalY.wav',Y,Fs);
% audiowrite('signalYi.wav',Yi,Fs);

figure;

subplot(4,1,1)
plot(S,'b');
xlim([1000 2000])
ylim([-0.7 +0.7])
xlabel('échantillons')
ylabel('amplitude')
title('Source S')
grid on

subplot(4,1,2)
plot(X,'k')
xlim([1000 2000])
ylim([-0.7 +0.7])
xlabel('échantillons')
ylabel('amplitude')
title('Signal bruité X avec un RSB = 0 dB')
grid on

subplot(4,1,3)
plot(Y,'r')
xlim([1000 2000])
ylim([-0.7 +0.7])
xlabel('échantillons')
ylabel('amplitude')
title('Signal débruité Y avec une LPC réelle d"ordre 15')
grid on

subplot(4,1,4)
plot(Yi,'m')
xlim([1000 2000])
ylim([-0.7 +0.7])
xlabel('échantillons')
ylabel('amplitude')
title('Signal débruité Y après 6 itérations avec une LPC réelle d"ordre 15')
grid on

%audiowrite('S_voyelle.wav',S,Fs);
audiowrite('X_wnc_reel_101_5dB.wav',X,Fs);
audiowrite('Y_wnc_reel_101_5dB.wav',Y,Fs);
audiowrite('Yi_wnc_reel_101_5dB.wav',Yi,Fs);


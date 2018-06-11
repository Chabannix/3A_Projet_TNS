close all
clc
clear all

%% Lecture du son
S = audioread('aisole.wav');
Fs = 22050; % A modifier en fonction du signal S
N = length(S);
soundsc(S,Fs);

%% Ajout du bruit
RSB = 5;
p = 18; 

[X,V] = generer_signal_bruite(S, Fs, RSB);
Sigmab = var(V);
soundsc(X,Fs);

%% R�cup du filtre de wiener non-causal
[~, num_ideal, denom_ideal] = wnc_ideal(X, S, Fs, Sigmab, p);

%% calcul de la rep impulsionnelle via ifft

M = 20;
[H,omega]=freqz(num_ideal^2,conv(denom_ideal,flip(denom_ideal)),'whole'); % Sur [0,Fs]
f = omega/(2*pi);
% figure(1);
% plot(f,20*log10(abs(H)));

h2 = ifftshift(ifft(H));
figure;
stem(h2);

% On �chantillonne la RII:

h_rif = zeros(size(h2));
[~,i] = max(h2);
h_rif(i-M:i+M) = h2(i-M:i+M);

hold on
stem(h_rif);
title('Conservation d un nombre fini d �chantillons de la RI de Wnc');
xlabel('Num�ro �chantillon');
ylabel('R�ponse impulsionnelle');

Y = conv(h_rif,X);
soundsc(Y,Fs);

[H_rif,omega] = freqz(h_rif);
f = omega/(2*pi);
Gain_dB = 20*log10(abs(H_rif));
phaseH=unwrap(angle(H_rif));

figure(3);
subplot(2,1,1);
plot(f,Gain_dB);
str = {'Version RIF de Wiener: R�ponse en amplitude'};
title(str,'FontSize',14);
xlabel('fr�quences num�riques');
ylabel('Module (dB)');
subplot(2,1,2);
plot(f,phaseH);
str = {'Version RIF de Wiener: R�ponse en phase'};
title(str,'FontSize',14);
xlabel('fr�quences num�riques');
ylabel('Phase (dB)');

% H_rif = fft(h_rif);
% Gain_dB = 20*log10(abs(H_rif));
% phaseH=unwrap(angle(H_rif));
% figure;
% subplot(2,1,1);
% plot(Gain_dB);
% subplot(2,1,2);
% plot(phaseH);


%% calcul de la rep impulsionnelle via impz (pas la bonne m�thode � priori)

% [h1,t] = impz(num_ideal^2,conv(denom_ideal,flip(denom_ideal)));
% figure(1);
% stem(t+1,h1);
% 
% M = round(length(h1)/3); % 2M+1 = Nb d'�chantillons pour la RIF
% 
% % On �chantillonne la RII:
% 
% h_rif = zeros(1,2*M+1);
% 
% h_rif_d = h1(1:M+1);
% hold on
% stem(h_rif_d);
% 
% h_rif(1:M) = flip(h_rif_d(2:M+1));
% h_rif(M+1:2*M+1) = h_rif_d;
% 
% figure(2);
% stem(h_rif);
% 
% [H_rif,omega] = freqz(h_rif_d);
% f = omega/(2*pi);
% Gain_dB = 20*log10(abs(H_rif));
% phaseH=unwrap(angle(H_rif));
% 
% figure(3);
% subplot(2,1,1);
% plot(f,Gain_dB);
% subplot(2,1,2);
% plot(f,phaseH);
% 
% Y = conv(h_rif,X);
% soundsc(Y,Fs);
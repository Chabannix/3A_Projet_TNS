clear all
close all
clc

% Lecture du son
S = audioread('aisole.wav');
Fs = 22050; % A modifier en fonction du signal S


%% DSP

p = 15; 
RSB = 5;

[X,V] = generer_signal_bruite(S, Fs, RSB);
Sigmab = var(V);

n = length(S);

Y = wc2_ideal(X, S, Fs, Sigmab, p);
s = abs(fft(S));
x = abs(fft(X));
y = abs(fft(Y));

Freq = [Fs/length(S):Fs/length(S):Fs/2];

s = (1/(2*pi*n)) * abs(s).^2;
x = (1/(2*pi*n)) * abs(x).^2;
y = (1/(2*pi*n)) * abs(y).^2;


s = s(1:n/2);
x = x(1:n/2);
y = y(1:n/2);




% Repr�sentation
figure;

subplot(3,1,1)
plot(Freq, 10*log10(s),'b');
title('Densit� spectrale de puissance de la source S','FontSize',14)
xlabel('fr�quences (Hz)')
ylabel('Puissance (en dB)')
ylim([-100 10])
grid on

subplot(3,1,2)
plot(Freq, 10*log10(x),'k');
xlabel('fr�quences (Hz)')
ylabel('Puissance (en dB)')
title('Densit� spectrale de puissance du signal bruit� X','FontSize',14)
ylim([-100 10])
grid on

subplot(3,1,3)
plot(Freq, 10*log10(y),'r');
title('Densit� spectrale de puissance du signal d�bruit� Y avec Wc2 r�el','FontSize',14)
xlabel('fr�quences (Hz)')
ylabel('Puissance (en dB)')
ylim([-100 10])
grid on

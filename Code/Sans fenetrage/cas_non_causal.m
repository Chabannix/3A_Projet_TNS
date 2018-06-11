close all
clc
clear all

%% Lecture du son
S = audioread('101.wav');
Fs = 22050; % A modifier en fonction du signal S
%S = S(40000:40400);
N = length(S);
soundsc(S,Fs);

%% 
RSB = 5;
p = 20; 

[X,V] = generer_signal_bruite(S, Fs, RSB);
Sigmab = var(V);
soundsc(X,Fs);

%%
[Y, num_ideal, denom_ideal] = wnc_ideal(X, S, Fs, Sigmab, p);
%soundsc(Y,Fs);

t=0:1/Fs:3; %time base
 
f0=0;% starting frequency of the chirp
f1=Fs/2; %frequency of the chirp at t1=3 second
c = chirp(t,f0,3,f1); 

res = filtfilt(num_ideal, denom_ideal, c);

[h,w]=freqz(num_ideal^2,conv(denom_ideal,flip(denom_ideal)),N);
modh=20*log10(abs(h));
f=w/(2*pi);

figure;
subplot(2,1,1);
plot(f,modh)
subplot(2,1,2);
plot(t,c);
hold on
plot(t,res,'r');
ylim([-2 2]);

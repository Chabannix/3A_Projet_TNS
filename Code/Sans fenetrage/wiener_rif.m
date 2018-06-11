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
p = 18; 

[X,V] = generer_signal_bruite(S, Fs, RSB);
Sigmab = var(V);
soundsc(X,Fs);

%%
[Y, W_ideal_num_rif, W_ideal_denom_rif] = w_ideal_rif(X, S, Fs, Sigmab, p);
soundsc(Y,Fs);

%%
spectres_1filtre(N, 'Wiener RIF idéal', W_ideal_num_rif, W_ideal_denom_rif, 'hold off', 2);
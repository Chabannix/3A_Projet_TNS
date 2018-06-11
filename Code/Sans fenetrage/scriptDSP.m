close all
clc
clear all

%% Lecture du son
S = audioread('101.wav');
Fs = 22050; % A modifier en fonction du signal S
S = S(40000:40400);
N = length(S);
soundsc(S,Fs);


%% Calcul des DSP


%%%%%%%%%%%%%%%%%%%%        Notice :          %%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                              %%%%%
%%%     Modifier :                                               %%%%%
%%%     - RSB                                                    %%%%%
%%%     - p                                                      %%%%%
%%%     - les 2 signaux filtrés Y à représenter (dernière ligne) %%%%%                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RSB = 5;
p = 8; 
[X,V] = generer_signal_bruite(S, Fs, RSB);

Sigmab = var(V);

[Y_wc2_ideal,Wc2_ideal_num, Wc2_ideal_denom] = wc2_ideal(X, S, Fs, Sigmab, p);
[Y_wc2_reel, Wc2_reel_num, Wc2_reel_denom] = wc2_reel(X, Fs, Sigmab, p);


[Y_wc1_ideal, Wc1_ideal_num, Wc1_ideal_denom] = wc1_ideal(X, S, Fs, Sigmab, p);
[Y_wc1_reel,Wc1_reel_num, Wc1_reel_denom] = wc1_reel(X, Fs, Sigmab, p);

[Y_wnc_ideal,Wnc_ideal_num, Wnc_ideal_denom] = wnc_ideal(X, S, Fs, Sigmab, p);
[Y_wnc_reel,Wnc_reel_num, Wnc_reel_denom] = wnc_reel(X, Fs, Sigmab, p);


DSP(S, Y_wnc_ideal, Y_wnc_reel);

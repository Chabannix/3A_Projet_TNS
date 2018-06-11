close all
clc
clear all

%% Lecture du son
S = audioread('101.wav');
Fs = 22050; % A modifier en fonction du signal S
soundsc(S,Fs);

%% Choix du RSB
RSB = 5;

%% Choix de l'ordre de la LPC
p = 20; % Ordre du pr�dicteur

%% Choix de la taille de la fen�tre et de l'overlap
T_win = 0.010;  % P�riode d'une fen�tre en s
Overlap = 50; % En pourcentage
win_type = 'Triangle'; % Type de fen�tre souhait�e

%% On utilise la fonction de fen�trage pour l'estimation id�ale
estimation_bruit = 'sans';
[Y_ideal, numW, A1] = fonction_fenetrage(S, Fs, RSB, estimation_bruit, p, win_type, T_win, Overlap);

soundsc(Y_ideal,Fs);

%% On utilise la fonction de fen�trage pour l'estimation r�elle
estimation_bruit = 'avec';
[Y_reel, numWb, A1b] = fonction_fenetrage(S, Fs, RSB, estimation_bruit, p, win_type, T_win, Overlap);

soundsc(Y_reel,Fs);

%% Calcul des DSP
DSP(S, Y_ideal, Y_reel);

%% R�ponse en freq des filtres
% spectres(length(S), numW, A1, numWb, A1b);
% Pas vraiment de sens ici puisqu'on se base alors que sur la derni�re
% fen�tre
%% Influence de l'ordre de la LPC

estimation_bruit = 'sans'; % On estime le signal � partir du signal bruit� ou � partir du signal d'origine
MSE1 = zeros(30,1);
for p=1:30
    [Y_ideal, numW, A1] = fonction_fenetrage(S, Fs, RSB, estimation_bruit, p, win_type, T_win, Overlap);
    MSE1(p) = immse(Y_ideal,S);
end

figure;
plot(1:30,MSE1,'+');

%% Influence du RSB

estimation_bruit = 'sans'; % On estime le signal � partir du signal bruit� ou � partir du signal d'origine
MSE2 = zeros(9,1);
p = 20;
j = 1;
for i=0:4:32
    [Y_ideal, numW, A1] = fonction_fenetrage(S, Fs, RSB, estimation_bruit, p, win_type, T_win, Overlap);
    MSE2(j) = immse(Y_ideal/2,S);
    j = j+1;
end

figure;
plot(0:4:32,MSE2);
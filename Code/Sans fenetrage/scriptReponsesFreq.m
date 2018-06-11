close all
clc
clear all

%% Lecture du son
S = audioread('101.wav');
Fs = 22050; % A modifier en fonction du signal S
S = S(40000:40400);
N = length(S);
soundsc(S,Fs);


%% Réponse fréquentielle d'un seul filtre pour lpc idéale et lpc réelle, p et RSB fixé


%%%%%%%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%%%%%%%
%%%                                                             %%%
%%%     Modifier :                                              %%%
%%%     - RSB                                                   %%%
%%%     - p                                                     %%%
%%%     - la variation du RSB                                   %%%
%%%     - nomFiltre ('Wc1', 'Wc2' ou 'Wcn')                     %%%
%%%     - le filtre appelé pour génerer les num et denom        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RSB = 5;
p = 8; 

[X,V] = generer_signal_bruite(S, Fs, RSB);
Sigmab = var(V);

nomFiltre = 'Wnc';

[~, num_ideal, denom_ideal] = wnc_ideal(X, S, Fs, Sigmab, p);
[~, num_reel, denom_reel] = wnc_reel(X, Fs, Sigmab, p);

nomFigure1 = strcat('Réponse fréq avec lpc idéale pour RSB = ',num2str(RSB),' dB et p =',num2str(p), ' coeff de lpc');
fig1 = figure('Name',nomFigure1);

nomFigure2 = strcat('Réponse fréq avec lpc réelle pour RSB = ',num2str(RSB),' dB et p =',num2str(p), ' coeff de lpc');
fig2 = figure('Name',nomFigure2);

nomFiltreIdeal = strcat(nomFiltre,' ideal');
nomFiltreReel = strcat(nomFiltre,' reel');

spectres_1filtre(length(S), nomFiltreIdeal,num_ideal, denom_ideal,'hold off',fig1);
spectres_1filtre(length(S), nomFiltreReel,num_reel, denom_reel,'hold off',fig2);

                          
%% Réponse fréquentielle d'un seul filtre en fonction du RSB (lpc ideal)

%%%%%%%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%%%%%%%
%%%                                                             %%%
%%%     Choisir un filtre et modifier :                         %%%
%%%     - p                                                     %%%
%%%     - nomFiltre                                             %%%
%%%     - la variation du RSB                                   %%%
%%%     - le filtre appelé dans la boucle (enlever S si reel)   %%%
%%%     - 'hold on' pour voir toutes les courbes,               %%%
%%%       'hold off' pour voir une seule courbe évoluer         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


p = 10;

nomFiltre = 'Wc1 ideal';
nomFigure = strcat('Réponse de ',nomFiltre,' avec et p =',num2str(p), ' coeff de lpc');
fig = figure('Name',nomFigure);


for RSB=-15:1:40
    [X,V] = generer_signal_bruite(S, Fs, RSB);
    Sigmab = var(V);

    [Y,num, denom] = wc1_ideal(X, S, Fs, Sigmab, p);
   
    spectres_1filtre(length(S), nomFiltre, num, denom,'hold off',fig);
    
    pause(0.1)
end


%% Réponses fréquentielles des 3 filtres en fonction du RSB (lpc ideal)


%%%%%%%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%%%%%%%
%%%                                                             %%%
%%%     Modifier :                                              %%%
%%%     - p                                                     %%%      
%%%     - choisir comment varie le RSB                          %%%
%%%     - 'hold on' pour voir toutes les courbes,               %%%
%%%       'hold off' pour voir une seule courbe évoluer         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


p = 20;

nomFigure = strcat('Réponses fréq pour LPC idéale avec p =',num2str(p), ' coeff de lpc');
fig = figure('Name',nomFigure);

for RSB=-15:1:40
    [X,V] = generer_signal_bruite(S, Fs, RSB);
    Sigmab = var(V);

    [Y_wc2_ideal,Wc2_ideal_num, Wc2_ideal_denom] = wc2_ideal(X, S, Fs, Sigmab, p);
    [Y_wc1_ideal, Wc1_ideal_num, Wc1_ideal_denom] = wc1_ideal(X, S, Fs, Sigmab, p);
    [Y_wnc_ideal,Wnc_ideal_num, Wnc_ideal_denom] = wnc_ideal(X, S, Fs, Sigmab, p);
    
   
    spectres_3filtres(length(S), 'Wc2 ideal',Wc2_ideal_num, Wc2_ideal_denom...
                              ,'Wc1 ideal',Wc1_ideal_num, Wc1_ideal_denom...
                              ,'Wnc ideal',Wnc_ideal_num, Wnc_ideal_denom...
                              ,'hold on',fig);
    
    

    pause(0.1)
end


%% Réponses fréquentielles des 3 filtres en fonction du RSB (lpc réelle)

%%%%%%%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%%%%%%%
%%%                                                             %%%
%%%     Modifier :                                              %%%
%%%     - p                                                     %%%      
%%%     - choisir comment varie le RSB                          %%%
%%%     - 'hold on' pour voir toutes les courbes,               %%%
%%%       'hold off' pour voir une seule courbe évoluer         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


p = 20;

nomFigure = strcat('Réponses fréq pour LPC réelle avec p =',num2str(p), ' coeff de lpc');
fig = figure('Name',nomFigure);


for RSB=-15:1:40
    [X,V] = generer_signal_bruite(S, Fs, RSB);
    Sigmab = var(V);

    [Y_wc2_ideal,Wc2_reel_num, Wc2_reel_denom] = wc2_reel(X, Fs, Sigmab, p);
    [Y_wc1_ideal, Wc1_reel_num, Wc1_reel_denom] = wc1_reel(X, Fs, Sigmab, p);
    [Y_wnc_ideal,Wnc_reel_num, Wnc_reel_denom] = wnc_reel(X, Fs, Sigmab, p);
    
   
    spectres_3filtres(length(S), 'Wc2 réel',Wc2_reel_num, Wc2_reel_denom...
                              ,'Wc1 réel',Wc1_reel_num, Wc1_reel_denom...
                              ,'Wnc réel',Wnc_reel_num, Wnc_reel_denom...
                              ,'hold off',fig);
    pause(0.1)
end
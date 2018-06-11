close all
clc
clear all

%% Lecture du son
S = audioread('aisole.wav');
Fs = 22050; % A modifier en fonction du signal S
N = length(S);
soundsc(S,Fs);


%% R�ponse fr�quentielle d'un seul filtre pour lpc id�ale et lpc r�elle, p et RSB fix�


%%%%%%%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%%%%%%%
%%%                                                             %%%
%%%     Modifier :                                              %%%
%%%     - RSB                                                   %%%
%%%     - p                                                     %%%
%%%     - la variation du RSB                                   %%%
%%%     - nomFiltre ('Wc1', 'Wc2' ou 'Wcn')                     %%%
%%%     - le filtre appel� pour g�nerer les num et denom        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

RSB = -15;
p = 20; 

[X,V] = generer_signal_bruite(S, Fs, RSB);
Sigmab = var(V);

nomFiltre = 'Wnc ideal';

[~, num_ideal, denom_ideal] = wnc_ideal(X, S, Fs, Sigmab, p);
[~, num_reel, denom_reel] = wnc_reel(X, Fs, Sigmab, p);

nomFigure1 = strcat('R�ponse fr�q avec lpc id�ale pour RSB = ',num2str(RSB),' dB et p =',num2str(p), ' coeff de lpc');
fig1 = figure('Name',nomFigure1);

nomFigure2 = strcat('R�ponse fr�q avec lpc r�elle pour RSB = ',num2str(RSB),' dB et p =',num2str(p), ' coeff de lpc');
fig2 = figure('Name',nomFigure2);

nomFiltreIdeal = strcat(nomFiltre,' ideal');
nomFiltreReel = strcat(nomFiltre,' reel');

spectres_1filtre(length(S), nomFiltreIdeal,num_ideal, denom_ideal,'hold off',fig1);
spectres_1filtre(length(S), nomFiltreReel,num_reel, denom_reel,'hold off',fig2);


nomFiltre = 'Wc2 ideal';

%%% nouveau
[h,w]=freqz(num_reel, denom_reel);
modh=20*log10(abs(h));
phaseh=unwrap(angle(h));
f=w/(2*pi);

%%%%%%%%%%%%%%%%%%%%%%%%%
figure(100)
plot(f,phaseh)
str = {nomFiltre,'R�ponse en phase'};
title(str,'FontSize',14);

xlabel('fr�quences num�riques');
ylabel('phase');
ylim([-1 0.2]);
xlim([0 0.5]);
legend('RSB = -15 dB','RSB = 0 dB','RSB = 45 dB');
grid on
hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     


RSB = 30;
p = 20; 

[X,V] = generer_signal_bruite(S, Fs, RSB);
Sigmab = var(V);

nomFiltre = 'Wc2 ideal';

[~, num_ideal, denom_ideal] = wc2_ideal(X, S, Fs, Sigmab, p);
[~, num_reel, denom_reel] = wc2_reel(X, Fs, Sigmab, p);

nomFigure1 = strcat('R�ponse fr�q avec lpc id�ale pour RSB = ',num2str(RSB),' dB et p =',num2str(p), ' coeff de lpc');
fig1 = figure('Name',nomFigure1);

nomFigure2 = strcat('R�ponse fr�q avec lpc r�elle pour RSB = ',num2str(RSB),' dB et p =',num2str(p), ' coeff de lpc');
fig2 = figure('Name',nomFigure2);

nomFiltreIdeal = strcat(nomFiltre,' ideal');
nomFiltreReel = strcat(nomFiltre,' reel');

spectres_1filtre(length(S), nomFiltreIdeal,num_ideal, denom_ideal,'hold off',fig1);
spectres_1filtre(length(S), nomFiltreReel,num_reel, denom_reel,'hold off',fig2);


nomFiltre = 'Wc2 ideal';


%%% nouveau
[h,w]=freqz(num_reel, denom_reel);
modh=20*log10(abs(h));
phaseh=unwrap(angle(h));
f=w/(2*pi);

%%%%%%%%%%%%%%%%%%%%%%%%%
figure(100)
plot(f,phaseh)
str = {nomFiltre,'R�ponse en phase'};
title(str,'FontSize',14);

xlabel('fr�quences num�riques');
ylabel('phase');
ylim([-1 0.2]);
xlim([0 0.5]);
legend('RSB = -15 dB','RSB = 0 dB','RSB = 45 dB');
grid on
hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RSB = 45;

p = 20; 

[X,V] = generer_signal_bruite(S, Fs, RSB);
Sigmab = var(V);

nomFiltre = 'Wc2 ideal';

[~, num_ideal, denom_ideal] = wc2_ideal(X, S, Fs, Sigmab, p);
[~, num_reel, denom_reel] = wc2_reel(X, Fs, Sigmab, p);

nomFigure1 = strcat('R�ponse fr�q avec lpc id�ale pour RSB = ',num2str(RSB),' dB et p =',num2str(p), ' coeff de lpc');
fig1 = figure('Name',nomFigure1);

nomFigure2 = strcat('R�ponse fr�q avec lpc r�elle pour RSB = ',num2str(RSB),' dB et p =',num2str(p), ' coeff de lpc');
fig2 = figure('Name',nomFigure2);

nomFiltreIdeal = strcat(nomFiltre,' ideal');
nomFiltreReel = strcat(nomFiltre,' reel');

spectres_1filtre(length(S), nomFiltreIdeal,num_ideal, denom_ideal,'hold off',fig1);
spectres_1filtre(length(S), nomFiltreReel,num_reel, denom_reel,'hold off',fig2);


nomFiltre = 'Wc2 reel';


%%% nouveau
[h,w]=freqz(num_reel, denom_reel);
modh=20*log10(abs(h));
phaseh=unwrap(angle(h));
f=w/(2*pi);

%%%%%%%%%%%%%%%%%%%%%%%%%
figure(100)
plot(f,phaseh)
str = {nomFiltre,'R�ponse en phase'};
title(str,'FontSize',14);

xlabel('fr�quences num�riques');
ylabel('phase');
ylim([-3.5 1]);
xlim([0 0.5]);
legend('RSB = -15 dB','RSB = 30 dB','RSB = 45 dB');
grid on
hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% R�ponse fr�quentielle d'un seul filtre en fonction du RSB (lpc ideal)

%%%%%%%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%%%%%%%
%%%                                                             %%%
%%%     Choisir un filtre et modifier :                         %%%
%%%     - p                                                     %%%
%%%     - nomFiltre                                             %%%
%%%     - la variation du RSB                                   %%%
%%%     - le filtre appel� dans la boucle (enlever S si reel)   %%%
%%%     - 'hold on' pour voir toutes les courbes,               %%%
%%%       'hold off' pour voir une seule courbe �voluer         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


p = 10;

nomFiltre = 'Wnc ideal';
nomFigure = strcat('R�ponse de ',nomFiltre,' avec et p =',num2str(p), ' coeff de lpc');
fig = figure('Name',nomFigure);


for RSB=-15:1:40
    [X,V] = generer_signal_bruite(S, Fs, RSB);
    Sigmab = var(V);

    [Y,num, denom] = wnc_ideal(X, S, Fs, Sigmab, p);
   
    spectres_1filtre(length(S), nomFiltre, num, denom,'hold on',fig);
    
    pause(0.1)
end


%% R�ponses fr�quentielles des 3 filtres en fonction du RSB (lpc ideal)


%%%%%%%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%%%%%%%
%%%                                                             %%%
%%%     Modifier :                                              %%%
%%%     - p                                                     %%%      
%%%     - choisir comment varie le RSB                          %%%
%%%     - 'hold on' pour voir toutes les courbes,               %%%
%%%       'hold off' pour voir une seule courbe �voluer         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


p = 20;

nomFigure = strcat('R�ponses fr�q pour LPC id�ale avec p =',num2str(p), ' coeff de lpc');
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


%% R�ponses fr�quentielles des 3 filtres en fonction du RSB (lpc r�elle)

%%%%%%%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%%%%%%%
%%%                                                             %%%
%%%     Modifier :                                              %%%
%%%     - p                                                     %%%      
%%%     - choisir comment varie le RSB                          %%%
%%%     - 'hold on' pour voir toutes les courbes,               %%%
%%%       'hold off' pour voir une seule courbe �voluer         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


p = 20;

nomFigure = strcat('R�ponses fr�q pour LPC r�elle avec p =',num2str(p), ' coeff de lpc');
fig = figure('Name',nomFigure);


for RSB=-15:1:40
    [X,V] = generer_signal_bruite(S, Fs, RSB);
    Sigmab = var(V);

    [Y_wc2_ideal,Wc2_reel_num, Wc2_reel_denom] = wc2_reel(X, Fs, Sigmab, p);
    [Y_wc1_ideal, Wc1_reel_num, Wc1_reel_denom] = wc1_reel(X, Fs, Sigmab, p);
    [Y_wnc_ideal,Wnc_reel_num, Wnc_reel_denom] = wnc_reel(X, Fs, Sigmab, p);
    
   
    spectres_3filtres(length(S), 'Wc2 r�el',Wc2_reel_num, Wc2_reel_denom...
                              ,'Wc1 r�el',Wc1_reel_num, Wc1_reel_denom...
                              ,'Wnc r�el',Wnc_reel_num, Wnc_reel_denom...
                              ,'hold off',fig);
    pause(0.1)
end
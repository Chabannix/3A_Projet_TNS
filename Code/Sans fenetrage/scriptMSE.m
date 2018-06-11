close all
clc
clear all

%% Lecture du son
S = audioread('101.wav');
Fs = 22050; % A modifier en fonction du signal S
S = S(40000:40400);
N = length(S);
soundsc(S,Fs);


%% Influence de l'ordre de la LPC sur la MSE, RSB fixé


%%%%%%%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                   %%%
%%%     Modifier :                                                    %%%
%%%     - nomFiltre                                                   %%%
%%%     - RSB                                                         %%%
%%%     - la variation de p                                           %%%
%%%     - le filtre appelé dans la boucle (enlever S pour lpc reel)   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nomFiltre = ' Wnc idéal';
RSB=20;
[X,V] = generer_signal_bruite(S, Fs, RSB);
Sigmab = var(V);
p = [2:1:50];

clear('MSE');

for i=1:length(p)
    [Y, ~, ~] = wnc_reel(X, Fs, Sigmab, p(i));
    MSE(i) = immse(Y,S);
end


figure;
plot(p,MSE,'+');
str = strcat('MSE(p) pour ',nomFiltre,' avec RSB = ',int2str(RSB),' dB');
title(str,'FontSize',14);
xlabel('ordre de la lpc');
ylabel('MSE');
grid on

%% Influence du RSB sur la MSE, p fixé

%%%%%%%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%%%%%%%
%%%                                                             %%%
%%%     Modifier :                                              %%%
%%%     - p                                                     %%%
%%%     - nomFiltre                                             %%%
%%%     - la variation du RSB                                   %%%
%%%     - le filtre appelé dans la boucle (enlever S pour reel  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


p = 20;
nomFiltre = ' Wc1 idéal';
Sigmab = var(V);

RSB = [0:1:100];

clear('MSE');


for i=1:length(RSB);
    [X,V] = generer_signal_bruite(S, Fs, RSB(i));
    [Y, numW, A1] = wc1_ideal(X, S, Fs, var(V), p);
    MSE(i) = immse(Y,S);
end

figure;
plot(RSB,MSE,'+');
str = strcat('MSE(RSB) pour ',nomFiltre,' avec p = ',int2str(p));
title(str,'FontSize',14);
xlabel('RSB en dB')
ylabel('MSE')
grid on


%% Influence de l'ordre de la LPC sur la MSE pour Wc2, RSB fixé
% tentative de compenser le retard introduit par Wc2


%%%%%%%%%%%%%%%%%           Notice :            %%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                   %%%
%%%     Modifier :                                                    %%%
%%%     - nomFiltre (Wc2 ideal ou reel)                               %%%
%%%     - RSB                                                         %%%
%%%     - la variation de p                                           %%%
%%%     - le filtre appelé dans la boucle (enlever S pour lpc reel)   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nomFiltre = ' W2c idéal';
RSB=20;
[X,V] = generer_signal_bruite(S, Fs, RSB);
Sigmab = var(V);
p = [2:1:50];

clear('MSE');

for i=1:length(p)
    [Y, ~, ~] = wnc_reel(X, Fs, Sigmab, p(i));
    MSE(i) = immse(Y,S);
    
    %décalage de Y :
    Y1 = Y(1+floor(p(i)/2):end);
    S1 = S(1:end-floor(p(i)/2));
   
    MSE(i) = immse(Y1,S1);
    %MSE(i) = immse(Y1,S1(1:length(Y)));
    %MSE(i) = sum((Y1-S1).^2);
    %MSE(i) = sum ( ( Y1(:) - S1(:) ) .^2 )/ length(S); 
end


figure;
plot(p,MSE,'+');
str = strcat('MSE(p) pour ',nomFiltre,' avec RSB = ',int2str(RSB),' dB');
title(str,'FontSize',14);
xlabel('ordre de la lpc');
ylabel('MSE');
grid on


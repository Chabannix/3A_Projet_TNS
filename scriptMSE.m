close all
clc
clear all

%% Lecture du son
S = audioread('aisole.wav');
Fs = 22050; % A modifier en fonction du signal S
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
close all
nomFiltre = ' Wc2 idéal';
p = [1:1:20];


for RSB=0:5:10
[X,V] = generer_signal_bruite(S, Fs, RSB);
Sigmab = var(V);
clear('MSE');
for i=1:length(p)
    Y = wc2_ideal(X, S, Fs, Sigmab, p(i));
    
%     tau = 1/(2*pi) * ((720/22050) /18) *p(i);
%     toto=1
%     avance = floor(Fs * tau);
%     tot=2
%     Y = Y(avance:end);
%     toto=3
%     Ss = S(229:end);
    MSE(i) = immse(Y(1:min(length(S),length(Y))) , S(1:min(length(S),length(Y))) );
    toto=4
end

figure (100);
plot(p,MSE);
str = strcat('MSE(p) pour   ',nomFiltre);%,' avec RSB = ',int2str(RSB),' dB');
title(str,'FontSize',16);
xlabel('ordre de la lpc');
ylabel('MSE');
%ylim([-1e-3 14e-3])
grid on
hold on

legend('RSB = 0 dB','RSB = 5 dB','RSB = 10 dB');

end
figure;
plot(S)
hold on
plot(Y)

legend('S','Y')

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


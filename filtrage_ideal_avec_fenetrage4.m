function Y = filtrage_ideal_avec_fenetrage4(X, S, Sigmab, Fs, p, T_win)

% X : signal bruit� � filtrer par tranches
% Fs : Fr�quence d'�chantillonnage
% filtre utilis� : 'Wc1', 'Wc2', 'Wnc'
% T_win : longueur de la fenetre en secondes



% Donn�es sur X
Nx = length(X);
Px = var(X); % Calcul de la puissance du signal

% Calcul de V
V = S-X;
%Sigmab = var(V);

% Nombre de points par fen�tre
N_win_demiTriangle = floor(Fs*T_win/20);   % Longueur (en �ch) d'un demi triangle

N_win = 20*N_win_demiTriangle;             % Longueur de la fenetre (4 triangles)

win = zeros(N_win,1);

win(1:2*N_win_demiTriangle) = triang(2*N_win_demiTriangle);
win(N_win - 2*N_win_demiTriangle +1 : N_win) = triang(2*N_win_demiTriangle);
win(N_win_demiTriangle : N_win - N_win_demiTriangle) = 1;

figure;
plot(win);
title('fen�tre trap�zo�dale');
ylim([0 2])
xlabel('�chantillons')
ylabel('amplitude')
grid on

win_shift = N_win - N_win_demiTriangle;  % D�placement de la fen�tre en fonction de l'overlap demand�

window = zeros(length(X),1);


% G�n�ration de Y
Y = zeros(length(X),1);


% Boucle sur les tranches de X avec filtrage � chaque it�ration
win_start = 1;

    while win_start <= Nx
        win_end = min(N_win,Nx - win_start);
        
        X_cut = X(win_start : win_start + win_end-1);
        S_cut = S(win_start : win_start + win_end-1);
        
        Ycut = rif(X_cut, S_cut, Fs, Sigmab, p);
        %Ycut = rif(X_cut, S_cut, Fs, Sigmab, p);

        Yfenetre = Ycut(1 : win_end).*win(1 : win_end);
        
        Y(win_start : win_start + win_end-1) = Y(win_start : win_start + win_end-1) + Yfenetre;

        win_start = win_start + win_shift;


    end
end
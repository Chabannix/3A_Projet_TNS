function Y = filtrage_reel_avec_fenetrage4(X, Fs, p, T_win)

% X : signal bruité à filtrer par tranches
% Fs : Fréquence d'échantillonnage
% filtre utilisé : 'Wc1', 'Wc2', 'Wnc'
% T_win : longueur de la fenetre en secondes



% Données sur X
Nx = length(X);

% Données sur V
V_start = X(1:1000);
V_end = X(Nx - 1000:Nx);
V = [V_start;V_end];
Sigmab = var(V);

% Nombre de points par fenêtre
N_win_demiTriangle = floor(Fs*T_win/20);   % Longueur (en éch) d'un demi triangle

N_win = 20*N_win_demiTriangle;             % Longueur de la fenetre (4 triangles)

win = zeros(N_win,1);

win(1:2*N_win_demiTriangle) = triang(2*N_win_demiTriangle);
win(N_win - 2*N_win_demiTriangle +1 : N_win) = triang(2*N_win_demiTriangle);
win(N_win_demiTriangle : N_win - N_win_demiTriangle) = 1;

% figure;
% plot(win);
% title('fenêtre trapézoïdale');
% ylim([0 2])
% xlabel('échantillons')
% ylabel('amplitude')
% grid on

win_shift = N_win - N_win_demiTriangle;  % Déplacement de la fenêtre en fonction de l'overlap demandé

window = zeros(length(X),1);


% Génération de Y
Y = zeros(length(X),1);


% Boucle sur les tranches de X avec filtrage à chaque itération
win_start = 1;

    while win_start <= Nx
        win_end = min(N_win,Nx - win_start);
        
        X_cut = X(win_start : win_start + win_end-1);
        
        Ycut = rif(X_cut, S, Fs, Sigmab, p);
        
        Yfenetre = Ycut(1 : win_end).*win(1 : win_end);
        
        Y(win_start : win_start + win_end-1) = Y(win_start : win_start + win_end-1) + Yfenetre;

        win_start = win_start + win_shift;


    end
end
function [Y, numW, A1] = fonction_fenetrage(Signal, Fs, RSB, estimation_bruit, p, win_type, T_win, Overlap)

% R�cup�ration de donn�es sur le signal d'origine (que l'on ne peut avoir
% en pratique)
N = length(Signal);
Ps = var(Signal); % Calcul de la puissance du signal

% Cr�ation du bruit blanc additif (gaussien ici)
Sigmab = Ps*10^(-RSB/10); % Puissance du bruit
Bruitb = sqrt(Sigmab)*randn(size(Signal)); % Bruit centr�

% Addition du bruit au signal sonore
X = Signal + Bruitb;
%sound(X,Fs);

% Nombre de points par fen�tre
N_win = floor(Fs*T_win);   % Longueur (en �ch) d'une fen�tre
win_shift = floor(N_win*(100-Overlap)/100);  % D�placement de la fen�tre en fonction de l'overlap demand�

if strcmp(win_type,'Rect')
    win = ones(N_win,1);
else if strcmp(win_type,'Hamm')
    win = hamming(N_win);
else if strcmp(win_type,'Triangle')
    win = triang(N_win);
end
end
end

win_start = 1;
win_end = N_win;
%plot(win);

Y = zeros(size(X));

if strcmp(estimation_bruit,'sans') % On estime � partir du signal non-bruit�
    S = Signal;
else if strcmp(estimation_bruit,'avec') % On estime � partir du signal bruit�
    S = X;
end
end

    while win_start<=N

        sig_win = S(win_start:min(N,win_end));
        sig_cut = sig_win.*win(1:length(sig_win));
%       plot(sig_cut);
        
        [A,g] = lpc(sig_cut,p); % O� g = G^2/N (= Variance = Puissance) !
        AInv = flip(A);
        AAinv = conv(A,AInv);

        numWiener = sqrt(g)/sqrt(Sigmab); % Num�rateur du filtre de Wiener
        AAinv(p+1) = AAinv(p+1) + numWiener^2; % Denominateur du filtre de Wiener (on a rajout� la constante donc c'est A1(z)*A1(z^-1) maintenant)

        % On cherche uniquement la partie causale de Wc2 (|p�les| < 1)

        r = roots(AAinv);

        j = 0;
        for i=1:size(r)
            if abs(r(i))<1
                j = j+1;
                PolesC(j) = r(i);   % On ne conserve que les racines de AAinv qui rendent Wc2 causal !
            end
        end

        A1 = poly(PolesC);  % On obtient finalement A1 � partir de ses racines

        gain_wiener = numWiener^2/sum(AAinv);
        gain_wiener_caus = numWiener/sum(A1);
        K = sqrt(gain_wiener)/gain_wiener_caus;

        numW = numWiener*K;

        f = filter(numW,A1,X(win_start:min(N,win_end)));
        Y(win_start:min(N,win_end)) = Y(win_start:min(N,win_end)) + f;

        win_start = win_start + win_shift;
        win_end = win_end + win_shift;
    end

figure;
plot(Signal, 'r');
hold on
plot(Y/2,'b');
title('Signal audio non-bruit� (rouge) vs Wiener causal � estimation id�ale (bleu)');
xlabel('�chantillons');

end
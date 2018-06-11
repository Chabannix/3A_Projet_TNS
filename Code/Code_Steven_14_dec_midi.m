close all
clc

%% Lecture du son
S = audioread('aisole.wav');
dim = size(S);
Ps = var(S); % Calcul de la puissance du signal
RSB = 1;

%% Création du bruit blanc additif (gaussien ici)
Sigmab = Ps*10^(-RSB/10); % Puissance du bruit
Bruitb = sqrt(Sigmab)*randn(dim); % Bruit centré

%figure;
%histogram(Bruitb, 50);

%% Addition du bruit au signal sonore
X = S + Bruitb;

% figure;
% subplot(2,1,1);
% plot(S);
% title('Signal audio propre');
% xlabel('échantillons');
% subplot(2,1,2);
% plot(X);
% title('Signal audio bruité');
% xlabel('échantillons');

%% LPC et Wiener CAUSAL
p = 27; % Ordre du prédicteur
N = dim(1);
    
%% Cas non-bruité
[A,g] = lpc(S,p); % Où g = G^2/N (= Variance = Puissance) !
AInv = flip(A);
AAinv = conv(A,AInv);

numWiener = sqrt(g)/sqrt(Sigmab); % Numérateur du filtre de Wiener
AAinv(p+1) = AAinv(p+1) + numWiener^2; % Denominateur du filtre de Wiener (on a rajouté la constante donc c'est A1(z)*A1(z^-1) maintenant)

% On cherche uniquement la partie causale de Wc2 (|pôles| < 1)

r = roots(AAinv);

j = 0;
for i=1:size(r)
    if abs(r(i))<1
        j = j+1;
        PolesC(j) = r(i);   % On ne conserve que les racines de AAinv qui rendent Wc2 causal !
    end
end

% On affiche les racines et les racines de la forme causale
% figure;
% plot(r, 'x');
% hold on
% plot(PolesC, 'o');

A1 = poly(PolesC);  % On obtient finalement A1 à partir de ses racines

gain_wiener = numWiener^2/sum(AAinv);
gain_wiener_caus = numWiener/sum(A1);
K = sqrt(gain_wiener)/gain_wiener_caus;

numWiener = numWiener*K;

%% Calcul du facteur K (gain perdu lorsqu'on reconstitue le polynôme à partir des racines causales et de la fonction poly)
% !!!!!! Cette partie est fausse !!!!!!
% 
% Poly_reconstitue = poly(r);
% K = abs(sum(AAinv)/sum(Poly_reconstitue)); % Gain en continu (i-e qd z=1 <-> w=0)
% K = sqrt(K); % Car chaque partie causale et non causale contribue avec racine(K)

%% Cas bruité: même chose qu'avant, mais en basant la LPC sur le signal bruité cette fois !

[Ab,gb] = lpc(X,p);
AInvb = flip(Ab);
AAinvb = conv(Ab,AInvb);

numWienerb = sqrt(gb)/sqrt(Sigmab); 
AAinvb(p+1) = AAinvb(p+1) + numWienerb^2; 

rb = roots(AAinvb);

j = 0;
for i=1:size(rb)
    if abs(rb(i))<1
        j = j+1;
        PolesCb(j) = rb(i);
    end
end

% figure;
% plot(rb, 'x');
% hold on
% plot(PolesCb, 'o');

A1b = poly(PolesCb);

gain_wienerb = numWienerb^2/sum(AAinvb);
gain_wiener_causb = numWienerb/sum(A1b);
Kb = sqrt(gain_wienerb)/gain_wiener_causb;

numWienerb = numWienerb*Kb;

%% Filtrage Wiener causal Wc1 (bruité et non-bruité)
Ynb = filter(numWiener,A1,X);
Yb = filter(numWienerb,A1b,X);

figure;
subplot(2,1,1);
plot(S, 'r');
hold on
plot(Ynb,'b');
title('Signal audio non-bruité (rouge) vs Wiener causal à estimation idéale (bleu)');
xlabel('échantillons');

subplot(2,1,2);
plot(S, 'r');
hold on
plot(Yb, 'b');
title('Signal audio non-bruité (rouge) vs Wiener causal à estimation réelle (bleu)');
xlabel('échantillons');

% load chirp.mat;    On écoute les différents signaux:
% sound(S, 20000);   
% sound(X, 20000);
% sound(Ynb, 20000);
sound(Yb, 20000);

%% Calcul de DSP pour le cas causal (densité spectrale de puissance)

sdft = fft(S);  % TFD de S
sdft = sdft(1:N/2+1);   % Son spectre est périodique de période N: S étant réel, son spectre est symétrique (donc on n'a besoin que de la partie f > 0)
psds = (1/(2*pi*N)) * abs(sdft).^2;
psds(2:end-1) = 2*psds(2:end-1); % On multiplie par 2 pour avoir l'ensemble de la puissance (sauf la composante à fréquence nulle qui n'apparaît qu'une fois !)

Ynbdft = fft(Ynb);  % TFD de S chapeau (cas non-bruité)
Ynbdft = Ynbdft(1:N/2+1);   % Son spectre est périodique de période N: S chapeau étant réel, son spectre est symétrique (donc on n'a besoin que de la partie f > 0)
psdYnb = (1/(2*pi*N)) * abs(Ynbdft).^2;
psdYnb(2:end-1) = 2*psdYnb(2:end-1); % On multiplie par 2 pour avoir l'ensemble de la puissance (sauf la composante à fréquence nulle qui n'apparaît qu'une fois !)

Ybdft = fft(Yb);  % TFD de S chapeau (cas bruité)
Ybdft = Ybdft(1:N/2+1);   % Son spectre est périodique de période N: S chapeau étant réel, son spectre est symétrique (donc on n'a besoin que de la partie f > 0)
psdYb = (1/(2*pi*N)) * abs(Ybdft).^2;
psdYb(2:end-1) = 2*psdYb(2:end-1); % On multiplie par 2 pour avoir l'ensemble de la puissance (sauf la composante à fréquence nulle qui n'apparaît qu'une fois !)

freq = 0:(2*pi)/N:pi;

figure;
subplot(3,1,1);
plot(freq/pi,10*log10(psds))
grid on
title('Power Spectral density of S (noiseless signal)')
xlabel('Normalized Frequency')
ylabel('Power (dB)')

subplot(3,1,2);
plot(freq/pi,10*log10(psdYnb), 'r')
grid on
title('Power Spectral density of S chapeau (ideal estimation)')
xlabel('Normalized Frequency')
ylabel('Power (dB)')

subplot(3,1,3);
plot(freq/pi,10*log10(psdYb), 'r')
grid on
title('Power Spectral density of S chapeau (real estimation)')
xlabel('Normalized Frequency')
ylabel('Power (dB)')


%% Observations des réponses en fréquence du filtre Wc2:

% [h,w] = freqz(1,AAinv,N);
% figure;
% plot(w/pi,10*log10(abs(h).^2))
% grid on
% title('Square gain of the filter A(z)')
% xlabel('Normalized Frequency (\times\pi rad/sample)')
% ylabel('Power (dB)')

figure;
subplot(2,1,1)
freqz(numWiener,A1,N);
subplot(2,1,2)
phasez(numWiener,A1,N);

%% Filtrage de Wiener non-causal: (On ne s'occupe pas de Wc1 qui possède une erreur quadratique plus faible mais qui reste moins bon que Wc2 en termes de qualité audio)



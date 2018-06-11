function [Y, numW, A1] = wc2_reel(X, Fs, Sigmab, p)

Y = zeros(size(X));

[A,g] = lpc(X,p); % Où g = G^2/N (= Variance = Puissance) !
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

A1 = poly(PolesC);  % On obtient finalement A1 à partir de ses racines

gain_wiener = numWiener^2/sum(AAinv);
gain_wiener_caus = numWiener/sum(A1);
K = sqrt(gain_wiener)/gain_wiener_caus;

numW = numWiener*K;

Y = filter(numW,A1,X);

% figure;
% plot(Signal, 'r');
% hold on
% plot(Y,'b');
% title('Signal audio non-bruité (rouge) vs Wiener causal à estimation idéale (bleu)');
% xlabel('échantillons');

end
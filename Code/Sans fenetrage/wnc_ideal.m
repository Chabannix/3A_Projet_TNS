function [Y,numWiener, A1_causal] = wnc_ideal(X, S, Fs, Sigmab, p)

Y = zeros(size(X));

% Calcul de A1(z):

[A_causal,g] = lpc(S,p);
AInv = flip(A_causal);
AAinv = conv(A_causal,AInv);

numWiener = sqrt(g/Sigmab);
A1A1inv = AAinv;
A1A1inv(p+1) = A1A1inv(p+1) + numWiener^2;

r = roots(A1A1inv);
racineCausale = r((abs(r)<1));
A1_causal = poly(racineCausale);

gain_wiener = 1/sum(A1A1inv);
gain_wiener_caus = 1/sum(A1_causal);
K = sqrt(gain_wiener)/gain_wiener_caus;

numWiener = numWiener*K;

Y = filtfilt(numWiener, A1_causal, X);

% figure;
% plot(S);
% hold on
% plot(Y);
% title('Signal audio non-bruité (rouge) vs Wiener causal à estimation idéale (bleu)');
% xlabel('échantillons');

end
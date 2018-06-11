function [Y,Wc1_reel_num,Wc1_reel_denom] = wc1_reel(X, Fs, Sigmab, p)

Y = zeros(size(X));

% Calcul de A1(z): similaire au cas causal Wc2 pour cette partie

[A_causal,g] = lpc(X,p);
AInv = flip(A_causal);
AAinv = conv(A_causal,AInv);

numerateurWnc = g/Sigmab;
A1A1inv = AAinv;
A1A1inv(p+1) = A1A1inv(p+1) + numerateurWnc;

r = roots(A1A1inv);
racineCausale = r((abs(r)<1));
A1_causal = poly(racineCausale);

gain_wiener = 1/sum(A1A1inv);
gain_wiener_caus = 1/sum(A1_causal);
K = sqrt(gain_wiener)/gain_wiener_caus;

A1_nonCausal = flip(A1_causal);

A1_A = conv(A1_nonCausal,A_causal);
[r,poles,k] = residuez(1,A1_A);

poleCausal = poles((abs(poles)<1));
residuPoleCausal = r((abs(poles)<1));

[Gplus_num,Gplus_denom] = residuez(residuPoleCausal,poleCausal,k);

Wc1_reel_num = numerateurWnc*K^2*conv(Gplus_num,A_causal);
Wc1_reel_denom = conv(A1_causal,Gplus_denom);
Y = real(filter(Wc1_reel_num, Wc1_reel_denom, X));

% figure;
% plot(X);
% hold on
% plot(Y);
% title('Signal audio non-bruité (rouge) vs Wiener causal à estimation idéale (bleu)');
% xlabel('échantillons');

end
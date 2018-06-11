function Y = rif(X, S, Fs, Sigmab, p)


[~, num, denom] = wnc_ideal(X, S, Fs, Sigmab, p);

% calcul de la rep impulsionnelle via ifft

M = 20;
[H,omega]=freqz(num^2,conv(denom,flip(denom)),'whole'); % Sur [0,Fs]
f = omega/(2*pi);
% figure(1);
% plot(f,20*log10(abs(H)));

h2 = ifftshift(ifft(H));


% On échantillonne la RII
  
h_rif = zeros(size(h2));
[~,i] = max(h2);
h_rif(i-M:i+M) = h2(i-M:i+M);

Y = conv(h_rif,X);

end
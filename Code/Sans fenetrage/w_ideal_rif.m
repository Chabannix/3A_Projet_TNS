function [Y,W_ideal_num_rif,W_ideal_denom_rif] = w_ideal_rif(X, S, Fs, Sigmab, p)

N = length(X);
[~, num_ideal, denom_ideal] = wnc_ideal(X, S, Fs, Sigmab, p);

[h,w]=freqz(num_ideal,denom_ideal,N);
f = w/pi; f(end) = round(f(end));
gain = abs(h);

W_ideal_num_rif = fir2(70,f,gain);
W_ideal_denom_rif = 1;

Y = filter(W_ideal_num_rif, W_ideal_denom_rif, X);

end
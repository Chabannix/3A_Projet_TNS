function DSP(S, Y_ideal, Y_reel)

N = length(S);
dft = fft(S);  % TFD de S
dft = dft(1:N/2+1);   % Son spectre est périodique de période N: S étant réel, son spectre est symétrique (donc on n'a besoin que de la partie f > 0)
psd = (1/(2*pi*N)) * abs(dft).^2;
psd(2:end-1) = 2*psd(2:end-1); % On multiplie par 2 pour avoir l'ensemble de la puissance (sauf la composante à fréquence nulle qui n'apparaît qu'une fois !)

dft1 = fft(Y_ideal);  
dft1 = dft1(1:N/2+1);
psd1 = (1/(2*pi*N)) * abs(dft1).^2;
psd1(2:end-1) = 2*psd1(2:end-1);

dft2 = fft(Y_reel);  
dft2 = dft2(1:N/2+1);
psd2 = (1/(2*pi*N)) * abs(dft2).^2;
psd2(2:end-1) = 2*psd2(2:end-1);

freq = 0:(2*pi)/N:pi;

figure;
subplot(3,1,1);
plot(freq/pi,10*log10(psd))
grid on
title('Power Spectral density of S (noiseless signal)')
xlabel('Normalized Frequency')
ylabel('Power (dB)')
    
subplot(3,1,2);
plot(freq/pi,10*log10(psd1), 'r')
grid on
title('Power Spectral density of S chapeau (ideal estimation)')
xlabel('Normalized Frequency')
ylabel('Power (dB)')

subplot(3,1,3);
plot(freq/pi,10*log10(psd2), 'r')
grid on
title('Power Spectral density of S chapeau (real estimation)')
xlabel('Normalized Frequency')
ylabel('Power (dB)')

end
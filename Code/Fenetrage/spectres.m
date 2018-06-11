function spectres(N, numW, A1, numWb, A1b)

figure;
subplot(2,1,1)
freqz(numW,A1,N);
subplot(2,1,2)
phasez(numW,A1,N);

figure;
subplot(2,1,1)
freqz(numWb,A1b,N);
subplot(2,1,2)
phasez(numWb,A1b,N);

end
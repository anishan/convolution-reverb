whitenoise = wgn(10000,1,0);
whitenoise_xcorr = xcorr(whitenoise(:,end), whitenoise(:,end));
W = fft(whitenoise);
W_xcorr = fft(whitenoise_xcorr);

figure(1)
subplot(2, 1, 1); plot(W)
subplot(2, 1, 2); plot(W_xcorr, 'r');

figure(2)
subplot(2, 1, 1); plot(abs(W));
subplot(2, 1, 2); plot(phase(W));

figure(3)
subplot(2, 1, 1); loglog(abs(W_xcorr), 'r');
subplot(2, 1, 2); semilogx(phase(W_xcorr), 'r');
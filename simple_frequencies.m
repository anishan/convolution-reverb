fs = 48000;
fmax = 10500;
n = 600000 / 2;
skyline = zeros(1, n*2);
freq = 30; % 30 Hz sounds like a stuttering trumpet, 300Hz is a purring cat dove, and 3000Hz is an elephant

skyline(freq) = 100000;
skyline(n*2 - freq) = 100000;

figure(2)
plot(skyline);

skyline_ht = ifft(skyline);
figure(3)
plot(abs(skyline_ht))
sound(abs(skyline_ht))

[dove,Fs_dove] = audioread('elDelitoMayorGoogle.wav');
dove = dove(:,1);
z = zeros(10000000,1);
ir = [skyline_ht.'; z];
Irjw = fft(ir(1:length(dove)));
Dovejw = fft(dove);
aYjw = Irjw .* Dovejw;

yt_libdove = abs(ifft(aYjw));

sound(yt_libdove, Fs_dove)

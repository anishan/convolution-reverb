f1 = 300; % space ship
f2 = 10000;
% f1 = 5000; % guitar pros failing...
% f2 = 10000;
fs = 48000;
fmax = 10500;
n = fs / 2 + 100;
skyline = zeros(1, n*2);
freq = 3000; % 30 Hz sounds like a stuttering trumpet, 300Hz is a purring cat dove, and 3000Hz is an elephant

skyline(f1 : f2) = 100000;
skyline(n*2 - f2 : n*2 - f1) = 100000;

figure(2)
plot(skyline); 

skyline_ht = ifft(skyline);
figure(3)
plot(abs(skyline_ht))
sound(abs(skyline_ht))

[dove,Fs_dove] = audioread('dove.wav');
dove = dove(:,1);
z = zeros(10000000,1);
ir = [skyline_ht.'; z];
Irjw = fft(ir(1:length(dove)));
Dovejw = fft(dove);
aYjw = Irjw .* Dovejw;

yt_libdove = ifft(aYjw);

% sound(real(yt_libdove), Fs_dove)

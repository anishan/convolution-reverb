% f1 = 300; % space ship
% f2 = 10000;
f1 = 300; % guitar pros failing...
f2 = 500;
fs = 48000;
fmax = 10500;
n = fs / 2 + 100;
box = zeros(1, n*2);
freq = 3000; % 30 Hz sounds like a stuttering trumpet, 300Hz is a purring cat dove, and 3000Hz is an elephant

box(f1 : f2) = 100000;
box(n*2 - f2 : n*2 - f1) = 100000;

figure(2)
plot(box); 

box_ht = ifft(box);
figure(3)
plot(abs(box_ht))
sound(abs(box_ht))

[dove,Fs_dove] = audioread('dove.wav');
dove = dove(:,1); % mono channel
ir = box_ht.';
% z = zeros(10000000,1);
% ir = [box_ht.'; z];
if(length(dove) > length(box_ht))
    ir = [ir; zeros(length(dove) - length(box_ht), 1)];
else
    dove = [dove; zeros(length(box_ht) - length(dove), 1)];
end

Irjw = fft(ir(1 : length(dove)));
Dovejw = fft(dove);
aYjw = Irjw .* Dovejw;

figure(4);
plot(abs(aYjw));

yt_dove = ifft(aYjw);

sound(real(yt_dove), Fs_dove)
% Save result
% filename = 'dove_box_test.wav';
% audiowrite(filename,yt_dove,Fs_dove);

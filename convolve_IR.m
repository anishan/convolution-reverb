[ir,Fs_ir] = audioread('library-athens.wav');
[dove,Fs_dove] = audioread('dove.wav');
dove = dove(:,1);
clf
plot(ir)
hold on
plot(dove(70000:100000))

Irjw = fft(ir(1:30001));
Dovejw = fft(dove(70000:100000));
Yjw = Irjw .* Dovejw;
% figure
% plot(Yjw)

yt = ifft(Yjw);


sound(dove(70000:100000), Fs_dove)
sound(yt, Fs_dove)
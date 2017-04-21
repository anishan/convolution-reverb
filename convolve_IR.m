[ir,Fs_ir] = audioread('lib-stair.wav');
[dove,Fs_dove] = audioread('dove.wav');
dove = dove(:,1);
z = zeros(100000000,1);
ir = ir(:,1);
ir = [libraryht; z];
clf
plot(dove)
hold on
plot(ir(1:length(dove)))


Irjw = fft(ir(1:length(dove)));
% Irjw = fft(libraryht);
Dovejw = fft(dove);
aYjw = Irjw .* Dovejw;
% figure
% plot(Yjw)

yt_libdove = abs(ifft(aYjw));


% sound(dove(70000:100000), Fs_dove)
sound(yt_libdove, Fs_dove)

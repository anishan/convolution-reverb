fs = 44100;
duration = 12;
f_min = 20;
f_max = 20000;
t = 0 : (1/fs) : duration - (1/fs);
s = chirp(t, f_min, 1, (f_max - f_min) / duration + f_min);

recObj = audiorecorder(fs,16,1);
z = zeros(300);
before_sound = datestr(now, 'dd-mm-yyyy HH:MM:SS FFF');
sound([z(1,:), s], fs);
before_record = datestr(now, 'dd-mm-yyyy HH:MM:SS FFF');
disp('before')
recordblocking(recObj, duration);
disp('done')

y_record = getaudiodata(recObj);

disp(before_sound)
disp(before_record)

[y_record,Fs_record] = audioread('ACstairs1.wav');

figure(1)
clf
hold on
plot(t,s)
duration_record = length(y_record)/Fs_record;
t_record = 0 : (1/fs) : duration_record - (1/fs);
plot(t_record, y_record)

% Fourier Transforms
Xjw = fft(s.');
Yjw = fft(y_record);
% Hjw = Yjw ./ Xjw;

figure(2)
clf
magXjw = abs(Xjw);
magYjw = abs(Yjw);
% magHjw = abs(Hjw);
f_cutoff = 0.36;
interval = length(magXjw)*f_cutoff/(2*pi);

hold on
plot(linspace(0,f_cutoff,interval),magXjw(1:interval))
plot(linspace(0,f_cutoff,interval),magYjw(1:interval))
% plot(linspace(0,f_cutoff,interval),magHjw(1:interval)*1000)
ylim([0 1000])

figure(3)
clf
% Find impulse response in time
space_ht = ifft(Hjw);
plot(t(1:interval), abs(space_ht(1:interval)))

% Convolution
[dove,Fs_dove] = audioread('dove.wav');
dove = dove(:,1);
z = zeros(100000000,1);
ir = [space_ht; z];
Irjw = fft(ir(1:length(dove)));
Dovejw = fft(dove);
aYjw = Irjw .* Dovejw;

yt_libdove = abs(ifft(aYjw));

% sound(yt_libdove, Fs_dove)

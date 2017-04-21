% Make the input x(t) vector as a chirp
fs = 48000;%44100;
duration = 12;
f_min = 20;
f_max = 20000;
t = 0 : (1/fs) : duration - (1/fs);
s = chirp(t, f_min, 1, (f_max - f_min) / duration + f_min);
z = zeros(0.5*fs);
s = [s, z(1,:)]; %pad with half a second of zeroes at the end
t = [t, t(end):(1/fs):t(end)+0.5-(1/fs)];

% Load recordings 
[y_record,Fs_record] = audioread('recordings420/ZOOM0018.wav');
y_record = y_record(1:12.5*Fs_record); % cut off the recording after 12.5 sec

figure(1)
clf
hold on
plot(t, s)
duration_record = length(y_record)/Fs_record;
t_record = 0 : (1/Fs_record) : duration_record - (1/Fs_record);
plot(t_record, y_record)

% Fourier Transforms
Xjw = fft(s.');
Yjw = fft(y_record);
Hjw = Yjw ./ Xjw;
idx_fmax = f_max * (length(Hjw) / 2) * 2 / fs;

% Set freq higher than fmax to 0, must do so for both spectra
for i = idx_fmax : length(Hjw) - idx_fmax
    if(mod(i, 100) == 0)
        disp(i);
    end
    Hjw(i) = 0;
end
figure;
plot(abs(Hjw))
% Hjw(:) = 0;
% Hjw(length(Hjw)/2+1 : length(Hjw)/2+1 + idx_fmax) = 0;

figure(2)
clf
magXjw = abs(Xjw);
magXjw = magXjw(1:length(magXjw)/2+1);
magYjw = abs(Yjw);
magYjw = magYjw(1:length(magYjw)/2+1);
magHjw = abs(Hjw);
magHjw = magHjw(1:length(magHjw)/2+1);
% f_cutoff = f_max;
% interval = length(magXjw)*f_cutoff/(2*pi);
% freq_hz = 1 ./ t;

f = linspace(0, f_max, length(magXjw));

hold on
% plot(linspace(0,f_cutoff,interval),magXjw(1:interval))
% plot(linspace(0,f_cutoff,interval),magYjw(1:interval))
% plot(linspace(0,f_cutoff,interval),magHjw(1:interval)*1000)
% ratio to get the index position
plot(f,magXjw)
plot(f,magYjw)
plot(f,magHjw*1000)
ylim([0 1000])

figure(3)
clf
% Find impulse response in time
% space_ht = ifft([Hjw(1:f_max*length(f)*2/fs); Hjw(length(Hjw)-f_max*length(f)*2/fs:end)]);
space_ht = ifft(Hjw);
% t_new = linspace(0, 12.5, length(space_ht));
plot(t, abs(space_ht))

% Convolution
% [dove,Fs_dove] = audioread('dove.wav');
% dove = dove(:,1);
% z = zeros(10000000,1);
% ir = [space_ht; z];
% Irjw = fft(ir(1:length(dove)));
% Dovejw = fft(dove);
% aYjw = Irjw .* Dovejw;
% 
% yt_libdove = abs(ifft(aYjw));
% 
% sound(yt_libdove, Fs_dove)

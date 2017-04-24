% Make the input x(t) vector as a chirp
fs = 48000; %44100;
duration = 12; % seconds
f_min = 20; %Hz
f_max = 20000; %Hz
t = 0 : (1/fs) : duration - (1/fs);
s = chirp(t, f_min, 1, (f_max - f_min) / duration + f_min);
z = zeros(1, 0.5*fs);
s = [s, z]; %pad with half a second of zeroes at the end
t = [t, t(end) : (1/fs) : t(end) + 0.5 - (1/fs)];

% Load recordings 
[y_record, Fs_record] = audioread('recordings420/ZOOM0005.wav');
y_record = y_record(1 : 12.5 * Fs_record); % cut off the recording after 12.5 sec

figure(1)
clf
hold on
plot(t, s)
duration_record = length(y_record) / Fs_record;
t_record = 0 : (1/Fs_record) : duration_record - (1/Fs_record);
plot(t_record, y_record)

% Fourier Transforms
Xjw = fft(s.');
Yjw = fft(y_record);
Hjw = Yjw ./ Xjw * 10; % Multiply to increase volume of output

% Find where the index of the maximum frequency of the signal we can capture (fs / 2)
idx_fmax = f_max * (length(Hjw) / 2) * 2 / fs;

% Set freq higher than fmax to 0, must do so for both spectra
for i = idx_fmax : length(Hjw) - idx_fmax
    Hjw(i) = 0;
end

magXjw = abs(Xjw);
magXjw = magXjw(1 : length(magXjw) / 2 + 1);
magYjw = abs(Yjw);
magYjw = magYjw(1 : length(magYjw) / 2 + 1);
magHjw = abs(Hjw);
magHjw = magHjw(1 : length(magHjw) / 2 + 1);

f = linspace(0, f_max, length(magXjw));

% Plot frequency content of X, Y, and H
figure(2)
clf
hold on
plot(f, magXjw)
plot(f, magYjw)
plot(f, magHjw*10)
ylim([0 1000])

% Find impulse response in time
space_ht = ifft(Hjw);
% Save impulse response recording
% sound(real(space_ht) .* 50, fs);
% filename = 'ir_thin_pvc_sameside.wav';
% audiowrite(filename, space_ht.*50, fs);

% Plot impulser response in time
figure(3)
clf;
plot(t, real(space_ht)*10)

% % % Convolution
% [dove,Fs_dove] = audioread('delito_isabella.mp3');
% dove = dove(:,1); % mono channel
% ir = space_ht;
% if(length(dove) > length(space_ht))
%     ir = [space_ht; zeros(length(dove) - length(space_ht), 1)];
% else
%     dove = [dove; zeros(length(space_ht) - length(dove), 1)];
% end
% 
% % Fourier Transform
% Irjw = fft(ir);
% Dovejw = fft(dove);
% aYjw = Irjw .* Dovejw;
% yt_dove = ifft(aYjw);
% 
% % Plot response in space in time
% figure(4)
% t_dove = 0 : (1/Fs_dove) : (length(dove) - 1) / Fs_dove;
% plot(t_dove, real(yt_dove))
% 
% % Save result
% filename = 'delito_staircase.wav';
% audiowrite(filename,yt_dove,Fs_dove);
% sound(real(yt_dove), Fs_dove)

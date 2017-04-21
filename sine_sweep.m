% f1:      starting frequency [Hz]
% f2:      ending frequency [Hz]
% fs:      sampling rate (Hz)
% N:       If N is an integer, the total length of the excitation sound file is
%          2*(2^N) samples, or 2*(2^N)/fs seconds.  This helps speed up
%          computation.
f1 = 1000;
f2 = 20000;
fs = 48000;
N = 12;

T = (2^N)/fs;

% Create the swept sine tone
w1 = 2*pi*f1;
w2 = 2*pi*f2;
K = T*w1/log(w2/w1);
L = T/log(w2/w1);
t = linspace(0,T-1/fs,fs*T);
% s = sin(K*(exp(t/L) - 1));
t = 0:(1/fs):3-(1/fs);%0:1/fs:3;
s = chirp(t,100,1,1000);
% t = linspace(0,T,2*N)
% s = sin(2*pi*f2*t)

recObj = audiorecorder(48000,16,1);
z = zeros(300);
before_sound = datestr(now, 'dd-mm-yyyy HH:MM:SS FFF');
sound([z(1,:), s], 48000);
before_record = datestr(now, 'dd-mm-yyyy HH:MM:SS FFF');
disp('before')
recordblocking(recObj, 3);
disp('done')

y_record = getaudiodata(recObj);

disp(before_sound)
disp(before_record)

figure(3)
clf
hold on
plot(t,s)
t_real = 0:(1/fs):3-(1/fs);
plot(t_real,y_record)

Xjw = fft(s.');
Yjw = fft(y_record);
Hjw = abs(Yjw) ./ abs(Xjw);
ht = ifft(Hjw);

figure(4)
clf
plot(abs(Hjw))
figure(5)
clf
plot(ht)
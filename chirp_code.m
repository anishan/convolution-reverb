fs = 48000;
t = 0:(1/fs):3-(1/fs);%0:1/fs:3;
s = chirp(t,100,1,1000);

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

figure(1)
clf
hold on
plot(t,s)
t_real = 0:(1/fs):3-(1/fs);
plot(t_real,y_record)

Xjw = fft(s.');
Yjw = fft(y_record);
Hjw = Yjw ./ Xjw;
ht = ifft(Hjw);

figure(2)
clf
hold on
magXjw = abs(Xjw);
magYjw = abs(Yjw);
magHjw = abs(Hjw);
plot(linspace(0,0.36,144000*0.36/(2*pi)),magXjw(1:144000*0.36/(2*pi)))
hold on
plot(linspace(0,0.36,144000*0.36/(2*pi)),magYjw(1:144000*0.36/(2*pi)))
plot(linspace(0,0.36,144000*0.36/(2*pi)),magHjw(1:144000*0.36/(2*pi))*1000)
ylim([0 1000])

figure(3)
clf
space_ht = ifft(Hjw);
plot(t(1:144000*0.36/(2*pi)), abs(space_ht(1:144000*0.36/(2*pi))))


[dove,Fs_dove] = audioread('dove.wav');
dove = dove(:,1);
z = zeros(100000000,1);
ir = [space_ht; z];
Irjw = fft(ir(1:length(dove)));
Dovejw = fft(dove);
aYjw = Irjw .* Dovejw;

yt_libdove = abs(ifft(aYjw));

sound(yt_libdove, Fs_dove)

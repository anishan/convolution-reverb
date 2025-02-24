im = imread('paris_skyline.png');
im_grayscale = rgb2gray(im);
im_bw = imbinarize(im_grayscale);
figure(1);
% imshow(im_bw);
[m, n] = size(im_bw);
fs = 48000;
fmax = 10500;
f1 = 100;
f2 = f1 + n;
scaling_factor = round((f2 - f1) / n);
skyline = zeros(1, f2 * scaling_factor);

for j = 1 : n
   for i = 1 : m
      if(im_bw(i, j) == 0)
          % hit a black bit, set scaling_factor indeces to the height
          skyline((f1 + j) * scaling_factor : (f1 + j+1) * scaling_factor) = m - i + 1;
          break;
      end
   end
end
% Add 0s to frequencies between fmax and fs to not have extrenely high
% ampltiude high frequencies
skyline = [skyline, zeros(1, 2 * (fs / 2 - f2) * scaling_factor), fliplr(skyline)]; 

figure(2)
plot(skyline);

skyline_ht = ifft(skyline);
figure(3)
plot(abs(skyline_ht))
% sound(abs(skyline_ht))

[dove,Fs_dove] = audioread('universe_jenna.mp3');
dove = dove(:,1); % mono channel
ir = skyline_ht.';

if(length(dove) > length(skyline_ht))
    ir = [ir; zeros(length(dove) - length(skyline_ht), 1)];
else
    dove = [dove; zeros(length(skyline_ht) - length(dove), 1)];
end

% Fourier Transform
Irjw = fft(ir);
Dovejw = fft(dove);
aYjw = Irjw .* Dovejw;
yt_dove = ifft(aYjw);

% Plot response in space in time
figure(4)
t_dove = 0 : (1/Fs_dove) : (length(dove) - 1) / Fs_dove;
plot(t_dove, real(yt_dove))

sound(real(yt_dove), Fs_dove)
% filename = 'delito_boston.wav';
% audiowrite(filename,yt_dove,Fs_dove);
% sound(real(yt_dove), Fs_dove)

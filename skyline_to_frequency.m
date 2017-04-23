im = imread('new_york_skyline.png');
im_grayscale = rgb2gray(im);
im_bw = imbinarize(im_grayscale);
figure(1);
imshow(im_bw);
[m, n] = size(im_bw);
fs = 48000;
fmax = 10500;
f1 = 4000;
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

[dove,Fs_dove] = audioread('dove.wav');
dove = dove(:,1);
z = zeros(10000000,1);
ir = [skyline_ht.'; z];
Irjw = fft(ir(1:length(dove)));
Dovejw = fft(dove);
aYjw = Irjw .* Dovejw;

yt_libdove = abs(ifft(aYjw));

sound(yt_libdove, Fs_dove)

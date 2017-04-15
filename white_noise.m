figure(1)
clf
figure(2)
clf
figure(3)
clf


hold on
recObj = audiorecorder;

whitenoise = [];
y_record = [];
Ryx = [];
Rxx = [];
FRyx = [];
FRxx = [];
H = [];
h = [];

for i=1:1
    whitenoise = [whitenoise, [wgn(10000,1,0)]];
    sound(whitenoise(:,end));
    recordblocking(recObj, 3);
    y_record = [y_record, getaudiodata(recObj)];

%     figure
%     plot(whitenoise)
%     hold on
%     plot(y_record(1699:11698))

    % in time, Ryx = Rxx * h(t)
    tempyrec = y_record(:,end);
    Ryx = [Ryx, xcorr(tempyrec(1699:11698), whitenoise(:,end))];
    Rxx = [Rxx, xcorr(whitenoise(:,end), whitenoise(:,end))];
    figure(1)
    hold on
    plot(Rxx(:,end))
    
    figure(3)
    hold on
    plot(Ryx(:,end))
    
    % take fourier transform to put into frequency
    % then we can just divide
    FRyx = [FRyx, fft(Ryx(:,end))];
    FRxx = [FRxx, fft(Rxx(:,end))];
    H = [H, FRyx(:,end) ./ FRxx(:,end)];
    
    figure(2)
    hold on
    plot(abs(H(:,end)))
    h = [h, ifft(H(:,end))];

end

avg_H = [];
for j = 1:length(H)
    avg_H = [avg_H; sum(abs(H(j,:)))/10];
end
figure
plot(avg_H)
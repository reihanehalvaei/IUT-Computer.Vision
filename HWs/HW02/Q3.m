
I = imread('.\Mars_Moon.tif');
Hist = My_Histogram(I);

A = im2double(I);
subplot(1,3,1);
imshow(I)
title('original', 'FontSize', 10);

Res = (double(255/log(256)))*log(double(I+1));
B = uint8(Res); 
C = imadjust(B,[0 1],[1 0]);

subplot(1,3,2);
imshow(B)
title('Edited 1', 'FontSize', 10);
subplot(1,3,3);
imshow(C)
title('Edited 2', 'FontSize', 10);







W = 3;

I = imread('.\Peppers.tif');
I_1 = imnoise(I,'salt & pepper',0.7);


abs = floor(W/2);
Len = size(I,1);
newsize = Len+2*abs;
R = zeros(newsize,newsize,'double');


h =  fspecial('gaussian',[W W],W/6);
padMatrix = zeros(newsize);
X = zeros(Len);
Y = zeros(Len);
Z = zeros(Len);



for i = 1:Len
    for j = 1:Len
        padMatrix(i+1,j+1) = I_1(i,j);
    end
end

for i =  1:newsize-(abs+1)
    for j = 1:newsize-(abs+1)
        arr = zeros(9,1);
        counter = 1;
        for x = 1:W
            for y = 1:W
                arr(counter) =  padMatrix(i+x-1,j+y-1);
                counter = counter+1;
            end
        end
       
        arr2 = sort(arr);
        
        if median(arr)~ = 0 && median(arr)~ = 255
            X(i,j) =  median(arr);
        else
            X(i,j) = median(arr2);
        end
        
        X(i,j) = median(arr2);
        h = reshape(h,9,1);
        Y(i,j) = sum(sum(arr.*h));
        flag = 0;
        if (X(i,j) =  = 0 && Y(i,j) =  = 0 )|| (X(i,j) =  = 255 && Y(i,j) =  = 255)
            Z(i,j) =  1/2*255;
            flag = 1;
        end
        if(X(i,j) =  = 0 || X(i,j) =  = 255 || Y(i,j) =  = 0|| Y(i,j) =  = 255) && flag =  = 0
           Z(i,j) =  (Y(i,j)+X(i,j))/2;
        else
            Z(i,j) =  X(i,j);
        end
        
    end
end


X = uint8(X);
Y = uint8(Y);
Z = uint8(Z);
medpsnr = psnr(medfilt2(I_1),I);
mypsnr = psnr(Z,I);

subplot(1,4,1);
imshow(I)
title('original', 'FontSize', 10);
subplot(1,4,2);
imshow(I_1)
title('noise PIC', 'FontSize', 10);
subplot(1,4,3);
imshow(medfilt2(I_1))
title('Median Filter', 'FontSize', 10);
subplot(1,4,4);
imshow(Z)
title('Myfilter', 'FontSize', 10);
%imshow([I_1 medfilt2(I_1) Z]),title('                      MEDIAN FILTERING        My FILTERING');



function T = VesselExtract(I,k,mask,manual_ans)
    I = rgb2gray(I);
    [x,y] = size(I);
    Filter_Avg = fspecial('Average',[20 20]);
    S = imfilter(I,Filter_Avg);
    info=zeros(1,4);
    info(1)=0;
    info(2)=0;
    info(3)=0;
    info(4)=0;

    K = 0.97;
    T = S*K;
    I = ~(I>T);
    
    disk_plot = strel('disk',1);
    I = imclose(I,disk_plot);
    for i=1:6
        mask = imerode(mask,disk_plot);
    end
    
    %I = imopen(I,disk_plot);
    
    CC = bwconncomp(I);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    sizenum = size(numPixels);

    for i=1:sizenum(2)
        if numPixels(i)<100

            I(CC.PixelIdxList{i}) = 0;
        end
    end
    
   
    
    I = I.*logical(mask);
    for i=1:x
        for j=1:y
            if I(i,j)==1 && manual_ans(i,j) == 255
                info(1) = info(1)+1;
            elseif I(i,j)==0 && manual_ans(i,j) == 255
                info(4) = info(4)+1;
            elseif I(i,j)==1 && manual_ans(i,j) == 0
                info(3) = info(3)+1;
            elseif I(i,j)==0 && manual_ans(i,j) == 0
                info(2) = info(2)+1;
            end            
        end
    end
    T=zeros(1,4);
    T(1) = k;
    T(2) = info(1)/(info(1)+info(4));
    T(3) = info(2)/(info(2)+info(3));
    T(4) = (info(1)+info(2))/(info(1)+info(2)+info(3)+info(4));
    
    index = "0"+num2str(k);
    path = "./ANS/"+ index +".tif";
    imwrite(I ,path);
end
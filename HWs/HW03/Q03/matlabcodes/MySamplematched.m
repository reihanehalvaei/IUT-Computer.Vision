
function counterResult = MySamplematched (I) 

    counterResult=0;

    % Large Sample 54*72
    L_templates = zeros(8,72,54,'double');
    M_templates = zeros(8,48,36,'double');
    S_templates = zeros(8,24,18,'double');

    %hihi = zeros(1040*970,1,'double');

    for i = 1:8
        path = strcat('../pattern/3/',num2str(i),'.tif');
        L_templates(i,:,:) = im2double(imread(path));
        path = strcat('../pattern/2/',num2str(i),'.tif');
        M_templates(i,:,:) = im2double(imread(path));
        path = strcat('../pattern/1/',num2str(i),'.tif');
        S_templates(i,:,:) = im2double(imread(path));
    end

    for k = 8:-1:1
        for i = 37:970-35
            for j = 28:970-26
                if I(i,j)~=1
                    temp = psnr(reshape(L_templates(k,:,:),72,54),...
                        I(i-36:i+35,j-27:j+26));
                    if temp > 11
                        counterResult = counterResult + k;
                        for x = i-36:i+35
                            for y = j-27:j+26
                                I(x,y) = 1;
                            end
                        end
                    end
                end
            end
        end
    end

    for k = 8:-1:1
        for i = 25:970-24
            for j = 19:970-18
                if I(i,j)~=1
                    temp = psnr(reshape(M_templates(k,:,:),48,36),...
                        I(i-24:i+23,j-18:j+17));
                    if temp > 11
                        counterResult = counterResult + k;
                        for x = i-24:i+23
                            for y = j-18:j+17
                                I(x,y) = 1;
                            end
                        end
                    end
                end
            end
        end
    end
    
    for k = 8:-1:1
        %ccc=1;
        for i = 13:970-11
            for j = 10:970-9
                if I(i,j)~=1
                    tempsnr = psnr(reshape(S_templates(k,:,:),24,18),...
                        I(i-12:i+11,j-9:j+8));
                    %if k==4 && tempsnr < 9.4249
                        %hihi(ccc)=tempsnr;
                        %ccc=ccc+1;
                    %end
                    if tempsnr > 11 || (tempsnr > 9.3242 && k==4)
                        counterResult = counterResult + k;
                        for x = i-12:i+11
                            for y = j-9:j+8
                                I(x,y) = 1;
                            end
                        end
                    end
                end
            end
        end
    end
end
    

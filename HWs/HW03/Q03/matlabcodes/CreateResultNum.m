clc;close all; clear;
%function CreateResultNum()
    r = 1040;
    c = 970;
    
    
    I = im2double(imread('../Dataset/Test_9_20.tif'));
    TemplateGround = zeros(67,970);
    for i = 1:67
        TemplateGround(i,:) = I(i+973,:);
    end
    imwrite(TemplateGround,'../TemplateGround.tif');
    RGBPIC = zeros(1040,970,3,'double');
    RGBPIC(:,:,1) = 1;
    RGBPIC(:,:,2) = 1;
    RGBPIC(:,:,3) = 1;
    
    
    for x = 1:10
        for y = 1:10
            for i = 1:67
                RGBPIC(i+973,:,1) = TemplateGround(i,:);
                RGBPIC(i+973,:,2) = TemplateGround(i,:);
                RGBPIC(i+973,:,3) = TemplateGround(i,:);
            end
            s1 = strcat('../pattern/1/',num2str(x-1),'.tif');
            s2 = strcat('../Q3/pattern/1/',num2str(y-1),'.tif');
            smallNum0 = im2double(imread(s1));
            smallNum1 = im2double(imread(s2));
            for i = 994:1017
                for j = 300:343
                    if j>300 && j<319
                        if smallNum1(i-993,j-300) =  = 0
                        RGBPIC(i,j,2) = 0;
                        RGBPIC(i,j,3) = 0;
                        end
                    end
                    if j>325 && j<344
                        if smallNum0(i-993,j-325) =  = 0
                        RGBPIC(i,j,2) = 0;
                        RGBPIC(i,j,3) = 0;
                        end
                    end

                end
            end
            ss = strcat('../newsample/',num2str(y-1),num2str(x-1),'.tif');
            imwrite(RGBPIC,ss);
        end
    end
    
    
    
    


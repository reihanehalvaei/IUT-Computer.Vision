clc;clear;close all;
load patients.mat

numOfpicture = zeros(20,1,'uint8');
sensivity = zeros(20,1,'double');
specificity = zeros(20,1,'double');
accuracy = zeros(20,1,'double');

path01 = './DRIVE/Test/';

for k = 1:20
    if k<10
        index = "0"+num2str(k);
    else
        index = num2str(k);
    end
    I = imread(path01 + "images/" + index + "_test.tif");
    mask = imread(path01 + "mask/" + index + "_test_mask.gif");
    manual_ans = imread(path01 + "1st_manual/" + index + "_manual1.gif");
    T = VesselExtract(I,k,mask,manual_ans);
    
    
    numOfpicture(k) = T(1);
    sensivity(k) = T(2);
    specificity(k) = T(3);
    accuracy(k) = T(4);
    %imshow(I,[]);
    
        
end

Tinfo = table(numOfpicture,sensivity,specificity,accuracy);
Tinfo(1:20,:);

filename = './ANS/tableInfo.xlsx';
writetable(Tinfo,filename,'Sheet',1,'Range','A1')
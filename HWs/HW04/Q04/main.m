clc;clear;close all;

load patients.mat

I = imread('Cells.tif');
thresh = multithresh(I,2);
II=I;
I = I>thresh(1);
disk_plot = strel('disk',1);
I = imopen(I,disk_plot);

I = uint8(I)*255;
I(1,:)=0;

IwithLable = MY_BWLABEL(I);
MY_SAVE(I,IwithLable);

clc; clear; close all;

original = imread("./Puzzle_1_360/Original.tif");
path = './Puzzle_1_360/';
defpix= 80;
pix = defpix-1;
output = zeros(1200,1920,3,'uint8');
row=0;col=0;

rownum=1200/80;colnum=1920/defpix;
p=1;c=1;

for i=1:defpix:1200
    row=row+1;
    for j=1:defpix:1920
        col=col+1;
        
        A = original(i:i+pix,j:j+pix,:);
        if((row==1 && col==1)||(row==1 && col==colnum)||(row==rownum && col==1)|| ...
            (row==rownum && col==colnum))
            name = strcat(path,"Corner_",num2str(row),"_",num2str(col),".tif");
            imwrite(A,name);
            output(i:i+pix,j:j+pix,:)=A;
            c=c+1;
        else
            name = strcat(path,"Patch_",num2str(p),".tif");
            imwrite(A,name);
            p=p+1;
            
        end
        
    end
    col=0;
end
name = strcat(path,"Output.tif");
imwrite(output,name);


clc;close all; clear;

datasetPath = '../Dataset/';
testbench=0;
pathdatabase = dir(datasetPath);
for x = 1:numel(pathdatabase)
   if pathdatabase(x).isdir == 0
       Z1 = imread([datasetPath pathdatabase(x).name]);
       I=medfilt2(Z1,[5 5]);
       I=im2double(I);
       
       A=zeros(970,970);
       for i=1:970
           A(i,:)=I(i,:);
       end
       
       counter = MySamplematched(A);
       hinum = sscanf(pathdatabase(x).name,"Test_%d_%d.tif");
       if(hinum(2) == counter)
           testbench = testbench+1;
       end
        %ss=strcat('../newsample/',num2str(counter),'.tif');
        if (floor(counter/10))==0
            ss=strcat('../newsample/0',num2str(counter),'.tif');
        else
            ss=strcat('../newsample/',num2str(counter),'.tif');
        end
        sq=strcat('../Finalresult/PICRESULT.No_',num2str(hinum(1)),'.tif');
        writeOp=imread(ss);
        
        for i=1:970
           for j=1:970
               if Z1(i,j)==0
                    writeOp(i,j,:)=0;
               end
            end
        end
        imwrite(writeOp,sq);
   end
end

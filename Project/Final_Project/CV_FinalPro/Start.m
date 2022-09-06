clc; clear; close all;

%please enter path by this format : /*****/Puzzle_numfulder_numofimagesection/ 
path = './Puzzle_2_160/';

expath=path+"*#";
num = extractBetween(expath,"_","/*#");
expath=num+"*";
num = str2num(extractBetween(expath,"_","*"));

ds = dir(path);
fragmentSize = 240/sqrt(num/40);

defCol=1920;    %default in this project original pic 1200*1920
defRow=1200;
defCorners=4;
numOfrow=defRow/fragmentSize;    % number of rows in a section
numOfcol=defCol/fragmentSize;    % number of colums in a section

cellSize = 3;                   % default cell size for LBP featue

maxOffragFeatureSize = max([256 ceil(fragmentSize/cellSize)*9 fragmentSize]); %Max Sise for Features of fragmentions

Corners = zeros(fragmentSize,fragmentSize,3,4,'double');
attributeOfCorners = zeros(12,maxOffragFeatureSize,4,4,'double');

Patches = zeros(fragmentSize,fragmentSize,3,num-4,'double');
attributeOfPatches= zeros(12,maxOffragFeatureSize,4,num-4,'double');

original = zeros(1920,1200,3);
imshow(original)
output = zeros(1920,1200,3);
flag = zeros(1,num,'logical');

i=0;
for p=1:numel(ds)       
    if(ds(p).isdir==0)
        if(ds(p).name=="Original.tif")
            original = imread([path ds(p).name]);
            continue;
        end
        if(ds(p).name=="Output.tif")
            output = imread([path ds(p).name]);
            continue;
        end            
        e_extr = extractBetween(ds(p).name,1,"_");
        if(e_extr=="Patch")
            i = i+ 1;
            Patches(:,:,:,i) = imread([path ds(p).name]);
        end
    end
end
%set Corners in file
Corners(:,:,:,1) = imread (strcat(path,"Corner_",num2str(1),"_",num2str(1),".tif"));
Corners(:,:,:,2) = imread (strcat(path,"Corner_",num2str(1),"_",num2str(1920/fragmentSize),".tif"));
Corners(:,:,:,3) = imread (strcat(path,"Corner_",num2str(1200/fragmentSize),"_",num2str(1),".tif"));
Corners(:,:,:,4) = imread (strcat(path,"Corner_",num2str(1200/fragmentSize),"_",num2str(1920/fragmentSize),".tif"));


%set attributes for patches
for i=1:num-defCorners
    for j=1:3       
        % set attribute of histogram for all 4 edge of fragment
        attributeOfPatches(j,1:256,1,i)=histogram(Patches(1,:,j,i));
        attributeOfPatches(j,1:256,2,i)=histogram(Patches(fragmentSize,:,j,i));
        attributeOfPatches(j,1:256,3,i)=histogram(Patches(:,1,j,i));
        attributeOfPatches(j,1:256,4,i)=histogram(Patches(:,fragmentSize,j,i));
    end
    for j=1:3
        % set attribute of LBP for all 4 edge of fragment
        attributeOfPatches(j+3,1:59,1,i)=extractLBPFeatures(Patches(1:3,:,j,i));
        attributeOfPatches(j+3,1:59,2,i)=extractLBPFeatures(Patches(fragmentSize-2:fragmentSize,:,j,i));
        attributeOfPatches(j+3,1:59,3,i)=extractLBPFeatures(Patches(:,1:3,j,i));
        attributeOfPatches(j+3,1:59,4,i)=extractLBPFeatures(Patches(:,fragmentSize-2:fragmentSize,j,i));
    end
    for j=1:3
        % set attribute of color for all 4 edge of fragment
        attributeOfPatches(j+6,1:fragmentSize,1,i)=Patches(1,:,j,i);
        attributeOfPatches(j+6,1:fragmentSize,2,i)=Patches(fragmentSize,:,j,i);
        attributeOfPatches(j+6,1:fragmentSize,3,i)=(Patches(:,1,j,i))';
        attributeOfPatches(j+6,1:fragmentSize,4,i)=(Patches(:,fragmentSize,j,i))';
    end
    for j=1:3
        % set attribute of HOG for all 4 edge of fragment but don't used
        f = extractHOGFeatures(Patches(1:cellSize,:,j,i),'BlockSize',[1 1],'CellSize',[cellSize cellSize]);
        [sx,sy] = size(f);
        attributeOfPatches(j+9,1:sy,1,i)= f;
        attributeOfPatches(j+9,1:sy,2,i)=extractHOGFeatures(Patches(fragmentSize-cellSize-1:fragmentSize,:,j,i),'BlockSize',[1 1],'CellSize',[cellSize cellSize]);
        attributeOfPatches(j+9,1:sy,3,i)=extractHOGFeatures(Patches(:,1:cellSize,j,i),'BlockSize',[1 1],'CellSize',[cellSize cellSize]);
        attributeOfPatches(j+9,1:sy,4,i)=extractHOGFeatures(Patches(:,fragmentSize-cellSize-1:fragmentSize,j,i),'BlockSize',[1 1],'CellSize',[cellSize cellSize]);
    end
    
end
 %all pre say at this time for corners se

for i=1:4
    for j=1:3
        attributeOfCorners(j,1:256,1,i)=histogram(Corners(1,:,j,i));
        attributeOfCorners(j,1:256,2,i)=histogram(Corners(fragmentSize,:,j,i));
        attributeOfCorners(j,1:256,3,i)=histogram(Corners(:,1,j,i));
        attributeOfCorners(j,1:256,4,i)=histogram(Corners(:,fragmentSize,j,i));
    end
    for j=1:3
        attributeOfCorners(j+3,1:59,1,i)=extractLBPFeatures(Corners(1:3,:,j,i));
        attributeOfCorners(j+3,1:59,1,i)=attributeOfCorners(j+3,1:59,1,i)./sum(attributeOfCorners(j+3,1:59,1,i));
        attributeOfCorners(j+3,1:59,2,i)=extractLBPFeatures(Corners(fragmentSize-2:fragmentSize,:,j,i));
        attributeOfCorners(j+3,1:59,2,i)=attributeOfCorners(j+3,1:59,2,i)./sum(attributeOfCorners(j+3,1:59,2,i));
        attributeOfCorners(j+3,1:59,3,i)=extractLBPFeatures(Corners(:,1:3,j,i));
        attributeOfCorners(j+3,1:59,3,i)=attributeOfCorners(j+3,1:59,3,i)./sum(attributeOfCorners(j+3,1:59,3,i));
        attributeOfCorners(j+3,1:59,4,i)=extractLBPFeatures(Corners(:,fragmentSize-2:fragmentSize,j,i));
        attributeOfCorners(j+3,1:59,4,i)=attributeOfCorners(j+3,1:59,4,i)./sum(attributeOfCorners(j+3,1:59,4,i));
    end
    for j=1:3
        attributeOfCorners(j+6,1:fragmentSize,1,i)=Corners(1,:,j,i);
        attributeOfCorners(j+6,1:fragmentSize,2,i)=Corners(fragmentSize,:,j,i);
        attributeOfCorners(j+6,1:fragmentSize,3,i)=(Corners(:,1,j,i))';
        attributeOfCorners(j+6,1:fragmentSize,4,i)=(Corners(:,fragmentSize,j,i))';
    end
    for j=1:3
        attributeOfCorners(j+9,1:sy,1,i)=extractHOGFeatures(Corners(1:cellSize,:,j,i),'BlockSize',[1 1],'CellSize',[cellSize cellSize]);
        attributeOfCorners(j+9,1:sy,2,i)=extractHOGFeatures(Corners(fragmentSize-cellSize-1:fragmentSize,:,j,i),'BlockSize',[1 1],'CellSize',[cellSize cellSize]);
        attributeOfCorners(j+9,1:sy,3,i)=extractHOGFeatures(Corners(:,1:cellSize,j,i),'BlockSize',[1 1],'CellSize',[cellSize cellSize]);
        attributeOfCorners(j+9,1:sy,4,i)=extractHOGFeatures(Corners(:,fragmentSize-cellSize-1:fragmentSize,j,i),'BlockSize',[1 1],'CellSize',[cellSize cellSize]);
    end
    
end

allAttributes = zeros(12,maxOffragFeatureSize,4,numOfrow,numOfcol,'double');

allAttributes(:,:,:,1,1)=attributeOfCorners(:,:,:,1);
allAttributes(:,:,:,1,numOfcol)=attributeOfCorners(:,:,:,2);
allAttributes(:,:,:,numOfrow,1)=attributeOfCorners(:,:,:,3);
allAttributes(:,:,:,numOfrow,numOfcol)=attributeOfCorners(:,:,:,4);

%check row 1 left to right

row=1;col=0;

for j=1:fragmentSize:defCol
    col = col + 1;
    if(col==1 || col==numOfcol) 
        continue;
    else
        A = allAttributes(1:9,:,4,1,col-1);
    end
    index=0;
    norm=Inf;         
        for k=1:num-4           % don't check again
            if(flag(1,k)==1)
                continue;
            end
            
            B = attributeOfPatches(1:9,:,3,k);
           
            d= sqrt (sum(sum( cast(A-B,'double').^2))); % norm1
            %d=immse(A,B); % mse
            if(d<norm)
                index = k;
                norm = d;
            end
        end
        flag(1,index)=1;
        output(1:1+fragmentSize-1,j:j+fragmentSize-1,:)=Patches(:,:,:,index);
        allAttributes(:,:,:,row,col)=attributeOfPatches(:,:,:,index);
        imshow(output);
    
end

%check col 1 up to down

row=0;col=1;

for i=1:fragmentSize:defRow
    row = row + 1;
    if(row==1 || row==numOfrow) 
        continue;
    else
        A = allAttributes(1:9,:,2,row-1,1);
    end
    index=0;
    norm=Inf;        
        for k=1:num-defCorners
            if(flag(1,k)==1)
                continue;
            end
            
            B = attributeOfPatches(1:9,:,1,k);
            
            d= sqrt (sum(sum( cast(A-B,'double').^2))); % norm 1
            
            mymse=immse(A,B);
            if(d<norm)
                index = k;
                norm = d;
            end
        end
        
        flag(1,index)=1;
        output(i:i+fragmentSize-1,1:1+fragmentSize-1,:)=Patches(:,:,:,index);
        allAttributes(:,:,:,row,col)=attributeOfPatches(:,:,:,index);
        imshow(output);
    
end



row=1;col=1;
for i=fragmentSize+1:fragmentSize:defRow
    row = row+1;
    for j=fragmentSize+1:fragmentSize:defCol
        col=col+1;
        if((row==1 && col==1)||(row==1 && col==numOfcol)||(row==numOfrow && col==1)|| ...
            (row==numOfrow && col==numOfcol))
            continue; 
        
        else
            A1 = allAttributes(1:9,:,2,row-1,col);
            A2 = allAttributes(1:9,:,4,row,col-1);
        end
        index=0;
        indx1=0;
        indx2=0;
        norm1=Inf;
        norm2=Inf;
        for k=1:num-defCorners
            if(flag(1,k)==1)
                continue;
            end
            if(row==1)
                %B = attributeOfPatches(:,:,3,k);
            else
                B1 = attributeOfPatches(1:9,:,1,k);
                B2 = attributeOfPatches(1:9,:,3,k);
            end
            d1= sqrt (sum(sum( cast(A1-B1,'double').^2)));
            d2= sqrt (sum(sum( cast(A2-B2,'double').^2)));
            
            mymse1= immse(A1,B1);
            mymse2= immse(A2,B2);
            if(d1<norm1 )
                indx1 = k;                
                norm1 = d1;
                normal2= abs (d1-d2);
            end
            if(d2<norm2 )
                
                indx2 = k;                
                norm2 = d2;
                normal2_1=abs(d1-d2);
            end
        end
       
        if(indx2==indx1)
            index=indx1;
        elseif (normal2+norm1>normal2_1+norm2)
            index=indx2;
        else
            index=indx1;
        end
        
        flag(1,index)=1;
        output(i:i+fragmentSize-1,j:j+fragmentSize-1,:)=Patches(:,:,:,index);
        allAttributes(:,:,:,row,col)=attributeOfPatches(:,:,:,index);
    end
    col=1;
    imshow(output);
end



imshow(output)


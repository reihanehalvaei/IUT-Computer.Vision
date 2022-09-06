function Histogram = My_Histogram(Input_Image)
[r,c]=size(Input_Image);
Histogram=zeros(1,256);
for i=1:r
    for j=1:c
        b=Input_Image(i,j);
        Histogram(b+1)=Histogram(b+1)+1;
    end
end

end

 
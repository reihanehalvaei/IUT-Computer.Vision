function out = My_Negative(I)


tmp = I;
for r = 1:size(I,1)
    for c = 1:size(I,2)
        tmp(r,c,:) = 255 - I(r,c,:);
    end
end

end
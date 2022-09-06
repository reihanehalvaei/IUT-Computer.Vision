function out = MY_BWLABEL(I)

[r,c] = size(I);
rangepix = zeros(1,255);
out = zeros(r,c);
out = uint8(out);


for i=2:r
    for j=1:c
        if I(i,j)~=0
            
            if j == 1 && j<c            
                infoI = [out(i-1,j) out(i-1,j+1)];
            
            elseif j == 1 && j == c       
                infoI = out(i-1,j);  
            elseif j~=1 && j == c
                infoI = [out(i-1,j) out(i-1,j-1) out(i,j-1)];
            else         
                infoI = [out(i-1,j) out(i-1,j+1) out(i-1,j-1) out(i,j-1)];
            
            end
            
            Image_save = size(infoI);
            min = uint8(255);
            for k=1:Image_save(2)
                if infoI(k)<min && infoI(k)~=0
                    min = infoI(k);
                end
            end

            if max(infoI)~=0
                out(i,j)= min;
            else
                for k=255:-1:1
                    if rangepix(k) == 0
                        range = k;
                    end
                end
                out(i,j) = range;
                rangepix(range) = 1;
            end
            
            
            for k=1:Image_save(2)
                if infoI(k)~=0 && infoI(k)~=min
                    rangepix(infoI(k))=0;
                    for n=1:i-1
                        for m=1:c
                            if out(n,m) == infoI(k)
                                out(n,m) = min;
                            end
                        end
                    end
                    for m=j:-1:1
                        if out(i,m) == infoI(k)

                            out(i,m) = min;
                        end
                    end
                end
            end
             
        end
            
    end
end


end
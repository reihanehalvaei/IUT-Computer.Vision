function MY_SAVE(III,I)

    [r,c] = size(III);

    Histogram = My_Histogram(I)
    
    counter = 0;
    for z = 1:255
        if Histogram(z) =  = 0
            break;
        else
            counter = counter+1;
        end
    end

    min_arr2 = zeros(r,c);
    %III = im2double(III);
    out = zeros(1,counter);
    for k = 1:counter
        min_arr2 = (I =  = k);
        min_arr2 = uint8(min_arr2);
        out(k) = sum(sum(min_arr2.*III))/Histogram(k);
    end
    area = zeros(256,1);
    midpixlres = zeros(256,1);

    for k = 1:counter
        area(k,1) = Histogram(1,k);
        midpixlres(k,1) = out(1,k);
    end

    T = table(midpixlres,area);
    filename = 'tableInfo.xlsx';
    writetable(T,filename,'Sheet',1,'Range','A1')

end
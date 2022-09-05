function Output_Image = My_Imresize_BL (Input_Image, Resizing_Factor)

    [_nx, _ny] = size(Input_Image);
    _fnx = floor(Resizing_Factor * _nx);
    _fny = floor(Resizing_Factor * _ny);
    Output_Image = zeros(_fnx, _fny,class(Input_Image));

    _a = 1:(_nx-1)/(_fnx-1):_nx;
    _tmpImg1 = zeros(_fnx, _ny,class(Input_Image));

    for i=1:_fnx
        _fai = floor(_a(i));
        _frac = _a(i)- _fai;
        if _frac
            _tmpImg1(i,:)=(1-_frac)*Input_Image(_fai,:)+_frac*Input_Image(_fai+1,:);
        else    
             _tmpImg1(i,:)= Input_Image(_a(i),:);
        end
    end
    
    _b = 1:(_ny-1)/(_fny-1):_ny;
    _tmpImg2 = zeros(_fnx, _fny,class(Input_Image));

    for j=1:_fny
        _fbi = floor(_b(j));
        _frac = _b(j)- _fbi;
        if _frac
            _tmpImg2(:,j)=(1-_frac)*_tmpImg1(:,_fbi)+_frac*_tmpImg1(:,_fbi+1);
            
        else    
             _tmpImg2(:,j)= _tmpImg1(:,_b(j));
        end
    end    

    Output_Image = _tmpImg2

end


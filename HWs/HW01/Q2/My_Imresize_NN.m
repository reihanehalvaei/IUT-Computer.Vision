function Output_Image = My_Imresize_NN (Input_Image, Resizing_Factor)

    [_nx, _ny] = size(Input_Image);
    _fnx = floor(Resizing_Factor * _nx);
    _fny = floor(Resizing_Factor * _ny);
    Output_Image = zeros(_fnx, _fny,class(Input_Image));

    _a = 1:(_nx-1)/(_fnx-1):_nx;
    _tmpImg1 = zeros(_fnx, _ny,class(Input_Image));

    for i=1:_fnx
        _fai = floor(_a(i));
        _frac = _a(i)- _fai;
        _frac_nxt = abs(_a(i)-(_fai+1));
        
        if _frac<_frac_nxt
            _tmpImg1(i,:)=Input_Image(_fai,:);
        else    
             _tmpImg1(i,:)= Input_Image(_fai+1,:);
        end
    end
    
    _b = 1:(Ny-1)/(Nv-1):Ny;
    _tmpImg2 = zeros(_fnx, Nv,class(Input_Image));

    for j=1:Nv
        _fbi = floor(_b(j));
        _frac = _b(j)- _fbi;
        _frac_nxt = abs(_b(j)-(_fbi+1));
        if _frac<_frac_nxt
            _tmpImg2(:,j) = _tmpImg1(:,_fbi);
            
        else    
             _tmpImg2(:,j)=_tmpImg1(:,_fbi+1);
        end
    end
    
    Output_Image = _tmpImg2

end


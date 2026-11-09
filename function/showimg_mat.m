% Shared figure helper: Arrange stimulus images on a tiled canvas.
function showimg = showimg_mat(imgmat,range,colorornot)

if colorornot == 1
    putall=imgmat(:,:,:,range);
    if rem(length(range),sqrt(length(range)))==0
        numwidth=fix(sqrt(size(putall,4)));
    elseif rem(length(range),sqrt(length(range)))~=0
        numwidth=fix(sqrt(size(putall,4)))+1;
    end

    whitepic=uint8(ones(size(imgmat,1),size(imgmat,1))*255);
    len=size(putall,4)+1:numwidth^2;
    putall(:,:,:,len)=repmat(whitepic,1,1,3,length(len));
    show=[];
    for w=1:numwidth
        lenimage=[];
        for le=1:numwidth
            lenimage=[lenimage,putall(:,:,:,numwidth*(w-1)+le)];
        end
        show=[show;lenimage];
    end
    showimg = uint8(show);
else
    putall=imgmat(:,:,range);
    if rem(length(range),sqrt(length(range)))==0
        numwidth=fix(sqrt(size(putall,3)));
    elseif rem(length(range),sqrt(length(range)))~=0
        numwidth=fix(sqrt(size(putall,3)))+1;
    end

    whitepic=uint8(ones(size(imgmat,1),size(imgmat,1))*255);
    len=size(putall,3)+1:numwidth^2;
    putall(:,:,len)=repmat(whitepic,1,1,length(len));
    show=[];
    for w=1:numwidth
        lenimage=[];
        for le=1:numwidth
            lenimage=[lenimage,putall(:,:,numwidth*(w-1)+le)];
        end
        show=[show;lenimage];
    end
    showimg = uint8(show);
end

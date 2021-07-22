function [warpI2,mask]=warp(im, warp_name,mode)
    load(warp_name)
    if nargin <3
        mode = 'offset';
    end

    [height2,width2,nchannels]=size(im);
    [height1,width1]=size(vxf);

    [xx,yy]=meshgrid(1:width2,1:height2);
    [XX,YY]=meshgrid(1:width1,1:height1);

    if strcmp(mode, 'offset')
        XX=XX+vxf;
        YY=YY+vyf;
    end

    if strcmp(mode,'abs')
        XX = vxf;
        YY = vyf;
    end

    mask=XX<1 | XX>width2 | YY<1 | YY>height2;
    XX=min(max(XX,1),width2);
    YY=min(max(YY,1),height2);

    for i=1:nchannels
        foo=interp2(xx,yy,im(:,:,i),XX,YY,'linear');

        foo(mask)=0.6;
        warpI2(:,:,i)=foo;
    end

    mask=1-mask;

%     load match
    
%     % Target
%     [N M T]=size(I)  % Tamaños
% 
%     % Coordenadas originales
%     X=(1:M)+zeros(N,1);  Y=(1:N)'+zeros(1,M);
% 
%     % Sumo desplazamientos
%     X=X+vxf; Y=Y+vyf;
% 
%     % Deformo target (im1) para ajustarse a input (im0)  --> im2
%     I3 = I;
%     for k = 1:T
%        I3(:,:,T)= interp2(I2(:,:,T),X,Y,'bilinear');
%     end

end
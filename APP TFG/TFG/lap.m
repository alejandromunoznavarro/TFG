function [l, t]=lap(im,N)

    l=cell(1,N);
    t=cell(N-1,2);
    % Hacemos bucle
    for k = 1:N-1
        t{k,1} = size(im,1);
        t{k,2} = size(im,2);
        red=imresize(im,1/2);
        im2 = imresize(red,size(im));
        l{k}=im-im2;
        im = red;
    end
    l{N}=red;
return
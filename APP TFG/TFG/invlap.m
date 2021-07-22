function im=invlap(p,t)
    N = length(p); % N�mero de n�veles de la piramide
    im = p{N};
    for k = N-1:-1:1
        size = [t{k,1} t{k,2}];
        im=imresize(im,size);
        im = im+p{k};
    end
end
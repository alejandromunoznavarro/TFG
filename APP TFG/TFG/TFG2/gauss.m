function output=gauss(input, mask, sigma)
    kernel=fspecial('gaussian', sigma*5, sigma);
    z=imfilter(mask, kernel, 'symmetric');
    output=imfilter(input.*mask, kernel, 'symmetric');
    output=output./z;
end
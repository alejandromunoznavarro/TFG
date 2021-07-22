function im = background(im1,im2,mask2)
    
    zona = round(1-mask2);
    im = im2.*zona;
    se = strel('disk',round(min(size(mask2,1),size(mask2,2))/25)); 
    for k = 1:3
        mask2(:,:,k)=imdilate(mask2(:,:,k),se);
        im(:,:,k) = regionfill(im(:,:,k),mask2(:,:,k));
    end
    sigma_fondo = std(im(mask2==0));
    sigma_gauss = round(max(size(im))/(1+sigma_fondo*100));
    im = imgaussfilt(im, sigma_gauss);
    im = imresize(im,[size(im1,1) size(im1,2)]);
end
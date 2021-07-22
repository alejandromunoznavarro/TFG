function im2=sharpness(OM,I2)
    percentil1=prctile(OM,95,'all')-prctile(OM,5,'all');
    lambda = round(min(size(OM))/256);
    
    N1 = floor(sqrt(lambda))
    [b1,t1] = lap(OM,N1+3);
    percentil2=prctile(I2,95,'all')-prctile(I2,5,'all');
    lambda = round(min(size(I2))/256);
    N2 = floor(sqrt(lambda))
    [b2,t2] = lap(I2,N2+3);
    j = N2;
    for k=N1:N1+2
        p1=prctile(abs(b1{k}),90,'all')/percentil1
        p2=prctile(abs(b2{j}),90,'all')/percentil2
        p=p2/p1
        b1{k}=b1{k}*p;
        j = j+1;
    end

    im2 = invlap(b1,t1);
end
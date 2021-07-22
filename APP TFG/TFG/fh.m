function T = fh(I)
    K=[1 0 -1]/2;
    sigmaS = min(size(I))/16;
    [GX GY] = grad(I,K);
    G=sqrt(GX(2:end-1,:).^2+GY(:,2:end-1).^2);
    sigmaR = double(prctile(G,90,'all'));
    G=fspecial('gauss',round(2*sigmaS+1),sigmaS);
    LP=imfilter(I,G,'replicate');
    H=abs(I-LP);
    m=min(I(:));
    M=max(I(:));
    T = bilateralFilter(H,I,m,M,(8*sigmaS),sigmaR);
end
function T = fb(I)
    K=[1 0 -1]/2;
    sigmaS = min(size(I))/16;
    [GX GY] = grad(I,K);
    G=sqrt(GX(2:end-1,:).^2+GY(:,2:end-1).^2);
    sigmaR = double(prctile(G,90,'all'));
    m=min(I(:));
    M=max(I(:));
    T = bilateralFilter(I,I,m,M,sigmaS,sigmaR);
    
    
end
function D = gradient_reversal(D,I)

    K=[1 0 -1]/2;
    [DX,DY]=grad(D,K);
    [IX,IY]=grad(I,K);
    xv=DX; yv=DY;
    pos = abs(DX)>abs(IX); xv(pos) = IX(pos);
    pos = abs(DY)>abs(IY); yv(pos) = IY(pos); 
    xv(sign(DX)~=sign(IX))=0;
    yv(sign(DY)~=sign(IY))=0;
    
    D=poisson_reconstruction(xv,yv,K,D); % Recuperamos D from Dx,Dy modificados

end
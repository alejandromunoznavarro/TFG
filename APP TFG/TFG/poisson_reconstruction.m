function X = poisson_reconstruction(Ix, Iy, K, Xo)
    
    X = Xo;
    Ixx=conv2(Ix,K,'full'); Iyy=conv2(Iy,K','full');
    b=Ixx+Iyy;
    r = b-aplicar_A(X,K);
    d=r;
    r2 = dot(r(:),r(:));
    b2 = dot(b(:),b(:));
    cont = 0;
    while (sqrt(r2/b2)>10^-6)
%         if mod(cont,50) == 0
%             fprintf('Error = %2d \n',sqrt(r2/b2));
%         end
        cont = cont+1;
        
        Ad = aplicar_A(d,K);
        alpha = r2/dot(d(:),Ad(:));
        X = X + alpha * d;
        r = r - alpha * Ad;
        newr2 = dot(r(:),r(:));
        beta = newr2/r2;
        d = r + beta * d;
        r2=newr2;
    end
    
    
return

function Ax=aplicar_A(x,K)
%KK=fliplr(K);
 Ix=conv2(x,K,'valid');  Ixx=conv2(Ix,K,'full');
 Iy=conv2(x,K','valid'); Iyy=conv2(Iy,K','full');
 Ax=Ixx+Iyy;
return
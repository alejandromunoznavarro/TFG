function OM = preservation(O,I,I2)
    % 1. MATCH HISTOGRAMA O Y MODELO
    OM = imhistmatch(O,I2);
    % 2. GRADIENTES
    % - CALCULO SIGMA
    pO95 = double(prctile(OM,90,'all'));
    pO5 = double(prctile(OM,5,'all'));
    pI95 = double(prctile(I,90,'all'));
    pI5 = double(prctile(I,5,'all'));
    sigma = (pO95 - pO5)/(pI95 - pI5);
    % - CALCULO ALPHA
    alpha = sigma/4;
    % - CALCULO V
    tau = 0.1;
    v = 1-(1-(((I-tau).^2)/(tau.^2))).^2;
    v(I<tau)=0;
    v(I>(2*tau))=1;
    % - CALCULO BETA
    beta = 1 + 3 * v * sigma;
    % - CALCULO IMAGEN
    K=[1 0 -1]/2;
    [OX,OY]=grad(OM,K);
    [IX,IY]=grad(I,K);
    xv=OX; yv=OY;

    aux = beta(:,2:end-1).*IX;
    pos = abs(OX)>(beta(:,2:end-1).*abs(IX));
    xv(pos)=aux(pos);

    aux = beta(2:end-1,:).*IY;
    pos = abs(OY)>(beta(2:end-1,:).*abs(IY));
    yv(pos)=aux(pos);

    aux = alpha*IX;
    pos = abs(OX)<(alpha*abs(IX));
    xv(pos)=aux(pos);

    aux = alpha*IY;
    pos = abs(OY)<(alpha*abs(IY));
    yv(pos)=aux(pos);
    % - POISSON
    OM=poisson_reconstruction(xv,yv,K,OM);
end
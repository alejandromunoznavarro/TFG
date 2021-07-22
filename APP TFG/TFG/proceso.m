%im=imread('elefantito.jpg'); 
im=imread('img/rock_input.png');
%im=imread('rock_model.png');
im=rgb2gray(im); im=im2double(im); %im=log(1+im)/log(2);

[N M]=size(im);
sd=round(min(size(im))/16);


tipo_grad=2;

switch tipo_grad
    case 1,
      K=[1 -1]; sr=0.13;
    case 2,
      K=[1 0 -1]/2; sr=0.1;
end

[Ix,Iy]=grad(im,K);  % Punto de partida = Gradientes

% ESTIMACION sigma_rango ~90% de ||grad||
switch tipo_grad
    case 1,
      G=sqrt(Ix(1:end-1,:).^2+Iy(:,1:end-1).^2);      
    case 2,
      G=sqrt(Ix(2:end-1,:).^2+Iy(:,2:end-1).^2);     
end
[h v]=hist(G(:),200); h=h/sum(h); cc=cumsum(h);
figure(1); plot(v,cc);
umbral=0.90;
k=sum(cc<=umbral)+1;
sr=v(k);
hold on; plot([sr sr],[0 cc(k)],'k:'); hold off

fprintf('Sd %.0f  Sr %.2f\n',sd,sr);

% Separación BASE + DETALLE con Bilateral
B=bilateralFilter(im,im,min(im(:)),max(im(:)),sd,sr); 
D=im-B; D=D-mean2(D); B=im-D;

figure(2); imshow(B);
figure(3); imagesc(D); colormap(copper); colorbar('vert');

% Correción de detalle
[Dx,Dy]=grad(D,K);  vx=Dx; vy=Dy;
vx(sign(Dx)~=sign(Ix))=0;
vy(sign(Dy)~=sign(Iy))=0;
rev=abs(Dx)>abs(Ix);  vx(rev)=Ix(rev);
rev=abs(Dy)>abs(Iy);  vy(rev)=Iy(rev);
DD=poisson_GC(vx,vy,K,D); % Recuperamos D from Dx,Dy modificados

res=corregir_rec(DD); DD=DD-res;
BB=im-DD;
figure(4); imshow(BB);
figure(5); imagesc(DD); colormap(copper); colorbar('vert');

% Histogram matching de base

% OBTENCION de TEXTURA



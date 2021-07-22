function X=poisson_GC_profe(Ix,Iy,K,X)
NITER=2000;

N=size(Ix,1); M=size(Iy,2); 

if nargin<4, X=0.5*ones(N,M); end
if nargin<3, K=[1 -1]; end

Ixx=conv2(Ix,K,'full'); Iyy=conv2(Iy,K','full'); 
G=Ixx+Iyy;

% Se trata ahora de hallar imagen tal que im_xx+im_yy = G

%for k=1:N-1, X(k+1,:)=X(k,:)+Iy(k,:); end
%for k=1:M-1, X(:,k+1)=X(:,k)+Ix(:,k); end

figure(6); ii=imshow(X); title('POISSON');
% pause

BETA=zeros(1,NITER);
ALFA=zeros(1,NITER);
DELTA=zeros(1,NITER);
RES=zeros(1,NITER);

r=G-aplicar_A(X,K); d=r;  r2=dot(r(:),r(:));

r0=r2; 
fprintf('Residuo Inicial %.1e. Media |G| %.3f\n',r0,mean2(abs(G)));

e=1e-6; e2=e*e;

k=1;
while(k<=NITER) %&& (r2>e2*r0)
  Ad=aplicar_A(d,K);  
  
  alfa=r2/dot(d(:),Ad(:));
  X=X+alfa*d; r=r-alfa*Ad; newr2=dot(r(:),r(:));
  beta=newr2/r2; d = r+beta*d; 
  
  %d(1,:)=0; d(end,:)=0; d(:,1)=0; d(:,end)=0;
  
  r2=newr2;    
  
  ALFA(k)=alfa; BETA(k)=beta; DELTA(k)=dot(d(:),d(:)); RES(k)=r2;
    
  if mod(k,50)==0, 
    r=G-aplicar_A(X,K);  
    r2=dot(r(:),r(:));
    fprintf('Iter %2d  r2 %.1e  ||d|| %.1e -> DIFG %.1e\n',...
        k,r2,sum(sum(d.*d)),mean2(abs(r)));
    set(ii,'Cdata',X); drawnow;    
  end
  k=k+1;
end

figure(7); 
n=(1:k-1); plot(n,ALFA(n),n,BETA(n));
figure(8); semilogy(n,DELTA(n),n,RES(n));

return

function Ax=aplicar_A(x,K)
%KK=fliplr(K);
 Ix=conv2(x,K,'valid');  Ixx=conv2(Ix,K,'full');
 Iy=conv2(x,K','valid'); Iyy=conv2(Iy,K','full');
 Ax=Ixx+Iyy;
return

% function Ax=aplicar_A(x,K)
% KK=fliplr(K);
%  Ix=conv2(x,K,'same');  Ixx=conv2(Ix,K,'same');
%  Iy=conv2(x,K','same'); Iyy=conv2(Iy,K','same');
%  Ax=Ixx+Iyy;
% return
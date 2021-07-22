function [Ix,Iy]=grad(im,K)
% Filtra im con kernel K quedandose con valid
if nargin==1, K=[1 -1]; end

Ix=conv2(im,K,'valid');  Iy=conv2(im,K','valid');


%Ix=im(:,2:end)-im(:,1:end-1);
%Iy=im(2:end,:)-im(1:end-1,:);
return
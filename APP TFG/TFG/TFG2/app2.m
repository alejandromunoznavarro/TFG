clear
clc

input = imread("./data/flickr2/imgs/2187287549_74951db8c2_o.png");
match = imread("./data/martin/imgs/0.png");

Lab = im2double(rgb2lab(input));
Lab2 = im2double(rgb2lab(match));

mask_input = im2double(imread("./data/flickr2/masks/2187287549_74951db8c2_o.png"));
mask_match = im2double(imread("./data/martin/masks/0.png"));

% input_mask = Lab.*mask_input;

Im = Lab(:,:,1)/100;
Im2 = Lab2(:,:,1)/100;

n = 6;

% debería añadir el fondo bien y no lo hace
% I = Im.*mask_input(:,:,1) + Im3.*(1-mask_input(:,:,1));

% AÑADIMOS EL NUEVO FONDO
Im3 = warp(Im,min(Im2,1-mask_match(:,:,1)));
fondo = min(Im3,1-mask_input(:,:,1));
mask_match2=min(warp(mask_input(:,:,1),mask_match(:,:,1)),mask_input(:,:,1));
% I = Im.*mask_input(:,:,1)+fondo;
% I2 = Im2;

I = Im;
I2 = Im2;
figure(5);
imshow(mask_match2);

% % MULTISCALE DECOMPOSITION
% [Laplacianas, Laplacianas2, Residual, Residual2] = multiscale_decomposition(I,mask_input,I2,min(mask_match,mask_input),n);
% 
% % LOCAL ENERGY
% [Energy, Energy2] = local_energy(Laplacianas, mask_input, Laplacianas2,min(mask_match,mask_input),n);
% 
% % ROBUST TRANSFER
% RO = warp(Residual, Residual2);
% Laplaciana_output = robust_transfer(Energy,Laplacianas,Energy2,I,RO,mask_input,n);
% 
% Output = RO;
% for k=1:n
%     Output = Output + Laplaciana_output{k};
% end
% Output= max(Output,fondo);
% figure(5);
% imshow(uint8(Output*255));
% 
% % Output = Im2.*(1-mask_input(:,:,1)));
% % for k=1:n
% %     Output = Output + Laplacianas{k};
% % end
% % figure(5);
% % imshow(uint8(Output*255));

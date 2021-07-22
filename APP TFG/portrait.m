function out = portrait(path1, path2, name1, name2)

addpath('./TFG');
addpath('./TFG/TFG2/libs/image_pyramids/');
addpath('./TFG/TFG2');

nombre_sin_formato1 = strsplit(name1,'.');
nombre_sin_formato2 = strsplit(name2,'.');

% CARGAMOS IMÁGENES
input = im2double(imread(strcat(path1,'FGS/',name1)));
% input = im2double(imread(strcat(path1,name1)));
% esto es para comparar
input2 = im2double(imread(strcat(path1,name1)));

match = im2double(imread(strcat(path2,name2)));

% CARGAMOS MÁSCARA DE ENTRADA Y SINO LA CREAMOS
if(exist(strcat(path1,'MASK/',name1))~=0)
    mask_input = im2double(imread(strcat(path1,'MASK/',name1)));
else
    mask_input = crear_mask(input);
    imwrite(mask_input,strcat(path1,'MASK/',name1))
end
    


% AMPLIAMOS LA MÁSCARA DE INPUT Y LA APLICAMOS (MWJOR SIN ELLO)
% se = strel('disk',round(min(size(input,1),size(input,2))/100));
% input = input.*imdilate(mask_input,se);
% input = input.*mask_input;
% figure(1);
% subplot(1,2,1); imshow(fgs); title('input');
% subplot(1,2,2); imshow(input); title('fgs');

% CARGAMOS MÁSCARA DE ENTRADA Y SINO LA CREAMOS
if(exist(strcat(path2,'MASK/',name2))~=0)
    mask_match = im2double(imread(strcat(path2,'MASK/',name2)));
else
    mask_match = crear_mask(match);
    imwrite(mask_match,strcat(path2,'MASK/',name2))
end

% CARGAMOS WARP OBTENIDO EN WINDOWS
warp_name = strcat(path1,'WARP/',nombre_sin_formato1{1},nombre_sin_formato2{1},'.mat');

% MOSTRAMOS MÁSCARAS E IMÁGENES
figure(2);
subplot(1,4,1); imshow(input2); title('Entrada');
subplot(1,4,3); imshow(match); title('Referencia');
subplot(1,4,2); imshow(mask_input); title('Máscara Entrada');
subplot(1,4,4); imshow(mask_match); title('Máscara Referencia');

% CALCULAMOS FONDO Y PROBAMOS CON LOS GUARDADOS
fondo = background(input,match,mask_match);
    % fondo_guardado = im2double(imread(strcat(path2,'BACKGROUND/',nombre_sin_formato2{1},'.jpg')));
figure(3);
subplot(1,2,1); imshow(match.*(1-mask_match)); title('Imagen de referencia');
subplot(1,2,2); imshow(fondo); title('Fondo Calculado');

% APLICAMOS EL FONDO A LA IMAGEN DE ENTRADA 
Im = input.*mask_input + (1-mask_input).*fondo;
figure(4);
subplot(1,3,1); imshow(input2); title('Entrada');
subplot(1,3,2); imshow(match); title('Referencia');
subplot(1,3,3); imshow(Im); title('Entrada + Fondo Referencia');

Lab = rgb2lab(Im);
Lab2 = rgb2lab(match);

n = 6;
Output=Lab;
for ch = 1:3
    I = Lab(:,:,ch);
    I2 = Lab2(:,:,ch);
    
    % DESCOMPOSICIÓN MULTIESCALAR
    % Devuelve las n+1 Laplacianas sin hacer deformación y el residuo.
    [Laplacianas, Laplacianas2, Residual, Residual2] = multiscale_decomposition(I,bin_alpha(mask_input(:,:,ch)),I2,bin_alpha(mask_input(:,:,ch))|bin_alpha(mask_match(:,:,ch)),n);
    
    % ENERGÍA LOCAL
    [Energy, Energy2] = local_energy(Laplacianas, bin_alpha(mask_input(:,:,ch)), Laplacianas2,bin_alpha(mask_input(:,:,ch))|bin_alpha(mask_match(:,:,ch)),n,warp_name);
    
    % DEFORMACIÓN
    RO = warp(Residual2,warp_name);
    
    % TRANSFERENCIA ROBUSTA
    Laplaciana_output = robust_transfer(Energy,Laplacianas,Energy2,I,RO,bin_alpha(mask_input(:,:,ch)),n);
    
    Output(:,:,ch) = RO;
    for k=1:n+1
        Output(:,:,ch) = Output(:,:,ch) + Laplaciana_output{k};
    end
end
Output = lab2rgb(Output);
figure(10);
subplot(1,3,1); imshow(input2); title('Entrada');
subplot(1,3,2); imshow(match); title('Referencia');
subplot(1,3,3); imshow(Output); title('Resultado');


% APLICAMOS FONDO DE NUEVO
Output = Output.*mask_input + (1-mask_input).*fondo;
figure(11);
subplot(1,3,1); imshow(input2); title('Entrada');
subplot(1,3,2); imshow(match); title('Referencia');
subplot(1,3,3); imshow(Output); title('Resultado + Fondo');

% TRATAMIENTO DE LOS OJOS
im_in = Im;
out = Output;
%     alpha_l = im2double(imread(strcat(path1,'OJOS/001_alpha_l.png')));
%     alpha_r = im2double(imread(strcat(path1,'OJOS/001_alpha_r.png')));
%     fg_l = im2double(imread(strcat(path1,'OJOS/001_fg_l.png')));
%     fg_r = im2double(imread(strcat(path1,'OJOS/001_fg_r.png')));
%
%     % VISUALIZAR OJOS
%     % figure(9);
%     % subplot(1,4,1); imshow(alpha_l); title('alpha_l');
%     % subplot(1,4,2); imshow(alpha_r); title('alpha_r')
%     % subplot(1,4,3); imshow(fg_l); title('fg_l');
%     % subplot(1,4,4); imshow(fg_r); title('fg_r')
%     nombre_sin_formato = strsplit(name1,'.');
%     ruta = strcat(path1,'LANDMARKS/',nombre_sin_formato{1},'.lm');
%
%     model = csvread(ruta);
%     leye_center = round(mean(model(37:42, :),1));
%     reye_center = round(mean(model(43:48, :),1));
%
%     half_width= 75;
%     half_height = 50;
%
%     leye_raw=im_in(leye_center(2)-half_height : leye_center(2) + half_height,...
%                      leye_center(1)-half_width  : leye_center(1) + half_width,:);
%     reye_raw=im_in(reye_center(2)-half_height : reye_center(2) + half_height,...
%                      reye_center(1)-half_width  : reye_center(1) + half_width,:);
%     leye = out(leye_center(2)-half_height : leye_center(2) + half_height,...
%                      leye_center(1)-half_width  : leye_center(1) + half_width,:);
%     reye = out(reye_center(2)-half_height : reye_center(2) + half_height,...
%                      reye_center(1)-half_width  : reye_center(1) + half_width,:);
%     leye_new = eye_transfer(leye, leye_raw, alpha_l, fg_l);
%     reye_new = eye_transfer(reye, reye_raw, alpha_r, fg_r);
%     out(leye_center(2)-half_height : leye_center(2) + half_height,...
%                      leye_center(1)-half_width  : leye_center(1) + half_width,:)=leye_new;
%     out(reye_center(2)-half_height : reye_center(2) + half_height,...
%                      reye_center(1)-half_width  : reye_center(1) + half_width,:)=reye_new;
%
% figure(9);
% subplot(1,3,1); imshow(input); title('input');
% subplot(1,3,2); imshow(match); title('match');
% subplot(1,3,3); imshow(out); title('out')

end



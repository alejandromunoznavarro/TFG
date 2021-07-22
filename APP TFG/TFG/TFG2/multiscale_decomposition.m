function [Laplacianas, Laplacianas2, Residual, Residual2] = multiscale_decomposition(I,Mask,I2,Mask2,n)
    
Laplacianas = laplaciana(I,Mask,n);
Residual = gauss(I,Mask,2^n);

figure(5);
subplot(3,3,1);imshow(uint8((I/100)*255));title({'Descomposición Multiescalar';'Entrada'});
subplot(3,3,2);imagesc(Laplacianas{1}); colormap('gray'); title({'Descomposición Multiescalar';'L_0'});
subplot(3,3,3);imagesc(Laplacianas{2}); colormap('gray'); title({'Descomposición Multiescalar';'L_1'});
subplot(3,3,4);imagesc(Laplacianas{3}); colormap('gray'); title({'Descomposición Multiescalar';'L_2'});
subplot(3,3,5);imagesc(Laplacianas{4}); colormap('gray'); title({'Descomposición Multiescalar';'L_3'});
subplot(3,3,6);imagesc(Laplacianas{5}); colormap('gray'); title({'Descomposición Multiescalar';'L_4'});
subplot(3,3,7);imagesc(Laplacianas{6}); colormap('gray'); title({'Descomposición Multiescalar';'L_5'});
subplot(3,3,8);imagesc(Laplacianas{7}); colormap('gray'); title({'Descomposición Multiescalar';'L_6'});
subplot(3,3,9);imshow(uint8((Residual/100)*255)); colormap('gray'); title({'Descomposición Multiescalar';'Residuo'});

Laplacianas2 = laplaciana(I2,Mask2,n);
Residual2 = gauss(I2,Mask2,2^n);

figure(6);
subplot(3,3,1);imshow(uint8((I2/100)*255));title({'Descomposición Multiescalar';'Referencia'});
subplot(3,3,2);imagesc(Laplacianas2{1}); colormap('gray'); title({'Descomposición Multiescalar';'L_0'});
subplot(3,3,3);imagesc(Laplacianas2{2}); colormap('gray'); title({'Descomposición Multiescalar';'L_1'});
subplot(3,3,4);imagesc(Laplacianas2{3}); colormap('gray'); title({'Descomposición Multiescalar';'L_2'});
subplot(3,3,5);imagesc(Laplacianas2{4}); colormap('gray'); title({'Descomposición Multiescalar';'L_3'});
subplot(3,3,6);imagesc(Laplacianas2{5}); colormap('gray'); title({'Descomposición Multiescalar';'L_4'});
subplot(3,3,7);imagesc(Laplacianas2{6}); colormap('gray'); title({'Descomposición Multiescalar';'L_5'});
subplot(3,3,8);imagesc(Laplacianas2{7}); colormap('gray'); title({'Descomposición Multiescalar';'L_6'});
subplot(3,3,9);imshow(uint8((Residual2/100)*255)); colormap('gray'); title({'Descomposición Multiescalar';'Residuo'});
end
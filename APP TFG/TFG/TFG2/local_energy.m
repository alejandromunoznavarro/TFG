function [Energy, Energy2] = local_energy(Laplacianas, Mask, Laplacianas2, Mask2, n,warp_name)
Energy = cell(1,n+1);
Energy2 = cell(1,n+1);
for l = 0:n
    sigma = 2^(l+1);
    Energy{l+1} = gauss((Laplacianas{l+1}.^2),Mask,sigma);
    Energy2{l+1} = warp(gauss((Laplacianas2{l+1}.^2),Mask2 ,sigma),warp_name);
end

figure(7);
subplot(2,7,1);imagesc(Energy{1}); colormap('jet'); title({'Energía Local';'S[E]_0'});
subplot(2,7,2);imagesc(Energy{2}); colormap('jet'); title({'Energía Local';'S[E]_1'});
subplot(2,7,3);imagesc(Energy{3}); colormap('jet'); title({'Energía Local';'S[E]_2'});
subplot(2,7,4);imagesc(Energy{4}); colormap('jet'); title({'Energía Local';'S[E]_3'});
subplot(2,7,5);imagesc(Energy{5}); colormap('jet'); title({'Energía Local';'S[E]_4'});
subplot(2,7,6);imagesc(Energy{6}); colormap('jet'); title({'Energía Local';'S[E]_5'});
subplot(2,7,7);imagesc(Energy{7}); colormap('jet'); title({'Energía Local';'S[E]_6'});
subplot(2,7,8);imagesc(Energy2{1}); colormap('jet'); title({'Energía Local';'S[R]_0'});
subplot(2,7,9);imagesc(Energy2{2}); colormap('jet'); title({'Energía Local';'S[R]_1'});
subplot(2,7,10);imagesc(Energy2{3}); colormap('jet'); title({'Energía Local';'S[R]_2'});
subplot(2,7,11);imagesc(Energy2{4}); colormap('jet'); title({'Energía Local';'S[R]_3'});
subplot(2,7,12);imagesc(Energy2{5}); colormap('jet'); title({'Energía Local';'S[R]_4'});
subplot(2,7,13);imagesc(Energy2{6}); colormap('jet'); title({'Energía Local';'S[R]_5'});
subplot(2,7,14);imagesc(Energy2{7}); colormap('jet'); title({'Energía Local';'S[R]_6'});


end
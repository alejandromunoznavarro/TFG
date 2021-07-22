function Laplaciana_output = robust_transfer(Energy,Laplacianas,Energy2,I,RO,Mask,n)
    Gain = Energy;
    RobustGain = Energy;
    Laplaciana_output = Laplacianas;
    C = 0.01^2;
    OH = 2.8;
    OL = 0.9;
    B = 3;
    for l = 0:n
        Gain{l+1} = sqrt(Energy2{l+1}./(Energy{l+1}+C));
        RobustGain{l+1} = gauss(max(min(Gain{l+1},OH),OL),Mask,B*(2^l));
        Laplaciana_output{l+1} = Laplacianas{l+1}.*RobustGain{l+1};
    end

    figure(8);
    subplot(1,7,1);imagesc(RobustGain{1}); colormap('jet'); title({'Transferencia Robusta';'G_0'});
    subplot(1,7,2);imagesc(RobustGain{2}); colormap('jet'); title({'Transferencia Robusta';'G_1'});
    subplot(1,7,3);imagesc(RobustGain{3}); colormap('jet'); title({'Transferencia Robusta';'G_2'});
    subplot(1,7,4);imagesc(RobustGain{4}); colormap('jet'); title({'Transferencia Robusta';'G_3'});
    subplot(1,7,5);imagesc(RobustGain{5}); colormap('jet'); title({'Transferencia Robusta';'G_4'});
    subplot(1,7,6);imagesc(RobustGain{6}); colormap('jet'); title({'Transferencia Robusta';'G_5'});
    subplot(1,7,7);imagesc(RobustGain{7}); colormap('jet'); title({'Transferencia Robusta';'G_6'});
    
    figure(9);
    subplot(3,3,1);imshow(uint8((I/100)*255));title({'Robust Transfer Nuevo';'Input'});
    subplot(3,3,2);imagesc(Laplaciana_output{1}); colormap('gray'); title({'Transferencia Robusta';'L_0'});
    subplot(3,3,3);imagesc(Laplaciana_output{2}); colormap('gray'); title({'Transferencia Robusta';'L_1'});
    subplot(3,3,4);imagesc(Laplaciana_output{3}); colormap('gray'); title({'Transferencia Robusta';'L_2'});
    subplot(3,3,5);imagesc(Laplaciana_output{4}); colormap('gray'); title({'Transferencia Robusta';'L_3'});
    subplot(3,3,6);imagesc(Laplaciana_output{5}); colormap('gray'); title({'Transferencia Robusta';'L_4'});
    subplot(3,3,7);imagesc(Laplaciana_output{6}); colormap('gray'); title({'Transferencia Robusta';'L_5'});
    subplot(3,3,8);imagesc(Laplaciana_output{7}); colormap('gray'); title({'Transferencia Robusta';'L_6'});
    subplot(3,3,9);imshow(uint8((RO/100)*255)); colormap('gray'); title({'Robust Transfer';'Residual'});
end
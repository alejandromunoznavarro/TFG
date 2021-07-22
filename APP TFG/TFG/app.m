function Result = app(im_in_name,im_ex_name,format1, format2,color_transfer)

    % CARGAMOS LAS DOS IMAGENES DE PARTIDA
    Ref = imread(sprintf('img/%s.%s', im_ex_name,format1));
    Input = imread(sprintf('img/%s.%s', im_in_name,format2));
    % Input = imresize(Input,1/(size(Input,1)/size(Ref,1)));
    Lab=rgb2lab(Input); Lab=im2double(Lab);
    Lab2=rgb2lab(Ref); Lab2=im2double(Lab2);
    I = Lab(:,:,1)/100;
    I2 = Lab2(:,:,1)/100;

    % MOSTRAMOS IMAGENES / HISTOGRAMAS
    figure(1);
    subplot(2,2,1);imshow(uint8(I2*255));title({'ENTRADA';'Referencia'});
    subplot(2,2,2);imhist(uint8(I2*255));title({'ENTRADA';'Histograma de referencia'});
    subplot(2,2,3);imshow(uint8(I*255));title({'ENTRADA';'Imagen de entrada'});
    subplot(2,2,4);imhist(uint8(I*255));title({'ENTRADA';'Histograma de entrada'});

    % --------------------------------------------------------
    % ---------------------- BACKGROUND ----------------------
    % --------------------------------------------------------

    % 1. HISTOGRAM MATCHING
    Match = imhistmatch(Input,Ref);
    % MOSTRAMOS IMAGEN / HISTOGRAMA
    figure(2);
    subplot(2,2,1);imshow(Ref);title({'HISTOGRAM MATCHING';'Referencia'});
    subplot(2,2,2);imhist(Ref);title({'HISTOGRAM MATCHING';'Histograma de referencia'});
    subplot(2,2,3);imshow(Match);title({'HISTOGRAM MATCHING';'Imagen adaptada'});
    subplot(2,2,4);imhist(Match);title({'HISTOGRAM MATCHING';'Histograma de adaptada'});

    % 3. BILATERAL FILTERING
    B = fb(I);
    B2 = fb(I2);

    % 4. BILATERAL DECOMPOSITION
    D = I - B;
    D2 = I2 - B2;
    figure(3);
    subplot(1,2,1);imshow(uint8(B*255));title({'BILATERAL';'Base entrada'});
    subplot(1,2,2);imagesc(D); colorbar('vert'); title({'BILATERAL';'Detalle entrada'});

    % 5. GRADIENT REVERSAL REMOVAL
    D = gradient_reversal(D,I);
    D2 = gradient_reversal(D2,I2);
    B = I - D;
    B2 = I2 - D2;
    figure(4);
    subplot(1,2,1);imshow(uint8(B*255));title({'GRADIENT';'Base entrada'});
    subplot(1,2,2);imagesc(D); colorbar('vert'); title({'GRADIENT';'Detalle entrada'});

    % 6. TONAL BALANCE
    B3 = imhistmatch(B,B2);
    figure(5);
    subplot(1,3,1);imshow(uint8(B*255));title({'TONAL BALANCE';'Base entrada'});
    subplot(1,3,2);imshow(uint8(B2*255));title({'TONAL BALANCE';'Base referencia'});
    subplot(1,3,3);imshow(uint8(B3*255));title({'TONAL BALANCE';'Base cambiada'});

    % --------------------------------------------------------
    % ------------------------ DETAIL ------------------------
    % --------------------------------------------------------

    % 7. TEXTURENESS
    TI = fh(I);
    TM = fh(I2);
    TB = fh(B3);
    TD = fh(D);
    TI = imhistmatch(TI, TM);

    p = max(0, (TI-TB)./TD);

    O = B3 + p.*D;

    figure(9);
    subplot(1,3,1);imshow(uint8(I*255));title({'DETAIL';'ORIGINAL'});
    subplot(1,3,2);imshow(uint8(I2*255));title({'DETAIL';'REFERENCIA'});
    subplot(1,3,3);imshow(uint8(O*255));title({'DETAIL';'CAMBIADA'});


    % 8. PRESERVATION
    OM = preservation(O,I,I2);

    figure(10);
    subplot(1,3,1);imshow(uint8(I*255));title({'PRESERVATION';'ORIGINAL'});
    subplot(1,3,2);imshow(uint8(O*255));title({'PRESERVATION';'MODEL'});
    subplot(1,3,3);imshow(uint8(OM*255));title({'PRESERVATION';'RESULT'});

    figure(11);
    subplot(1,3,1);imshow(uint8(I*255));title({'PRESERVATION';'ORIGINAL'});
    subplot(1,3,2);imshow(uint8(I2*255));title({'PRESERVATION';'MODEL'});
    subplot(1,3,3);imshow(uint8(OM*255));title({'PRESERVATION';'RESULT'});

    % --------------------------------------------------------
    % ------------------- ADITIONAL EFFECTS ------------------
    % --------------------------------------------------------

    % 9. SOFT FOCUS AND SHARPNESS

    im2=sharpness(OM,I2);
    figure(12)
    subplot(1,2,1);imshow(uint8(OM*255));title({'SOFT FOCUS AND SHARPNESS';'ORIGINAL'});
    subplot(1,2,2);imshow(uint8(im2*255));title({'SOFT FOCUS AND SHARPNESS';'RESULT'});

    OM = im2;
    % 10. FILM GRAIN AND PAPER TEXTURE

    % 11. COLOR AND TONING

    
    
    if color_transfer
        Result = Lab;
        Result(:,:,1) = OM*100;
        Result(:,:,2) = Lab(:,:,2);
        Result(:,:,3) = Lab(:,:,3);
        Result = uint8(lab2rgb(Result)*255);
        I0 = im2double(Result);
        I1 = im2double(Ref);
        Result = cf_reinhard(I0,I1);
        figure(14);
        subplot(1,3,1); imshow(Input); title({'COLOR TRANSFER';'ORIGINAL'});
        subplot(1,3,2); imshow(Ref); title({'COLOR TRANSFER';'MODEL'});
        subplot(1,3,3); imshow(Result); title({'COLOR TRANSFER';'RESULT'});
    else
        Result = Lab;
        Result(:,:,1) = OM*100;
        Result(:,:,2) = (Result(:,:,1)./Lab(:,:,1)).*Lab(:,:,2);
        Result(:,:,3) = (Result(:,:,1)./Lab(:,:,1)).*Lab(:,:,3);
        Result = uint8(lab2rgb(Result)*255);

        figure(13); 
        subplot(1,3,1);imshow(Input);title({'COLOR AND TONING';'ORIGINAL'});
        subplot(1,3,2);imshow(Ref);title({'COLOR AND TONING';'MODEL'});
        subplot(1,3,3);imshow(Result);title({'COLOR AND TONING';'RESULT'}); 
    end
    
    
end
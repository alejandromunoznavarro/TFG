function Result = landscape(path1, path2, name1, name2,color_transfer,sepia_transfer)
    addpath('./TFG/');
    addpath('./TFG/TFG2/');
    % CARGAMOS LAS DOS IMAGENES DE PARTIDA
    Ref = imread(strcat(path2,name2));
    Input = imread(strcat(path1,name1));   
    
    % Input = imresize(Input,1/(size(Input,1)/size(Ref,1)));
    Lab=rgb2lab(Input); Lab=im2double(Lab);
    Lab2=rgb2lab(Ref); Lab2=im2double(Lab2);
    I = Lab(:,:,1)/100;
    I2 = Lab2(:,:,1)/100;

    
    

    % --------------------------------------------------------
    % ---------------------- BACKGROUND ----------------------
    % --------------------------------------------------------

    % 1. HISTOGRAM MATCHING
    Match = imhistmatch(Input,Ref);
    % MOSTRAMOS IMAGEN / HISTOGRAMA
%     figure(1);
%     subplot(1,3,1);imshow(Input);title({'HISTOGRAM MATCHING';'Entrada'});
%     subplot(1,3,2);imshow(Ref);title({'HISTOGRAM MATCHING';'Referencia'});
%     subplot(1,3,3);imshow(Match);title({'HISTOGRAM MATCHING';'Imagen adaptada'});
    
    
    
%     figure(2);
%     subplot(1,3,1);imhist(Input);title({'HISTOGRAM MATCHING';'Histograma de entrada'});
%     subplot(1,3,2);imhist(Ref);title({'HISTOGRAM MATCHING';'Histograma de referencia'});
%     subplot(1,3,3);imhist(Match);title({'HISTOGRAM MATCHING';'Histograma de adaptada'});

    % 3. BILATERAL FILTERING
    B = fb(I);
    B2 = fb(I2);

    % 4. BILATERAL DECOMPOSITION
    D = I - B;
    D2 = I2 - B2;
%     figure(3);
%     subplot(1,3,1);imshow(uint8(I*255));title({'BILATERAL';'Entrada'});
%     subplot(1,3,2);imshow(uint8(B*255));title({'BILATERAL';'Base Entrada'});
%     subplot(1,3,3);imagesc(D); colormap('gray'); title({'BILATERAL';'Detalle Entrada'});

%     figure(4);
%     subplot(1,3,1);imshow(uint8(I2*255));title({'BILATERAL';'Referencia'});
%     subplot(1,3,2);imshow(uint8(B2*255));title({'BILATERAL';'Base Referencia'});
%     subplot(1,3,3);imagesc(D2); colormap('gray'); title({'BILATERAL';'Detalle Referencia'});
    
    % 5. GRADIENT REVERSAL REMOVAL
    base = B;
    detalle = D;
    base2 = B2;
    detalle2 = D2;
    D = gradient_reversal(D,I);
    D2 = gradient_reversal(D2,I2);
    B = I - D;
    B2 = I2 - D2;
    
%     figure(5);
%     subplot(2,2,1);imshow(uint8(base*255));title({'Reversi�n de gradientes';'Base'});
%     subplot(2,2,2);imagesc(detalle); colormap('gray'); title({'Reversi�n de gradientes';'Detalle'});
%     subplot(2,2,3);imshow(uint8(B*255));title({'Reversi�n de gradientes';'Base nueva'});
%     subplot(2,2,4);imagesc(D); colormap('gray'); title({'Reversi�n de gradientes';'Detalle nuevo'});
    
%     figure(6);
%     subplot(2,2,1);imshow(uint8(base2*255));title({'Reversi�n de gradientes';'Base'});
%     subplot(2,2,2);imagesc(detalle2); colormap('gray'); title({'Reversi�n de gradientes';'Detalle'});
%     subplot(2,2,3);imshow(uint8(B2*255));title({'Reversi�n de gradientes';'Base nueva'});
%     subplot(2,2,4);imagesc(D2); colormap('gray'); title({'Reversi�n de gradientes';'Detalle nuevo'});
    
    
    % 6. TONAL BALANCE
    B3 = imhistmatch(B,B2);
%     figure(7);
%     subplot(1,3,1);imshow(uint8(B*255));title({'Balance de Tonos';'Base Entrada'});
%     subplot(1,3,2);imshow(uint8(B2*255));title({'Balance de Tonos';'Base Referencia'});
%     subplot(1,3,3);imshow(uint8(B3*255));title({'Balance de Tonos';'Base Cambiada'});

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

%     figure(9);
%     subplot(1,3,1);imshow(uint8(I*255));title({'Textura';'Entrada'});
%     subplot(1,3,2);imshow(uint8(I2*255));title({'Textura';'Referencia'});
%     subplot(1,3,3);imshow(uint8(O*255));title({'Textura';'Resultado'});


    % 8. PRESERVATION
    OM = preservation(O,I,I2);

%     figure(10);
%     subplot(1,3,1);imshow(uint8(I*255));title({'PRESERVATION';'ORIGINAL'});
%     subplot(1,3,2);imshow(uint8(O*255));title({'PRESERVATION';'MODEL'});
%     subplot(1,3,3);imshow(uint8(OM*255));title({'PRESERVATION';'RESULT'});

%     figure(11);
%     subplot(1,3,1);imshow(uint8(I*255));title({'Preservaci�n';'Entrada'});
%     subplot(1,3,2);imshow(uint8(I2*255));title({'Preservaci�n';'Referencia'});
%     subplot(1,3,3);imshow(uint8(OM*255));title({'Preservaci�n';'Resultado'});

    % --------------------------------------------------------
    % ------------------- ADITIONAL EFFECTS ------------------
    % --------------------------------------------------------

    % 9. SOFT FOCUS AND SHARPNESS

%     im2=sharpness(OM,I2);
%     figure(12)
%     subplot(1,2,1);imshow(uint8(OM*255));title({'SOFT FOCUS AND SHARPNESS';'ORIGINAL'});
%     subplot(1,2,2);imshow(uint8(im2*255));title({'SOFT FOCUS AND SHARPNESS';'RESULT'});
% 
%     OM = im2;
    % 10. FILM GRAIN AND PAPER TEXTURE

    % 11. COLOR AND TONING
    
    if color_transfer
        Result = Lab;
        Result(:,:,1) = OM*100;
        Result = lab2rgb(Result);
        I1 = im2double(Ref);
        Result = cf_reinhard(Result,I1);
%         Result = uint8(lab2rgb(Result)*255);
%         I0 = im2double(Result);
%         I1 = im2double(Ref);
%         Result = cf_reinhard(I0,I1);
%         figure(14);
%         subplot(1,3,1); imshow(Input); title({'Color';'Entrada'});
%         subplot(1,3,2); imshow(Ref); title({'Color';'Referencia'});
%         subplot(1,3,3); imshow(Result); title({'Color';'Resultado'});
    elseif sepia_transfer
        Result(:,:,1) = OM*100;
        L = round(Result(:,:,1));
        a = Lab(:,:,2);
        b = Lab(:,:,3);
        L2 = round(Lab2(:,:,1));
        a2 = Lab2(:,:,2);
        b2 = Lab2(:,:,3);
        
        Lu = unique(L);
        for k = 1:size(Lu)
            pos1 = (L == Lu(k));
            pos2 = (L2 == Lu(k));
            a(pos1) = mean(a2(pos2));
            b(pos1) = mean(b2(pos2));
        end
        
        Result(:,:,2) = a;
        Result(:,:,3) = b;
        Result = uint8(lab2rgb(Result)*255);
%         figure(15);
%         subplot(1,3,1); imshow(Input); title({'Sepia';'Entrada'});
%         subplot(1,3,2); imshow(Ref); title({'Sepia';'Referencia'});
%         subplot(1,3,3); imshow(Result); title({'Sepia';'Resultado'});
    else
        Result = Lab;
        Result(:,:,1) = OM*100;
        Result(:,:,2) = (Result(:,:,1)./Lab(:,:,1)).*Lab(:,:,2);
        Result(:,:,3) = (Result(:,:,1)./Lab(:,:,1)).*Lab(:,:,3);
        Result = uint8(lab2rgb(Result)*255);

%         figure(13); 
%         subplot(1,3,1);imshow(Input);title({'Equivalencia';'Entrada'});
%         subplot(1,3,2);imshow(Ref);title({'Equivalencia';'Referencia'});
%         subplot(1,3,3);imshow(Result);title({'Equivalencia';'Resultado'}); 
    end
    
    
end
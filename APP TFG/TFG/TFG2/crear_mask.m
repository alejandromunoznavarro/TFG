function mask = crear_mask(I1)
    I2 = I1;
    [m,n,~] = size(I2);
    figure; h = imshow(I2,[]);

    uiwait(msgbox(strcat('Marca primero zonas en background\n', ...    
       ' Cuando termines pulsa una tecla para marcar Foreground'),...
       'Instructions','modal'));

    se   = strel('disk',round(min(m,n)/50)); 
    for k = 0:1
      switch k
         case 0, title('Marca BackGround');
         case 1, title('Marca Foreground');
      end

      while waitforbuttonpress < 1

          hk = imfreehand('Closed',0); xy = round(getPosition(hk)); 
          delete(hk);

          dentro = (xy(:,2)>=1) & (xy(:,2)<=m) & (xy(:,1)>=1) & (xy(:,1)<=n);
          xy=xy(dentro,:);

          M = zeros(m,n);
          u = sub2ind(size(M),xy(:,2),xy(:,1));
          M(u) = 1; M=imdilate(M,se);

          for c=1:3, ch=I2(:,:,c); ch(M==1)=k; I2(:,:,c)=ch; end
          set(h,'CData',I2);
       end
    end


    % Ejecutar algoritmo
    addpath('TFG/TFG2/matting');
    mask = runMatting(I1,I2);
    figure(1);
    subplot(1,3,1); imshow(I1); title('Entrada');
    subplot(1,3,2); imshow(I2); title('Selección');
    subplot(1,3,3); imshow(mask); title('Máscara');
    end
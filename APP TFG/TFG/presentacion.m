I = im2double((imread('/Users/alejandro/Desktop/APP TFG/IMAGENES/PAISAJES/portugal.jpg')));

% N = 4;
% 
% base=cell(1,N);
% detalle=cell(1,N-1);
% t=cell(N-1,2);
% base{1} = I;
%     % Hacemos bucle
%     for k = 1:N-1
%         t{k,1} = size(base{k},1);
%         t{k,2} = size(base{k},2);
%         base{k+1}=imresize(base{k},1/2);
%         im2 = imresize(base{k+1},[t{k,1} t{k,2}]);
%         detalle{k}=base{k}-im2;
%     end
%     

% for k=1:N
%     subplot(2,N,k); imshow(base{k});
% end
% for k=1:N-1
%     subplot(2,N,k+N); colormap('gray');imagesc(detalle{k});
% end

% K=[1 0 -1]/2;
%     sigmaS = min(size(I))/16
%     [GX GY] = grad(I,K);
%     G=sqrt(GX(2:end-1,:).^2+GY(:,2:end-1).^2);
%     sigmaR = double(prctile(G,90,'all'))
% 
% sigmaS1 = 1;
% sigmaS2 = 15;
% sigmaS3 = sigmaS;
% sigmaS4 = 100;
% sigmaR1 = sigmaR;
% sigmaR2 = sigmaR+1;
% sigmaR3 = sigmaR+5;
% 
% G1 = imgaussfilt(I,sigmaS1);
% G2 = imgaussfilt(I,sigmaS2);
% G3 = imgaussfilt(I,sigmaS3);
% G4 = imgaussfilt(I,sigmaS4);

% m=min(I(:));
% M=max(I(:));
% 
% B11 = bilateralFilter(I,I,m,M,sigmaS1,sigmaR1);
% B12 = bilateralFilter(I,I,m,M,sigmaS1,sigmaR2);
% B13 = bilateralFilter(I,I,m,M,sigmaS1,sigmaR3);
% 
% B21 = bilateralFilter(I,I,m,M,sigmaS2,sigmaR1);
% B22 = bilateralFilter(I,I,m,M,sigmaS2,sigmaR2);
% B23 = bilateralFilter(I,I,m,M,sigmaS2,sigmaR3);
% 
% B31 = bilateralFilter(I,I,m,M,sigmaS3,sigmaR1);
% B32 = bilateralFilter(I,I,m,M,sigmaS3,sigmaR2);
% B33 = bilateralFilter(I,I,m,M,sigmaS3,sigmaR3);
% 
% B41 = bilateralFilter(I,I,m,M,sigmaS4,sigmaR1);
% B42 = bilateralFilter(I,I,m,M,sigmaS4,sigmaR2);
% B43 = bilateralFilter(I,I,m,M,sigmaS4,sigmaR3);

% figure(1);
% subplot(4,4,1); imshow(B11);
% subplot(4,4,2); imshow(B12);
% subplot(4,4,3); imshow(B13);
% subplot(4,4,4); imshow(G1);
% 
% subplot(4,4,5); imshow(B21);
% subplot(4,4,6); imshow(B22);
% subplot(4,4,7); imshow(B23);
% subplot(4,4,8); imshow(G2);
% 
% subplot(4,4,9); imshow(B31);
% subplot(4,4,10); imshow(B32);
% subplot(4,4,11); imshow(B33);
% subplot(4,4,12); imshow(G3);
% 
% subplot(4,4,13); imshow(B41);
% subplot(4,4,14); imshow(B42);
% subplot(4,4,15); imshow(B43);
% subplot(4,4,16); imshow(G4);

% G = fspecial('gauss',25,5);
% colormap('gray');imagesc(G)

% K=[1 0 -1]/2;
% [IX,IY]=grad(I,K);

red = I;
green = I;
blue = I;
red(:,:,2) = 0;
red(:,:,3) = 0;

green(:,:,1) = 0;
green(:,:,3) = 0;

blue(:,:,1) = 0;
blue(:,:,2) = 0;

% l = I(:,:,1)/100;
% a = I(:,:,2)/100;
% b = I(:,:,3)/100;
figure(1);
subplot(1,4,1); imshow(I);
subplot(1,4,2); imshow(red);
subplot(1,4,3); imshow(green);
subplot(1,4,4); imshow(blue);


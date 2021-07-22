function out = app2(style_in,style_ex,im_in_name,im_ex_name,format1,format2)

    addpath('./TFG2/libs/image_pyramids/');
    addpath('./TFG2');

    input = im2double(imread(sprintf('./TFG2/data/%s/fgs/%s.%s', style_in, im_in_name,format1)));
    match = im2double(imread(sprintf('./TFG2/data/%s/imgs/%s.%s', style_ex, im_ex_name,format2)));

    mask_input = im2double(imread(sprintf('./TFG2/data/%s/masks/%s.png', style_in, im_in_name)));
    mask_match = im2double(imread(sprintf('./TFG2/data/%s/masks/%s.png', style_ex, im_ex_name)));

    fondo = im2double(imread(sprintf('./TFG2/data/%s/bgs/%s.jpg', style_ex, im_ex_name)));

    Im = input.*mask_input + (1-mask_input).*fondo;

    Lab = rgb2lab(Im);
    Lab2 = rgb2lab(match);



    n = 6;

    Output=Lab;
    for ch = 1:3
        I = Lab(:,:,ch);
        I2 = Lab2(:,:,ch);

        % MULTISCALE DECOMPOSITION
        % Devuelve las n+1 Laplacianas sin hacer warping y el residuo.
        [Laplacianas, Laplacianas2, Residual, Residual2] = multiscale_decomposition(I,bin_alpha(mask_input(:,:,1)),I2,bin_alpha(mask_input(:,:,1))|bin_alpha(mask_match(:,:,1)),n);

        % LOCAL ENERGY
        [Energy, Energy2] = local_energy(Laplacianas, bin_alpha(mask_input(:,:,1)), Laplacianas2,bin_alpha(mask_input(:,:,1))|bin_alpha(mask_match(:,:,1)),n);

        % ROBUST TRANSFER
        RO = warp(Residual2);
        Laplaciana_output = robust_transfer(Energy,Laplacianas,Energy2,I,RO,bin_alpha(mask_input(:,:,1)),n);

        Output(:,:,ch) = RO;
        for k=1:n
            Output(:,:,ch) = Output(:,:,ch) + Laplaciana_output{k};
        end
    end
    Output = lab2rgb(Output);
    Output = Output.*mask_input + (1-mask_input).*fondo;
    figure(8);
    subplot(1,2,1); imshow(uint8(Output*255)); title('out');
    subplot(1,2,2); imshow(match); title('match')

    % TRATAMIENTO DE LOS OJOS
    im_in = Im;
    out = Output;
    alpha_l = im2double(imread(sprintf('./TFG2/data/eyes/%s/001_alpha_l.png', style_ex)));
    alpha_r = im2double(imread(sprintf('./TFG2/data/eyes/%s/001_alpha_r.png', style_ex)));
    fg_l = im2double(imread(sprintf('./TFG2/data/eyes/%s/001_fg_l.png', style_ex)));
    fg_r = im2double(imread(sprintf('./TFG2/data/eyes/%s/001_fg_r.png', style_ex)));

    % VISUALIZAR OJOS
    % figure(9);
    % subplot(1,4,1); imshow(alpha_l); title('alpha_l');
    % subplot(1,4,2); imshow(alpha_r); title('alpha_r')
    % subplot(1,4,3); imshow(fg_l); title('fg_l');
    % subplot(1,4,4); imshow(fg_r); title('fg_r') 

    model = csvread(sprintf('./TFG2/data/%s/landmarks/%s.lm', style_in, im_in_name));
    leye_center = round(mean(model(37:42, :),1));
    reye_center = round(mean(model(43:48, :),1));

    half_width= 75;
    half_height = 50;

    leye_raw=im_in(leye_center(2)-half_height : leye_center(2) + half_height,...
                     leye_center(1)-half_width  : leye_center(1) + half_width,:);
    reye_raw=im_in(reye_center(2)-half_height : reye_center(2) + half_height,...
                     reye_center(1)-half_width  : reye_center(1) + half_width,:);
    leye = out(leye_center(2)-half_height : leye_center(2) + half_height,...
                     leye_center(1)-half_width  : leye_center(1) + half_width,:);
    reye = out(reye_center(2)-half_height : reye_center(2) + half_height,...
                     reye_center(1)-half_width  : reye_center(1) + half_width,:);
    leye_new = eye_transfer(leye, leye_raw, alpha_l, fg_l);
    reye_new = eye_transfer(reye, reye_raw, alpha_r, fg_r);
    out(leye_center(2)-half_height : leye_center(2) + half_height,...
                     leye_center(1)-half_width  : leye_center(1) + half_width,:)=leye_new;
    out(reye_center(2)-half_height : reye_center(2) + half_height,...
                     reye_center(1)-half_width  : reye_center(1) + half_width,:)=reye_new;

    figure(9);
    subplot(1,3,1); imshow(input); title('input');
    subplot(1,3,2); imshow(match); title('match');
    subplot(1,3,3); imshow(out); title('out')
end



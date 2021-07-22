close all
clear
clc
addpath('./grabcut');
GAMMA = 20;
% Inputs and parameters
style_in = 'flickr2';
im_in_name = '2187287549_74951db8c2_o';
format1 = 'png';
input = im2double(imread(sprintf('./TFG2/data/%s/imgs/%s.%s', style_in, im_in_name,format1)));
mask = im2double(imread(sprintf('./TFG2/data/%s/fgs/%s.png', style_in, im_in_name)));
% GrabCut
out = grabcut(input, GAMMA);

figure()
subplot(1,2,1);imshow(out);title('mask out');
subplot(1,2,2);imshow(mask);title('mask ref');
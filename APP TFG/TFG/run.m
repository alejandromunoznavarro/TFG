close all
clear
clc


% PORTRAIT
% style_in = 'flickr2';
% style_ex = 'martin';
% im_in_name = '2187287549_74951db8c2_o';
% im_ex_name = 's1';
% format1 = 'png';
% format2 = 'png';
% portrait = true;

% PAISAJE1
% im_in_name = 'rock_input';
% im_ex_name = 'rock_model';
% format1 = 'png';
% format2 = 'png';
% portrait = false;
% color_transfer = false;

% PAISAJE2
im_in_name = 'sepia_input';
im_ex_name = 'sepia_model';
format1 = 'jpg';
format2 = 'jpg';
portrait = 0;
color_transfer = 1;

if portrait
    out = app2(style_in,style_ex,im_in_name,im_ex_name,format1,format2);
else
    out = app(im_in_name,im_ex_name,format1, format2,color_transfer);
end

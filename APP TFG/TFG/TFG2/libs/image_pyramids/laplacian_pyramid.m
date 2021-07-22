function pyramids = laplacian_pyramid(input, nLevel, down_sample, mask)


pyramids={};

pyramids{1}=input;
for i = 2 : nLevel
  sigma=2^(i);
  kernel=fspecial('gaussian', sigma*5, sigma); 
  pyramids{i} = imfilter_m(input, kernel, mask);
end

for i = 1 : nLevel-1
  pyramids{i} = (pyramids{i}-pyramids{i+1}).*mask;
end

pyramids{nLevel} = pyramids{nLevel}.*mask;

% figure(6)
% for k = 1:size(pyramids,2)
%     subplot(3,3,k);imagesc(pyramids{k});colormap('gray');
% end


function output=imfilter_m(input, kernel, mask)
  z=imfilter(mask, kernel, 'symmetric');
  output=imfilter(input.*mask, kernel, 'symmetric');
  output=output./z;
  %keyboard;
  %z(z<1)=1;

  %output = imfilter(input, kernel, 'symmetric');



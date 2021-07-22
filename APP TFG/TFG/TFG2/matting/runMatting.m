function alpha = runMatting(I,mI)
  thr_alpha=[];
  epsilon=[];
  win_size=[];
  levels_num=1;
  active_levels_num=1;

    consts_map=sum(abs(I-mI),3)>0.001;
    if (size(I,3)==3)
      consts_vals=rgb2gray(mI).*consts_map;
    end
    if (size(I,3)==1)
      consts_vals=mI.*consts_map;
    end

    alpha=solveAlphaC2F(I,consts_map,consts_vals,levels_num, ...
                        active_levels_num,thr_alpha,epsilon,win_size);

    %alpha(alpha<0.5)=0; alpha(alpha>=0.5)=1;
    alpha=2*atan(30*(alpha-0.5))/pi;

    figure, imshow(alpha);
    drawnow;
    [F,B]=solveFB(I,alpha);

%     figure, imshow([F.*repmat(alpha,[1,1,3]),B.*repmat(1-alpha,[1,1,3])])
end
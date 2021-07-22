function result = color_transfer(input,model)
    rgbalms = [0.3811 0.5783 0.0402; 0.1967 0.7244 0.0782; 0.0241 0.1288 0.8444];
    lmsalab = [1/sqrt(3) 0 0;0 1/sqrt(6) 0;0 0 1/sqrt(2)]*[1 1 1;1 1 -2;1 -1 0];
    lmsargb = [4.4679 -3.5873 0.1193;-1.2186 2.3809 -0.1624;0.0497 -0.2439 1.2045];
    labalms = [sqrt(3)/3 0 0;0 sqrt(6)/6 0;0 0 sqrt(2)/2];
    
    img_s = reshape(input,[],3);
    img_t = reshape(model,[],3);
    img_s = max(img_s,1/255);
    img_t = max(img_t,1/255);
    LMS_i = rgbalms*img_s';
    LMS_m = rgbalms*img_t';
    
    LMS_i = log10(LMS_i);
    LMS_m = log10(LMS_m);
    
    LAB_i = lmsalab.*LMS_i;
    LAB_m = lmsalab.*LMS_m;
    
    media_i = mean2(LAB_i);
    media_m = mean2(LAB_m);
    
    std_i = std2(LAB_i);
    std_m = std2(LAB_m);
    
    LAB_i = (LAB_i-media_i).*(std_m./std_i)+media_m;
    result = lmsargb.*labalms.*LAB_i;
    
end
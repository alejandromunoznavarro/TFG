function L = laplaciana(I,Mask,n)
    L = {};
    for l = 0:n
        if l == 0
            L{l+1} = I - gauss(I,Mask,2).*Mask;
        else
            L{l+1} = gauss(I,Mask,2^l) - gauss(I,Mask,2^(l+1)).*Mask;
        end
    end
    
%     Según el código original
%     L = {};
%     L{1} = I;
%     for i=2:n+1
%         sigma=2^(i+1);
%         L{i} = gauss(I,Mask,sigma);
%     end
%     for i = 1 : n
%       L{i} = (L{i}-L{i+1}).*Mask;
%     end
%     L{n+1} = L{n+1}.*Mask;
end
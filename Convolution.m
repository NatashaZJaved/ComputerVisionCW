function [Ihat] = Convolution(I,f)
% Computes the Convolution I*f
[n,m] = size(I); [a,b] = size(f);

f = rot90(f,2);
%I = im2double(I);
I_pad = padarray(I,[a-1; b-1]);
Ihat = zeros(size(I_pad,1) - (a - 1), size(I_pad,2) - (b - 1));
% Slide the flipped filter window over the image
% to compute weighted sum
for x = 1:size(Ihat,1)
    for y = 1:size(Ihat,2)
        Ihat(x,y) = sum(sum(f.*(I_pad(x:x+a-1,y:y+b-1))));
    end
end

% Truncate
Ihat = im2uint8(Ihat(a:a + size(I,1)-1,b:b + size(I,2)-1));

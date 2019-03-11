function [Lowes] = LowesPyramid(Im,sigma_0,s,k)
% Computes Lowe pyramid of the Image Im 
% for s different blur scales
% k subsamples

BlurredImages = cell(s+3,k);
Lowes = cell(s+2,k);

curr_im = Im;
for i = 1:k
    Blurs = 1;
    while Blurs <= s+3
        sigma = sigma_0*2^(Blurs/s);
        G = GaussianBlurMatrix(2,sigma);
        BlurredImages{Blurs,i} = conv_colours(curr_im,G);
        Blurs = Blurs + 1;
    end
    curr_im = BlurredImages{Blurs - 3,i};
    %Do subsampling
    curr_im = curr_im(1:2:size(curr_im,1), 1:2:size(curr_im,2),:);
end

% DoG Time
for i=1:k
    for Blurs = 1:s+2
        Lowes{Blurs,i} = BlurredImages{Blurs+1,i} - BlurredImages{Blurs,i};
    end
end


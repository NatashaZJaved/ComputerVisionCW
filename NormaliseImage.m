function imn = NormaliseImage(im)
%takes an input	array im and
%returns a normalised output imn

mx = max(im(:));
mn = min(im(:));

imn = (im - mn)./(mx - mn);

end


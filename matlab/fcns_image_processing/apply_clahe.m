function [ out_img ] = apply_clahe( clahe, img )
% Warping function for CLAHE

if size(img ,3) == 1
    if strcmp(clahe.distribution, 'uniform')
        out_img = adapthisteq(img, 'ClipLimit', clahe.clip_limit, 'Range', clahe.range, 'Distribution', clahe.distribution);
    else
        out_img = adapthisteq(img, 'ClipLimit', clahe.clip_limit, 'Range', clahe.range, 'Distribution', clahe.distribution, 'Alpha', clahe.alpha);
    end
else
    out_img = zeros(size(img));
    for c = 1:3
        if strcmp(clahe.distribution, 'uniform')
            out_img(:,:,c) = adapthisteq(img(:,:,c), 'ClipLimit', clahe.clip_limit, 'Range', clahe.range, 'Distribution', clahe.distribution);
        else
            out_img(:,:,c) = adapthisteq(img(:,:,c), 'ClipLimit', clahe.clip_limit, 'Range', clahe.range, 'Distribution', clahe.distribution, 'Alpha', clahe.alpha);
        end 
    end

end

end


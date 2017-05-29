function [ enhanced_img ] = apply_simple_enhancement( cfg, test_img )
% Warping function for simple model based enhancement
% Works for both color and gray images


% parameters for detail enhancement
smooth_small = cfg.guided.smooth;
smooth_large = cfg.guided.smooth * 10;
size_small = cfg.guided.neighbor;
size_large = cfg.guided.neighbor;
alpha = 5;

% parameters for contrast enhancement
clip_limit = cfg.clahe.clip_limit;
num_tiles = 8;
distribution = cfg.clahe.distribution;

if size(test_img,3) == 1 % gray images
    guided_small = imguidedfilter(test_img, 'NeighborhoodSize', size_small, 'DegreeOfSmoothing', smooth_small);
    guided_large = imguidedfilter(test_img, 'NeighborhoodSize', size_large, 'DegreeOfSmoothing', smooth_large);
    
    residual_img = guided_small - guided_large;
    
    detail_img = guided_small + alpha * residual_img;
    
    enhanced_img = adapthisteq(detail_img, 'ClipLimit', clip_limit, 'Range', 'full', 'Distribution', distribution, ...
                   'NumTiles', [num_tiles, num_tiles]);
elseif size(test_img,3) == 3 % color images

    detail_img = zeros(size(test_img));
    enhanced_img = zeros(size(test_img));
    for c = 1:3

        img = test_img(:,:,c);

        guided_small = imguidedfilter(img, 'NeighborhoodSize', size_small, 'DegreeOfSmoothing', smooth_small);
        guided_large = imguidedfilter(img, 'NeighborhoodSize', size_large, 'DegreeOfSmoothing', smooth_large);

        residual_img = guided_small - guided_large;

        detail_img(:,:,c) = guided_small + alpha*residual_img;
        enhanced_img(:,:,c) = adapthisteq(detail_img(:,:,c), 'ClipLimit', clip_limit, 'Range', 'full', 'Distribution', distribution, ...
                                           'NumTiles', [num_tiles, num_tiles]);
    end
 
end

end


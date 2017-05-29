function [ enhanced_img ] = apply_image_enhancement( cfg, test_img, depth )
% Function for parsing the configuration (selection of the method)

if strcmp(cfg.mode, 'full')
    if (nargin < 3)
        warning('No depth data prepared, use sample depth');
        depth = imread('data/sample_depth/depth.png');
        depth = im2double(depth);
    end
    enhanced_img = apply_full_enhancement(cfg, test_img, depth);
    
elseif strcmp(cfg.mode, 'simple')
    enhanced_img = apply_simple_enhancement(cfg, test_img);
   
else 
    warning('Unvalid enhancement mode');
end



end


function [ enhanced_img ] = apply_full_enhancement( cfg, test_img, depth )
% Warping function for full model based enhancement
% Works for both color and gray images

    if strcmp(cfg.color, 'color')
        if size(test_img, 3) == 1
            warning('Input image is gray-scale, cannot apply color enhancement');
        else
            guided_img = apply_guided(cfg.guided, test_img);
    
            plane_induced_img = apply_plane_induced_dehazing(cfg.plane_induced, guided_img, depth);
    
            deconv_img = apply_psf_deconv(cfg.psf_deconv, plane_induced_img);
    
            enhanced_img = apply_clahe(cfg.clahe, deconv_img);
        end
        
    elseif strcmp(cfg.color, 'gray')
        if size(test_img, 3) == 3
            warning('Input image is color image, convert to gray image');
            test_img = rgb2gray(test_img);
        end
       
        guided_img = apply_guided(cfg.guided, test_img);

        plane_induced_img = apply_plane_induced_dehazing(cfg.plane_induced, guided_img, depth);
    
        deconv_img = apply_psf_deconv(cfg.psf_deconv, plane_induced_img);
    
        enhanced_img = apply_clahe(cfg.clahe, deconv_img);
    end



end


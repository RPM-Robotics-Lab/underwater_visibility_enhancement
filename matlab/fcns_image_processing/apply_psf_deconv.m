function [ out_img ] = apply_psf_deconv( psf_deconv, img )
% Warping function for PSF (Point Spread Function) Deconvolution

PSF = fcn_psf_estim(psf_deconv);

out_img = zeros(size(img));
for c = 1:size(img,3)
    tmp_img = deconvwnr(img(:,:,c), PSF, 1);
    out_img(:,:,c) = tmp_img;
end

end

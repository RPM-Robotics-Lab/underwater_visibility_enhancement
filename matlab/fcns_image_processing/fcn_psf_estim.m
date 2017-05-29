function [ PSF ] = fcn_psf_estim(psf_deconv)

T = psf_deconv.adaptive.T;
q = psf_deconv.adaptive.q;
filter_size = psf_deconv.adaptive.filter_size;
p = sqrt(T);
sigma = 0.5/sqrt(q);
a_term = sigma * sqrt((gamma(1/p)/gamma(3/p)));

center_uv = (filter_size+1)/2;

[u_mesh, v_mesh] = meshgrid([1:1:filter_size], [1:1:filter_size]);
sq_dist = (u_mesh-center_uv).*(u_mesh-center_uv) + (v_mesh-center_uv).*(v_mesh-center_uv);
PSF = (real(exp(-(sq_dist./a_term))^(0.5.*p)) / (2*gamma(1 + 1./p) .* a_term));

PSF = PSF./sum(PSF(:));
end
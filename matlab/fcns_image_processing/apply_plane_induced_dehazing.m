function [ out_img ] = apply_plane_induced_dehazing( plane_induced, img, depth )
% Plane induced dehazing with plane fitting and light source estimation

%% Plane fitting
img_size = [size(img,1), size(img,2)];

if size(depth,1)*size(depth,2) == size(img,1)*size(img,2)
    depth_map = depth;
    X_image = depth_map(:);
else
    [X_image, depth_map, plane_normal] = fcn_plane_fitting(depth, plane_induced.K, img);
end


%% Dehazing 
beta = plane_induced.beta;
Aopt = plane_induced.Aopt;

% transmission
t = exp(-(beta)*depth_map);

% veiling light estimation
if strcmp(Aopt.method, 'constant')
    A = ones(img_size)*Aopt.constant;
elseif strcmp(Aopt.method, 'adaptive')
    Aopt.X_image = X_image;
    Aopt.plane_normal = plane_normal;
    Aopt.depth_map = depth_map;
    Aopt.beta = beta;
    A = fcn_light_estim(Aopt, img);
    figure; imagesc(A);
else
    disp ('[Warning] Unvalid plane_induced.Aopt.method option');
end

out_img = zeros(size(img));
for c = 1:size(img,3)
    tmp_img = (img(:,:,c)-(1-t).*A)./t; 
    out_img(:,:,c) = tmp_img;
end

end


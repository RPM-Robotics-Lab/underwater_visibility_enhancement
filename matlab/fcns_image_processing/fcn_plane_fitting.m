function [ X_image, depth_map, plane_normal ] = fcn_plane_fitting(depth_points, K, img)
% function for plane fitting 

depth_points = depth_points';
affine_depth = [depth_points, ones(size(depth_points,1),1)];
[U, S, V] = svd(affine_depth);
plane_param = V(:,4);
plane_param = plane_param / norm(plane_param);
plane_normal = plane_param(1:3);
plane_center = mean(depth_points, 1);

[U_img, V_img] = meshgrid([1:size(img,2)], [1:size(img,1)]);
U_arr = U_img(:); 
V_arr = V_img(:);
S_arr = ones(size(U_arr));

invK = inv(K);
X_k = invK*[U_arr'; V_arr'; S_arr'];
denom = plane_normal'*X_k;
d = -plane_normal'*plane_center';
S_final = -d./denom;
S_temp = [S_final; S_final; S_final];
X_image = S_temp.*X_k;

X_dist = X_image(3,:);
depth_map = reshape(X_dist', [size(img,1), size(img,2)]);

end
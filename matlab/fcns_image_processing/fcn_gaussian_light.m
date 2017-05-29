function [ gaussian_weight_mat ] = gaussian_weight( img_size, sigma, light_loc)
%GAUSSIAN_WEIGHT Summary of this function goes here
%   Detailed explanation goes here

    h = fspecial('gaussian',img_size*2, sigma);
    [max_val, ind] = max(h(:));
    h = h * 1/max_val; 
    [ind_row, ind_col] = ind2sub(size(h), ind);
    
    row_max = ind_row+img_size(1)-light_loc(1)-1;
    row_min = ind_row-light_loc(1);
    col_max = ind_col+img_size(2)-light_loc(2)-1;
    col_min = ind_col-light_loc(2);
    
    
    gaussian_weight_mat = h(row_min:row_max, col_min:col_max);
    
% %     figure(3);
%     [X, Y] = meshgrid(1:img_size(2), 1:img_size(1));
%     mesh(X, Y, gaussian_weight_mat);
%     axis([0 640 0 480 0 1]); axis equal;
%     xlabel('x'); ylabel('y'); zlabel('weight');
% %     view(30, -40);
%     view(90, -90);
end


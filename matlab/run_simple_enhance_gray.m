clear; close all;

addpath(genpath('evalutaion'));
addpath(genpath('/home/yg/svn/irap/irp-matlab'));
addpath(genpath('download/guided_filter/fast_guided'));
addpath(genpath('fcns_image_processing'));
addpath(genpath('fcns_optimize'));

% load image
if (isunix)
    file_path = 'data/indoor/';
    img = im2double(imread('data/indoor/3m_ori.png'));
else
    file_path = 'data\indoor\';
    img = im2double(imread('data\indoor\3m_ori.png'));
end

% if color convert image to gray
if (size(img,3) == 3)
    img = rgb2gray(img);
end

smooth_small = 1e-4;
smooth_large = 1e-3;
size_small = 16;
size_large = 16;
scale = 4;

alpha = 5;

%% by fast guided
tic;
detail_enhanced = zeros(size(img));
for c = 1:size(img, 3)
    i
    in_img = img(:,:,c);

    guided_small = fastguidedfilter(in_img, in_img, size_small, smooth_small, scale);
    guided_large = fastguidedfilter(in_img, in_img, size_large, smooth_large, scale);

    residual_img = guided_small - guided_large;
    
    detail_enhanced(:,:,c) = guided_small + alpha*residual_img;
%     out_img(:,:,c) = adapthisteq(out_img(:,:,c), 'ClipLimit', 0.0075, 'Range', 'full', 'Distribution', 'uniform', 'NumTiles', [8, 8]);
end


contrast_enhanced = adapthisteq(detail_enhanced, 'ClipLimit', 0.01, 'Range', 'full', 'Distribution', 'uniform', ...
                   'NumTiles', [8, 8]);
toc;

%% by regular guided
% tic;
% scale_img{1} = img;
% for i = 1:scale
%     if (on_size)
% %         scale_img{i+1} = imguidedfilter(img, 'NeighborhoodSize', scale_val(i), 'DegreeOfSmoothing', smooth_val);
%         scale_img{i+1} = guidedfilter(img, img, scale_val(i), smooth_val);
% %         scale_img{i+1} = fastguidedfilter(img, img, scale_val(i), smooth_val, 3);
%     elseif (on_smooth)
% %         scale_img{i+1} = imguidedfilter(img, 'NeighborhoodSize', size_val, 'DegreeOfSmoothing', scale_val(i));
%         scale_img{i+1} = guidedfilter(img, img, size_val, scale_val(i));
% %         scale_img{i+1} = fastguidedfilter(img, img, size_val, scale_val(i), 3);
%     end
%     residual_img{i} = scale_img{i} - scale_img{i+1};
% end
% 
% multiscale_img_regular = fcn_mapping(scale_img{4}, type, scale_mapping{3}(1), scale_mapping{3}(2), on);
% for i = 1:scale
%     multiscale_img_regular = multiscale_img_regular + 5*fcn_mapping(residual_img{i}, type, scale_mapping{i}(1), scale_mapping{i}(2), on);
% end
% 
% out_img_resular = adapthisteq(multiscale_img_regular, 'ClipLimit', 0.01, 'Range', 'full', 'Distribution', 'uniform', ...
%                    'NumTiles', [8, 8]);
% toc;
           
%% plot
               
% figure(1);
% for i = 1:scale
%     colormap('copper');
%     subplot(1, scale, i);
%     imagesc(residual_img{i}); colorbar; axis off;
% end

figure;
imshow([img detail_enhanced contrast_enhanced]);

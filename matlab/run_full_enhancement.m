%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Image enhancement by Full model
%%%%%%%%%%%%%

clear; close all;
config;

%% setup for ICL NUIM
% alpha = 0;
% beta = 0.8;
% dive2.img1_name = num2str(dive2_match_list(2,1));
% dive2.img2_name = num2str(dive2_match_list(2,2));
% true_img =im2double(imread(['data/icl-nuim/color1' '.jpg']));
% haze_img = im2double(imread(['data/icl-nuim/haze_00001_01' '.png']));
% range_map = imread('data/icl-nuim/00804.png');
% range_map = double(range_map)/1000;
% 
% img = apply_guided(cfg.guided, haze_img);
% t = exp(-(alpha+beta)*range_map);
% img_size = size(haze_img);
% img_size = img_size(1:2);
% 
% % A = ones(size(haze_img))*0.5;
% % A2 = A; 
% 
% A = gaussian_weight(img_size, 400, [400 600]);
% % A = 0.05 + (0.95-0.05)*A;
% A = repmat(A,[1,1, size(img,3)]);
% % A = imguidedfilter(img, 'NeighborhoodSize', 50, 'DegreeOfSmoothing', guided.smooth);
% 
% A2 = A;
% % A = imopen(haze_img,strel('disk',200));
% 
% final_img = zeros(size(haze_img));
% out_img = zeros(img_size);

%% setup for ACFR
alpha = 0;
beta = 0.5;
haze_img = im2double(imread(['data/acfr/acfr' '.png']));
range_map = im2double(imread('data/sample_depth/depth.png'));
% range_map = double(range_map)/1000;

img = apply_guided(cfg.guided, haze_img);
t = exp(-(alpha+beta)*range_map);
img_size = size(haze_img);
img_size = img_size(1:2);

% A = ones(size(haze_img))*0.5;
% A2 = A; 

A = gaussian_weight(img_size, 400, [400 600]);
% A = 0.05 + (0.95-0.05)*A;
A = repmat(A,[1,1, size(img,3)]);
% A = imguidedfilter(img, 'NeighborhoodSize', 50, 'DegreeOfSmoothing', guided.smooth);

A2 = A;
% A = imopen(haze_img,strel('disk',200));

final_img = zeros(size(haze_img));
out_img = zeros(img_size);

%% Setup for Indoor
% alpha = 0;
% beta = 0.65;
% haze_img = im2double(imread(['data/indoor/3m_ori' '.png']));
% range_map = im2double(imread('data/sample_depth/depth.png'));
% % range_map = double(range_map)/1000;
% range_map = imresize(range_map, [size(haze_img,1), size(haze_img,2)]);
% img = apply_guided(cfg.guided, haze_img);
% t = exp(-(alpha+beta)*range_map);
% img_size = size(haze_img);
% img_size = img_size(1:2);
% 
% % A = ones(size(haze_img))*0.5;
% % A2 = A; 
% 
% A = gaussian_weight(img_size, 1000, [150 300])*0.6;
% % A = 0.05 + (0.95-0.05)*A;
% A = repmat(A,[1,1, size(img,3)]);
% % A = imguidedfilter(img, 'NeighborhoodSize', 50, 'DegreeOfSmoothing', guided.smooth);
% 
% A2 = A;
% % A = imopen(haze_img,strel('disk',200));
% 
% final_img = zeros(size(haze_img));
% out_img = zeros(img_size);

%% Main loop

for c = 1:size(haze_img,3)
%         dehaze1(:,:,c) = min((img1(:,:,c) - A1(:,:,c))./(max(t1, 0.001)) + A1(:,:,c), 1);
%         dehaze2(:,:,c) = min((img2(:,:,c) - A2(:,:,c))./(max(t2, 0.001)) + A2(:,:,c), 1);
    out_img = min((haze_img(:,:,c) - (beta/(alpha+beta))*A(:,:,c))./(max(t, 0.001)) + A2(:,:,c)*(beta/(alpha+beta)), 1);
%     out_img = apply_high_freq(high_freq, out_img);
    tic;
    our_img = apply_psf_deconv(cfg.psf_deconv, out_img);
    toc;
%     tic;
%     out_img = apply_clahe(cfg.clahe, out_img);
%     toc;
    final_img(:,:,c) = out_img;
end

out_lab = rgb2lab(final_img);
out_l = out_lab(:,:,1) / 100;
out_lab(:,:,1) = adapthisteq(out_l, 'ClipLimit', 0.0075, 'Range', 'full', 'Distribution', 'rayleigh', ...
                   'NumTiles', [15, 15]) * 100;
final_img = lab2rgb(out_lab);


figure; imshow([haze_img, final_img]);
haze_img = im2uint8(haze_img);
final_img = im2uint8(final_img);

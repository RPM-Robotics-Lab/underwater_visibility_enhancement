clear; close all;

%% Configuration and Load data
% config;
load('data/acfr/cfg_acfr.mat');
load('data/acfr/X_c.mat');
depth = X_c;

test_img = im2double((imread('data/acfr/acfr.png')));

%% Apply Image Enhancement (color)
tic;
enhanced_img = apply_image_enhancement(cfg, test_img, depth);
toc;

%% Apply Image Enhancement (gray)
% cfg.color = 'gray';
% tic;
% enhanced_img = apply_image_enhancement(cfg, test_img, depth);
% toc;

%% Show results
if size(enhanced_img,3) == 1 && size(test_img,3) == 3
    test_img = rgb2gray(test_img);
end
figure; imshow([test_img enhanced_img]);



if isunix
    data_path = '/var/data/hauv/';
%     data_path = 'data/';
    addpath(genpath(fileparts(which('mexOpenCV.m'))));
else
    data_path = 'D:\Dataset\hauv\terryb-2011\2011-06-21\';
end

addpath(genpath('fcns_image_processing'));
addpath(genpath('fcns_feature_descriptor'));

addpath(genpath('../matlab/utils'));
addpath(genpath('data'));

%% g - guided filtering
guided.neighbor = 3;
guided.smooth = 1e-2;

%% c - clahe (clip limit adaptive histogram equalization)
clahe.clip_limit = 0.02;
clahe.range = 'full'; % full, original
clahe.distribution = 'rayleigh'; % uniform, 'rayleigh', exponential
clahe.alpha = 0.5;

%% d - deblur
deblur.tmp = 1;

%% i - igp dehazing
igp_dehaze.depth_data = 'data/ref_depth2.mat'; % if not, then '';
igp_dehaze.beta = 0.7;
igp_dehaze.alpha = 0;
igp_dehaze.Aopt.constant = 0;
igp_dehaze.Aopt.gaussian = [700, 680, 1201]; % [variance, [mean_location(row, col)]], if not '';
igp_dehaze.Aopt.gaussian_mag = 0.8;

%% t - tarel dehazing
tarel_dehaze.smax = 0.5;
tarel_dehaze.balance = 0.5;

%% h - high freq
high_freq.filter_size = 5;
high_freq.alpha = 1;

%% p - psf deconv
psf_deconv.method = 'adaptive'; % 'gaussian', 'adaptive'
psf_deconv.gaussian.PSF = fspecial('gaussian', 20,3.5);
psf_deconv.adaptive.T = 1.5;
psf_deconv.adaptive.use_adapt_T = 0;
psf_deconv.adaptive.q = 0.9;
psf_deconv.adaptive.filter_size = 5;
psf_deconv.num_iter = 20; 
psf_deconv.weight_flag = 0;

%% u - uniform illumination
uniform_illumination.size = 200;
uniform_illumination.show_background = 1;

%% l - plane induced dehazing
plane_induced.beta = 0.3;
plane_induced.alpha = 0;
plane_induced.Aopt.method = 'adaptive'; % 'constant', 'gaussian', 'adaptive'
plane_induced.Aopt.constant = 0.7;
plane_induced.Aopt.gaussian.var = [600, 680, 1200]; % [variance, [mean_location(row, col)]], if not '';
plane_induced.Aopt.gaussian.mag = 1;
plane_induced.Aopt.gaussian.minmax = [0.01, 0.8];
plane_induced.Aopt.adaptive.adaptive_light = 1;
plane_induced.plot = 1;

if (isunix)
    root_dir = '/var/data/hauv/dive02/';
    addpath(genpath('utils'));
    addpath(genpath(root_dir));

    plane_induced.root_dir = root_dir;
    plane_induced.img_dir = [root_dir 'PROSILICA_M/'];
    plane_induced.nav_dir = [root_dir 'nav/'];
%     plane_induced.calib = initializeCalib('../matlab/utils/van-ak/hauv/calib_hauv.m');
else
    root_dir = 'D:\Dataset\hauv\terryb-2011\2011-06-21\dive02\';
    addpath(genpath('utils'));
    addpath(genpath(root_dir));

    plane_induced.root_dir = root_dir;
    plane_induced.img_dir = [root_dir 'PROSILICA_M\'];
    plane_induced.nav_dir = [root_dir 'nav\'];
    plane_induced.calib = initializeCalib('..\matlab\utils\van-ak\hauv\calib_hauv.m');
end


%% feature
% detector: sift, orb, fast, surf
% descriptor: sift, orb, surf, dasc

feature.auto = 1;
feature.detector = 'sift';
feature.descriptor = 'sift';

%% set configuration
cfg.order = 'glpc';
cfg.save_img = 1;
cfg.show_img = 1;
cfg.current_date = datestr(clock, 'yyyy-mm-dd_HH-MM-SS');
cfg.guided = guided;
cfg.high_freq = high_freq;
cfg.clahe = clahe;
cfg.deblur = deblur;
cfg.igp_dehaze = igp_dehaze;
cfg.tarel_dehaze = tarel_dehaze;
cfg.psf_deconv = psf_deconv;
cfg.uniform_illumination = uniform_illumination;
cfg.plane_induced = plane_induced;
cfg.feature = feature;
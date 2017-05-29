%% Add explanation of the config
addpath(genpath('fcns_image_processing'));
addpath(genpath('fcns_evaluation'));
addpath(genpath('data'));

%% Image Enhancement mode
cfg.mode = 'full'; % mode = full, simple
cfg.color = 'color'; % color = gray, color

%% g - guided filtering
cfg.guided.neighbor = 4;
cfg.guided.smooth = 1e-4;

%% c - clahe (contrast limit adaptive histogram equalization)
cfg.clahe.clip_limit = 0.01;
cfg.clahe.range = 'full'; % full, original
cfg.clahe.distribution = 'uniform'; % 'uniform', 'rayleigh'

%% p - psf deconv
cfg.psf_deconv.method = 'adaptive';
cfg.psf_deconv.adaptive.T = 1.5;
cfg.psf_deconv.adaptive.q = 0.9;
cfg.psf_deconv.adaptive.filter_size = 5;

%% l - plane induced dehazing
load('data/acfr/K.mat');
cfg.plane_induced.K = K;
cfg.plane_induced.beta = 0.3;
cfg.plane_induced.Aopt.method = 'adaptive'; % 'constant', 'adaptive'
cfg.plane_induced.Aopt.constant = 0.7;
cfg.plane_induced.Aopt.led_pos = [0.5, -0.1, 0]';
cfg.plane_induced.Aopt.led_normal = [-1, 0, 1]';
cfg.plane_induced.Aopt.adaptive.adaptive_light = 1;
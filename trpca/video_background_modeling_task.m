addpath(genpath(cd))
clear
close all

SOURCE_DIR = './data/rgb_videos/';
TARGET_DIR = './data/rgb_videos_background_modeling_vis/';

opts.mu = 1e-4;
opts.tol = 1e-5;
opts.rho = 1.1;
opts.max_iter = 500;
opts.DEBUG = 1;

videos = dir(fullfile(SOURCE_DIR,'*.mp4'));
videos_len = length(videos);
converged_all_time = 0;
for idx=1:videos_len
    filename = videos(idx).name;
    [converged_time] = background_modeling(filename,SOURCE_DIR,TARGET_DIR,opts);
    converged_all_time = converged_all_time + converged_time;
end
disp("For all modeling videos: average converged time is "+num2str(converged_all_time/imgs_len))
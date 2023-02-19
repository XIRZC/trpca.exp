addpath(genpath(cd))
clear
close all

SOURCE_DIR = './data/rgb_videos/';
VIDEO_TYPE = '.avi';
TARGET_DIR = './data/rgb_videos_background_modeling_vis/';

opts.mu = 1e-4;
opts.tol = 1e-5;
opts.rho = 1.1;
opts.max_iter = 500;
opts.DEBUG = 1;
FRAME_SPAN = 15;

videos = dir(fullfile(SOURCE_DIR,strcat('*',VIDEO_TYPE)));
videos_len = length(videos);
converged_all_time = 0;
for idx=1:videos_len
    filename = videos(idx).name;
    target_dir = strcat(strcat(TARGET_DIR,replace(filename,VIDEO_TYPE,'')),'/');
    [converged_time] = background_modeling(filename,SOURCE_DIR,target_dir,FRAME_SPAN,VIDEO_TYPE,opts);
    converged_all_time = converged_all_time + converged_time;
end
disp("For all modeling videos: average converged time is "+num2str(converged_all_time/videos_len))
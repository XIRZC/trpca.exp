addpath(genpath(cd))
clear
close all

SOURCE_DIR = './data/rgb_images/';
TARGET_DIR = './data/rgb_images_denoising_vis/';
NOISE_PERCENT = 0.5;

opts.mu = 1e-4;
opts.tol = 1e-5;
opts.rho = 1.1;
opts.max_iter = 500;
opts.DEBUG = 1;

imgs = dir(fullfile(SOURCE_DIR,'*.jpg'));
imgs_len = length(imgs);
psnr_all_value = 0;
converged_all_time = 0;
for idx=1:imgs_len
    filename = imgs(idx).name;
    [~, psnr_value, converged_time] = denoising(filename,SOURCE_DIR,TARGET_DIR,NOISE_PERCENT,opts);
    psnr_all_value = psnr_all_value + psnr_value;
    converged_all_time = converged_all_time + converged_time;
end
disp("For all denoised image: average PSNR is "+num2str(psnr_all_value/imgs_len))
disp("For all denoised image: average converged time is "+num2str(converged_all_time/imgs_len))
function [Xhat,psnr_value, converged_time] = denoising(filename, source_dir, target_dir, noise_percent, opts)

%RGB_IMAGE_DENOISING
%   Input: 
%      filename: RGB image filename
%      source_dir: RGB image parent directory
%      target_dir: RGB image denoising process visualize output directory
%      noise_percent: The percentage of noise pixes account for 
%      opts: TRPCA Convex Optimization Parameters Struct
%   Output:
%      Xhat: The Low-Rank Denoised Tensor solved by ADMM with Thresholding
%      Operator for TNN and L1 Norm Minimization
%      psnr: Peak Signal-to-Noise Ratio 

disp('-----------------------------------------------------');
% mkdir if it does not exist
if ~exist(target_dir,'dir') 
    mkdir(target_dir); 
end

% Load the image X and generate the noised image Xn
X = double(imread(strcat(source_dir,filename)));
X = X/255;
[n1,n2,n3] = size(X);
Xn = X;
rhos = noise_percent;
ind = find(rand(n1*n2*n3,1)<rhos);
real_noise_percent = length(ind)/(n1*n2*n3)
Xn(ind) = rand(length(ind),1);

% Optimization by trpca_tnn Algorithm to get Xhat
[n1,n2,n3] = size(Xn);
lambda = 1/sqrt(max(n1,n2)*n3);
disp("Optimizing by trpca_tnn algorithm...")
tic
[Xhat,~,~,~] = trpca_tnn(Xn,lambda,opts);

% Caculate the PSNR value to evaluate recover quality
maxP = max(abs(X(:)));
Xhat = max(Xhat,0);
Xhat = min(Xhat,maxP);
psnr_value = psnr(X,Xhat,maxP);
disp("Converged. PSNR: "+num2str(psnr_value))
converged_time = toc

% X,Xn,Xhat Visualization
figure(1);
subplot(1,3,1);
imshow(X/max(X(:)));
subplot(1,3,2);
imshow(Xn/max(Xn(:)));
subplot(1,3,3);
imshow(Xhat/max(Xhat(:)));
set(gcf, 'Visible', 'off');
saveas(gcf,strcat(target_dir,filename));
disp(strcat("Save denoising visualization into ",strcat(target_dir,filename)));
end
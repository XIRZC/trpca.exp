function [converged_time] = background_modeling(filename, source_dir, target_dir, opts)
%BACKGROUND_MODELING Background modeling for a video by TRPCA, where moving foreground is sparse noise and stationary background is low-rank
%   Input: 
%      filename: RGB video filename
%      source_dir: RGB video parent directory
%      target_dir: RGB video background modeling visualize output directory
%      opts: TRPCA Convex Optimization Parameters Struct
%   Output:
%      converged_time: running time of the optimization process

disp('-----------------------------------------------------');
% mkdir if it does not exist
if ~exist(target_dir,'dir') 
    mkdir(target_dir); 
end

videoObj = VideoReader(strcat(source_dir,filename));
X = double(read(videoObj));
X = X/255;
[n1,n2,n3,n4] = size(X);
X = reshape(X,[n1*n2,n3,n4]);

% Optimization by trpca_tnn Algorithm to get Xhat
[n1,n2,n3] = size(X);
lambda = 1/sqrt(max(n1,n2)*n3);
disp("Optimizing by trpca_tnn algorithm...")
tic
[Lhat,Shat,~,~] = trpca_tnn(X,lambda,opts);
converged_time = toc

% low-rank background L and moving foreground S visualization
figure(1);
subplot(1,2,1);
imshow(Lhat);
subplot(1,2,2);
imshow(Shat);
set(gcf, 'Visible', 'off');
saveas(gcf,strcat(target_dir,replace(filename,'mp4','jpg')));
disp(strcat("Save background modeling visualization into ",strcat(target_dir,replace(filename,'mp4','jpg'))));

end
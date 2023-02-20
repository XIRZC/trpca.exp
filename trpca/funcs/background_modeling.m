function [converged_time] = background_modeling(filename, source_dir, target_dir, frame_span, video_type, opts)
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
X = X(:,:,:,1:frame_span:end);
[n1,n2,n3,n4] = size(X)
X = reshape(X,[n1*n2,n3,n4]);

% Optimization by trpca_tnn Algorithm to get Xhat
lambda = 1/sqrt(max(n1*n2,n3)*n4);
disp("Optimizing by trpca_tnn algorithm...")
tic
[Lhat,Shat,~,~] = trpca_tnn(X,lambda,opts);
converged_time = toc

% low-rank background L and moving foreground S visualization
X = reshape(X,[n1,n2,n3,n4]);
Lhat = reshape(Lhat,[n1,n2,n3,n4]);
Shat = reshape(Shat,[n1,n2,n3,n4]);
for i=1:n4
    figure(1);
    subplot(1,3,1);
    imshow(X(:,:,:,i));
    subplot(1,3,2);
    imshow(Lhat(:,:,:,i));
    subplot(1,3,3);
    Shat_background_gray=min(Shat(:,:,:,i)+0.3,1.0);
    imshow(Shat_background_gray)
    set(gcf, 'Visible', 'off');
    vis_name = strcat(target_dir,replace(filename,video_type,strcat('_frame',strcat(num2str(i),'.jpg'))));
    saveas(gcf,vis_name);
disp(strcat("Save background modeling visualization into ",vis_name));
end
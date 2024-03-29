function [L,S,obj,err,iter] = trpca_tnn(X,lambda,opts)

% Solve the Tensor Robust Principal Component Analysis based on Tensor Nuclear Norm problem by ADMM
%
% min_{L,S} ||L||_*+lambda*||S||_1, s.t. X=L+S
%
% ---------------------------------------------
% Input:
%       X       -    d1*d2*d3 tensor
%       lambda  -    >0, parameter
%       opts    -    Structure value in Matlab. The fields are
%           opts.tol        -   termination tolerance
%           opts.max_iter   -   maximum number of iterations
%           opts.mu         -   stepsize for dual variable updating in ADMM
%           opts.max_mu     -   maximum stepsize
%           opts.rho        -   rho>=1, ratio used to increase mu
%           opts.DEBUG      -   0 or 1
%
% Output:
%       L       -    d1*d2*d3 tensor
%       S       -    d1*d2*d3 tensor
%       obj     -    objective function value
%       err     -    residual 
%       iter    -    number of iterations
%
% version 1.0 - 19/06/2016
%
% Written by Canyi Lu (canyilu@gmail.com)
% 
% References: 
% [1] Canyi Lu, Jiashi Feng, Yudong Chen, Wei Liu, Zhouchen Lin and Shuicheng
%     Yan, Tensor Robust Principal Component Analysis with A New Tensor Nuclear
%     Norm, arXiv preprint arXiv:1804.03728, 2018
% [2] Canyi Lu, Jiashi Feng, Yudong Chen, Wei Liu, Zhouchen Lin and Shuicheng
%     Yan, Tensor Robust Principal Component Analysis: Exact Recovery of Corrupted 
%     Low-Rank Tensors via Convex Optimization, arXiv preprint arXiv:1804.03728, 2018
%

tol = 1e-8; 
max_iter = 500;
rho = 1.1;
mu = 1e-4;
max_mu = 1e10;
DEBUG = 0;

if ~exist('opts', 'var')
    opts = [];
end    
if isfield(opts, 'tol');         tol = opts.tol;              end
if isfield(opts, 'max_iter');    max_iter = opts.max_iter;    end
if isfield(opts, 'rho');         rho = opts.rho;              end
if isfield(opts, 'mu');          mu = opts.mu;                end
if isfield(opts, 'max_mu');      max_mu = opts.max_mu;        end
if isfield(opts, 'DEBUG');       DEBUG = opts.DEBUG;          end

dim = size(X);
L_kp1 = zeros(dim);
S_kp1 = zeros(dim);
Y_kp1 = zeros(dim);
mu_kp1 = mu;

for iter = 1 : max_iter
    % this block is to make the entire optimizing code seems more like
    % algorithm proposed by the original paper
    L_k = L_kp1;
    S_k = S_kp1;
    Y_k = Y_kp1;
    mu_k = mu_kp1;

    % update L_k+1 by S_k, X, Y_k and mu_k
    [L_kp1,tnnL] = prox_tnn(-S_k+X-Y_k/mu_k,1/mu_k);
    % update S_k+1 by L_k+1, X, Y_k, mu_k and lambda
    S_kp1 = prox_l1(-L_kp1+X-Y_k/mu_k,lambda/mu_k);
  
    dY = L_kp1+S_kp1-X;
    chgL = max(abs(L_kp1(:)-L_k(:)));
    chgS = max(abs(S_kp1(:)-S_k(:)));
    chg = max([ chgL chgS max(abs(dY(:))) ]);
    if DEBUG
        if iter == 1 || mod(iter,10) == 0
            obj = tnnL+lambda*norm(S_kp1(:),1);
            err = norm(dY(:));
            disp(['iter ' num2str(iter) ', mu=' num2str(mu) ...
                    ', obj=' num2str(obj) ', err=' num2str(err)]); 
        end
    end
    
    if chg < tol
        break;
    end 
    Y_kp1 = Y_k + mu_k*dY;
    mu_kp1 = min(rho*mu_k,max_mu);    
end
L = L_kp1;
S = S_kp1;
obj = tnnL+lambda*norm(S(:),1);
err = norm(dY(:));

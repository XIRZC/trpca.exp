addpath(genpath(cd))
clear
close all

% Ablation parameters
R_VALUE = 0.1;
P_VALUE = 0.05;
N_VALUE = 30;

% Generate low-rank part:tensor L by L = L1*L2 with r = R_VALUE*n1
n1 = N_VALUE
n2 = n1;
n3 = n1;
r = R_VALUE*n1 % tubal rank
L1 = randn(n1,r,n3)/n1;
L2 = randn(r,n2,n3)/n2;
L = tprod(L1,L2); % low rank part

% Generate sparse part:tensor S by S = P_Omega(E) with m = P_VALUE*n1*n2*n3
p = P_VALUE;
m = p*n1*n2*n3 % sparse counts
temp = rand(n1*n2*n3,1);
[B,I] = sort(temp);
I = I(1:m);
Omega = zeros(n1,n2,n3);
Omega(I) = 1;
E = sign(rand(n1,n2,n3)-0.5);
S = Omega.*E; % sparse part

Xn = L+S;
lambda = 1/sqrt(n3*max(n1,n2));
opts.tol = 1e-8;
opts.mu = 1e-4;
opts.rho = 1.1;
opts.DEBUG = 1;

tic
[Lhat,Shat] = trpca_tnn(Xn,lambda,opts);
trankhat = tubalrank(Lhat)
sparsityhat = length(find(Shat~=0))
Lr = norm(L(:)-Lhat(:))/norm(L(:))
Sr = norm(S(:)-Shat(:))/norm(S(:))
toc
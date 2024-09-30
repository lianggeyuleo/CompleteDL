% This is where the algorithm runs. The final result D is the orthogonal
% dictionary that we aim to find and X_result contains the sparse codes.

function [X_result, D_result] = alg2_new(Y, T)

[n p] = size(Y);

% compute an initialization
% D_init = Y(:,randsample(p,n));
D_init = randn(n);
zeta_ini = 0.01*max(max(abs(D_init' * Y)));
base = 1e-06;

X_temp = zeros(n,p);
zeta = zeta_ini;
D_temp = D_init;


batch_size = 1000;

tic
for i = 1:T
    i

    D_old = D_temp;

    idx = [i:i+batch_size]; % use columns of Y from i to i+batch_size
    Yi = Y(:,idx); 
    
    % compute the Cholesky preconditioner for this iteration using all the
    % observed columns of Y so far
    idx_pre = [1:i+batch_size];
    Ytemp = Y(:,idx_pre);
    [U_d,S_d,V_d] = svd(Ytemp * Ytemp.');
    cr = length(S_d);
    offset = U_d(:,1:cr)*diag(diag(S_d(1:cr,1:cr)).^(-1))*U_d(:,1:cr)';
    offset = chol(offset)';
    
    % apply the preconditioner
    Yi = offset * Yi;
    
    
    DY = D_temp' * Yi;

    X_temp = (abs(DY) > zeta + base).* DY;
    [U1,Sig,U2] = svd(Yi * X_temp');
    D_temp = U1 * U2';
    zeta = zeta * 0.99;

    norm(D_temp-D_old);
    if zeta<1e-14
        break
    end
end
toc

X_result = (abs(D_temp' * Y) > zeta + base).* (D_temp' * Y);
D_result = inv(offset) * D_temp;

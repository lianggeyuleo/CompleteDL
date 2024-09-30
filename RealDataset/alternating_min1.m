% This is where the algorithm runs. The final result D is the orthogonal
% dictionary that we aim to find and X_result contains the sparse codes.

function [X_result, D_result] = alg2_montage(Y, T)

[n p] = size(Y);


% compute an initialization
% D_init = Y(:,randsample(p,n));
D_init = randn(n);
zeta_ini = 0.01*max(max(abs(D_init' * Y)));
base = 1e-06;

X_temp = zeros(n,p);
zeta = zeta_ini;
D_temp = D_init;

% % t_interval = 5;
% % X_array = {}; % create an empty cell array to store X_results at different time
% % D_array = {}; % create an empty cell array to store D_results at different time
% % 

batch_size = 500;
running_time = zeros(T);

tic
for i = 1:T
    i

    D_old = D_temp;

    idx = randsample(p, batch_size); % randomly sample batch_size samples
    DY = D_temp' * Y(:,idx);

    X_temp = (abs(DY) > zeta + base).* DY;
    [U1,Sig,U2] = svd(Y(:,idx) * X_temp');
    D_temp = U1 * U2';
    zeta = zeta * 0.99;

    norm(D_temp-D_old);
    if zeta<1e-14
        break
    end
    
    running_time(i) = toc;

end
toc

X_result = (abs(D_temp' * Y) > zeta + base).* (D_temp' * Y);
D_result = D_temp;

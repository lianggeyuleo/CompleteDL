
function [X_array, D_array, running_time] = ksvd_new(Y,T)

[n p] = size(Y);
D_init = randn(n);

D = D_init;  % learned dictionary

[K ~] = size(D)
tic

X_array = {}; % create an empty cell array to store X_results at different time
D_array = {}; % create an empty cell array to store D_results at different time

time_interval = 5;
running_time = [];

tic
for it = 1:T   
   it
   W = sparseapprox(Y, D, 'mexOMP');
   R = Y - D*W;
   D_old = D;
   
    for k=1:K
        I = find(W(k,:));
        Ri = R(:,I) + D(:,k)*W(k,I);
        [U,S,V] = svds(Ri,1,'L');
        % U is normalized
        D(:,k) = U;
        W(k,I) = S*V';
        R(:,I) = Ri - D(:,k)*W(k,I);
    end    
    
    norm(D-D_old)

    if rem(it, time_interval) == 0
        running_time = [running_time toc];
        X_array = [X_array W];
        D_array = [D_array D];
    end

end


toc


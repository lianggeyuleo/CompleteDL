
function [X_array, D_array,sim_vec, running_time] = ksvd_runtime(Y, T, orig, offset, data,img_idx,k_index)

[n p] = size(Y);
D_init = randn(n);

D = D_init;  % learned dictionary

[K ~] = size(D)
tic


running_time = zeros(T,1);
sim_vec = zeros(T,1);

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


%     dict_dl = inv(offset) * D;
    dict_dl = D;
    out_dl = patch_struct_color(data, W, dict_dl, img_idx, k_index);


    sim_vec(it) = ssim(out_dl,orig);
    running_time(it) = toc;
end


X_array = W;
D_array = D;

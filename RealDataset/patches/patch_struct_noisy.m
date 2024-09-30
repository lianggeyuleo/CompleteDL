% using the learned dictionary X_result, D_result for patches, reconstruct
% the original image
% inputs: im_size is length of image. 

function [out out_noisy] = patch_struct_noisy(data, X_result, dict, img_idx, k_index, missing_rate)

im_size = 150;
[s1 s2] = size(X_result);
patch_size = sqrt(s1/3);
patch_num = im_size / patch_size;

k_ref = length(dict);

patch_start = (img_idx-1) * patch_num^2 + 1;
out1 = zeros(im_size);
out2 = zeros(im_size);
out3 = zeros(im_size);

out1_noisy = zeros(im_size);
out2_noisy = zeros(im_size);
out3_noisy = zeros(im_size);

out = zeros(im_size,im_size,3);
out_noisy = zeros(im_size,im_size,3);

for i = 1 : patch_num^2
    patch_idx = patch_start + i - 1;
    
    % create noisy version of the original image
    I_ori = data(:,patch_idx); 
    temp = rand(length(I_ori),1) > missing_rate;
    I_ori = I_ori .* temp;
    
    nzero = find(I_ori == 0);
    dict_nzero = dict;
    dict_nzero(nzero,:) = 0;
     
    % compress using dictionary learning
    W = sparseapprox(I_ori, dict_nzero, 'mexOMP', 'tnz', k_index);
    I_denoise = dict * W;

    patch_total = patch_size^2;

    temp1 = data(1:patch_total, patch_idx);
    temp2 = data(patch_total+1:2*patch_total, patch_idx);
    temp3 = data(2*patch_total+1:3*patch_total, patch_idx);
    
    Y1 = I_denoise(1:patch_total);
    Y2 = I_denoise(patch_total+1:2*patch_total);
    Y3 = I_denoise(2*patch_total+1:3*patch_total);

    Y1 = Y1/norm(Y1) * norm(temp1);
    Y2 = Y2/norm(Y2) * norm(temp2);
    Y3 = Y3/norm(Y3) * norm(temp3);

    I1 = reshape(Y1,[patch_size, patch_size]);
    I2 = reshape(Y2,[patch_size, patch_size]);
    I3 = reshape(Y3,[patch_size, patch_size]);

    col_num = ceil(i/patch_num);
    row_num = rem(i,patch_num);
    
    if row_num == 0
        row_num = patch_num;
    end

    row_start = (row_num-1)*patch_size + 1;
    col_start = (col_num-1)*patch_size + 1;

    row_end = row_start + patch_size - 1;
    col_end = col_start + patch_size - 1;

    out1(row_start:row_end, col_start:col_end) = I1;
    out2(row_start:row_end, col_start:col_end) = I2;
    out3(row_start:row_end, col_start:col_end) = I3;

    D1 = I_ori(1:1*patch_total);
    D2 = I_ori(patch_total+1:2*patch_total);
    D3 = I_ori(2*patch_total+1:3*patch_total);

    D1 = reshape(D1,[patch_size, patch_size]);
    D2 = reshape(D2,[patch_size, patch_size]);
    D3 = reshape(D3,[patch_size, patch_size]);

    out1_noisy(row_start:row_end, col_start:col_end) = D1;
    out2_noisy(row_start:row_end, col_start:col_end) = D2;
    out3_noisy(row_start:row_end, col_start:col_end) = D3;
    
end

out(:,:,1) = out1;
out(:,:,2) = out2;
out(:,:,3) = out3;

out_noisy(:,:,1) = out1_noisy;
out_noisy(:,:,2) = out2_noisy;
out_noisy(:,:,3) = out3_noisy;






    
   

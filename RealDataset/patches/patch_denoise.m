% using the learned dictionary X_result, D_result for patches, reconstruct
% the original image

function [out_noisy out] = patch_denoise(data_ori, data, dict, img_idx, k_index)

[n p] = size(data_ori);
im_size = sqrt(n);

[temp ~] = size(data);
patch_size = sqrt(temp); 
patch_num = im_size / patch_size;


patch_start = (img_idx-1) * patch_num^2 + 1;
out = zeros(im_size);
out_noisy = zeros(im_size);

missing_rate = 0.5;

for i = 1 : patch_num^2
    patch_idx = patch_start + i - 1;

    % compress using discrete cosine transform
    I_ori_1 = data(:,patch_idx); 


    temp = rand(length(I_ori_1),1) > missing_rate;
    I_ori_1 = I_ori_1 .* temp;

    nzero = find(I_ori_1 == 0);
    dict_nzero = dict;
    dict_nzero(nzero,:) = 0;

    W = sparseapprox(I_ori_1, dict_nzero, 'mexOMP', 'tnz', k_index);
    I = dict * W;
    
    I = reshape(I,[patch_size, patch_size]);
    I_noisy = reshape(I_ori_1,[patch_size, patch_size]);

    col_num = ceil(i/patch_num);
    row_num = rem(i,patch_num);
    
    if row_num == 0
        row_num = patch_num;
    end

    row_start = (row_num-1)*patch_size + 1;
    col_start = (col_num-1)*patch_size + 1;

    row_end = row_start + patch_size - 1;
    col_end = col_start + patch_size - 1;

    out(row_start:row_end, col_start:col_end) = I;
    out_noisy(row_start:row_end, col_start:col_end) = I_noisy;
    
end







    
   

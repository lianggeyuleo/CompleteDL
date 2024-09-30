% using the learned dictionary X_result, D_result for patches, reconstruct
% the original image

function out = patch_struct(data_ori, data, X_result, D_result, dict, img_idx, k_index)

[n p] = size(data_ori);
im_size = sqrt(n);

patch_size = sqrt(length(D_result)); 
patch_num = im_size / patch_size;
k_ref = length(D_result);


patch_start = (img_idx-1) * patch_num^2 + 1;
out = zeros(im_size);


for i = 1 : patch_num^2
    patch_idx = patch_start + i - 1;
 
      % compress using dictionary learning

    [~,idx]=maxk(abs(X_result(:,patch_idx)),k_index);
    [~,iref]=maxk(abs(X_result(:,patch_idx)),k_ref);

    
    X_reduced = dict(:,idx)*X_result(idx,patch_idx);

    % rescale the recovered image to match the scaling of the original
    % image
    X_ref = dict(:,iref)*X_result(iref,patch_idx);
    a = min(X_reduced);
    b = max(X_reduced);
    c = min(X_ref);
    d = max(X_ref);

    X_reduced = X_reduced * (d-c)/(b-a); % rescale so that X_reduced and X_ref have the same margin (max - min)
    X_reduced = X_reduced + c - min(X_reduced); % rescale so that X_reduced and X_ref has the same max and min
    
    X_reduced = X_reduced * max(X_ref(:))/max(X_reduced(:)); 
    
    I = reshape(X_reduced,[patch_size, patch_size]);
    
    
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
    

end







    
   

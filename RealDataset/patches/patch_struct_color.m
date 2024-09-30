% using the learned dictionary X_result, D_result for patches, reconstruct
% the original image
% inputs: im_size is length of image. 

function out = patch_struct_color(data, X_result, dict, img_idx, k_index)

im_size = 150;
[s1 s2] = size(X_result);
patch_size = sqrt(s1/3);
patch_num = im_size / patch_size;

k_ref = length(dict);



patch_start = (img_idx-1) * patch_num^2 + 1;
out1 = zeros(im_size);
out2 = zeros(im_size);
out3 = zeros(im_size);

out = zeros(im_size,im_size,3);

for i = 1 : patch_num^2
    patch_idx = patch_start + i - 1;
 
     % compress using dictionary learning
    [~,idx]=maxk(abs(X_result(:,patch_idx)),k_index);
    [~,iref]=maxk(abs(X_result(:,patch_idx)),k_ref);

    
    X_reduced = dict(:,idx)*X_result(idx,patch_idx);

    % rescale the recovered image to match the scaling of the original
    % image
%     X_ref = dict(:,iref)*X_result(iref,patch_idx);
%     a = min(X_reduced);
%     b = max(X_reduced);
%     c = min(X_ref);
%     d = max(X_ref);
% 
%     X_reduced = X_reduced * (d-c)/(b-a); % rescale so that X_reduced and X_ref have the same margin (max - min)
%     X_reduced = X_reduced + c - min(X_reduced); % rescale so that X_reduced and X_ref has the same max and min
%     
%     X_reduced = X_reduced * max(X_ref(:))/max(X_reduced(:)); 
    
    temp1 = data(1:100, patch_idx);
    temp2 = data(101:200, patch_idx);
    temp3 = data(201:300, patch_idx);
    
    Y1 = X_reduced(1:100);
    Y2 = X_reduced(101:200);
    Y3 = X_reduced(201:300);

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


    
end

out(:,:,1) = out1;
out(:,:,2) = out2;
out(:,:,3) = out3;






    
   

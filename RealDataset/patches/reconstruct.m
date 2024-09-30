function out = reconstruct(data, X_result, D_result, dict, dataset, image_idx, k_array)

if strcmp(dataset,'cifar10_grey') || strcmp(dataset,'mnist')
    ImageArray = [];
    
    [n p] = size(data);
    m = sqrt(n);
    im_num = length(image_idx);

    
    for k_index = k_array
        ImageSubArray = [];
        for i = 1 : im_num
            image_index = image_idx(i);
            [~,idx]=maxk(abs(X_result(:,image_index)),k_index);
            X_reduced = dict(:,idx)*X_result(idx,:);
            I = reshape(X_reduced(:,image_index),[m,m]);
            I = I/max(I(:));
            ImageSubArray = [ImageSubArray;I];
        end
        ImageArray = [ImageArray ImageSubArray];
    end
    
    % append the true image to the last column
    ImageSubArray = [];
    for i = 1 : im_num
        image_index = image_idx(i);
        I = reshape(data(:,image_index),[m,m]);
        I = I/max(I(:));
        ImageSubArray = [ImageSubArray;I];
    end
    
    ImageArray = [ImageArray ImageSubArray];
    
    % plot the results in an array
    out = ImageArray;
end



if strcmp(dataset,'cifar10')
    im_end = im_start + im_num - 1;

    n = length(D_result);
    m = sqrt(n/3);
    
    k = length(k_array);
    ImageArray = cell(1, (1+length(k_array)) * im_num);
    
     for i = 1 : im_num
         image_index = im_start + i - 1;
         for j = 1 : k
             k_index = k_array(j);
             [~,idx]=maxk(abs(X_result(:,image_index)),k_index);
             X_reduced = dict(:,idx)*X_result(idx,:);
             I = reshape(X_reduced(:,image_index),[m,m,3]);
             I = permute(I,[2,1,3]);

             temp = (i-1)*(k+1) + j;
             ImageArray(1,temp) = {I};
         end
         I_org = reshape(data(:,image_index),[m,m,3]);
         I_org = permute(I_org,[2,1,3]);
         ImageArray(1,temp+1) = {I_org};
     end
     out = ImageArray;

end


% if strcmp(dataset,'cifar10')
%     ImageArray = [];
%     im_end = im_start + im_num - 1;
% 
%     n = length(D_result);
%     m = sqrt(n/3);
%     
%     k_array = [1 5 10 50 100 300 500];
%     ImageArray = cell(im_num, length(k_array)+1);
%     
%     for i = 1 : length(k_array)
%         k_index = k_array(i);
%         for image_index = im_start:im_end
%             [~,idx]=maxk(abs(X_result(:,image_index)),k_index);
%             X_reduced = dict(:,idx)*X_result(idx,:);
%             I = reshape(X_reduced(:,image_index),[m,m,3]);
%             ImageArray(image_index-im_start+1, i) = {I};
%         end
%     end
%     
%     % append the true image to the last column
% 
%     for image_index = im_start:im_end
%         I = reshape(data(:,image_index),[m,m,3]);
%         ImageArray(image_index-im_start+1, length(k_array)+1) = {I};
%     end
%     
%     ImageArray = reshape(ImageArray, 80,1);
%     % plot the results in an array
%     out = ImageArray;
% end






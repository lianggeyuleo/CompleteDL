function montage_orig = load_montage(num_images)
% function that loads datasets and stores them into a n x p matrix.
% each image is flattened into an length n vector, and there are 
% a total of p images. 
% output: data matrix Y

% for the landscape image dataset, each column is a color image of size
% 150*150*3

im_size = 150;
montage_orig = zeros(im_size, im_size, 3, num_images);

% get a list of all files in the folder
folder_path = '~/landscape_image/';
file_list = dir([folder_path '*.jpg']);

% loop through the list and load each image into MATLAB
for i = 1 : num_images 
    file_name = file_list(i).name;
    file_path = [folder_path file_name];
    image_data = imread(file_path);
    
    % convert the image to a vector

    if length(image_data(:)) == 67500
        montage_orig(:,:,:,i) = image_data;
    end

end






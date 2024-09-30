function [Y1 Y2 Y3] = load_image()
% function that loads datasets and stores them into a n x p matrix.
% each image is flattened into an length n vector, and there are 
% a total of p images. 
% output: data matrix Y

% for the landscape image dataset, each column is a color image of size
% 150*150*3


% get a list of all files in the folder/Users/jialunzhang/Dropbox/work/research/dictionary_learning/rebuttal_code/landscape_image
folder_path = './landscape_image/';
file_list = dir([folder_path '*.jpg']);

Y1 = []; % first-layer
Y2 = []; % second-layer
Y3 = []; % third-layer

% loop through the list and load each image into MATLAB
for i = 1:length(file_list)
    file_name = file_list(i).name;
    file_path = [folder_path file_name];
    image_data = imread(file_path);
    
    % convert the image to a vector

    if length(image_data(:)) == 67500

        image_vector1 = reshape(image_data(:,:,1), [], 1);
        image_vector2 = reshape(image_data(:,:,2), [], 1);
        image_vector3 = reshape(image_data(:,:,3), [], 1);

        Y1 = [Y1 image_vector1];
        Y2 = [Y2 image_vector2];
        Y3 = [Y3 image_vector3];

    end

end






%% Add dependencies to path and load image data

currentFolder = pwd;  % Get the current working directory
addpath(genpath(currentFolder));  % Add the current directory and all subfolders to the MATLAB path


[data1 data2 data3] = load_image();
[n, p] = size(data1); % here n = 22500 = 150 * 150
m = sqrt(n); % each image is of size m * m * 3 


%% divide data matrix into patches
patch_num = 6;  
patch_size = m/patch_num;
im_size = patch_num * patch_size; 

%% reshape each layer into patches
temp = patches(data1, patch_size);
layer1 = reshape(temp, [patch_size^2 p*patch_num^2]);

temp = patches(data2, patch_size);
layer2 = reshape(temp, [patch_size^2 p*patch_num^2]);

temp = patches(data3, patch_size);
layer3 = reshape(temp, [patch_size^2 p*patch_num^2]);

% stack all three layers into a larger matrix
data = [layer1;layer2;layer3];

% truncate the total number of samples (set p to be smaller for simulation
% speed)
data = data(:,10000:20000);
data = double(data);

%% reconstruction using alternating minimization
T = 2000; % total number of iterations to run the algorithm

% alternating_min1 is the minimbatch version that applies a preconditioner
% every iteration
[X_result_1, D_result_1] = alternating_min1(data, T); 

t1 = toc-tic; % total runtime for alternating minimization

%% build a montage of reconstruction or denoising examples
num_images = 20; % number of images to use in the montage
k_index = 600 % number of atoms to use in the reconstruction

dict_dl = D_result_1;
dict_dl = inv(offset) * dict_dl;


% load and display the original images
montage_orig = load_montage(num_images);
montage_orig = montage_orig / 255;

figure
montage(montage_orig, 'size', [2 10]);

montage_noisy = zeros(im_size, im_size, 3, num_images);
montage_recon = zeros(im_size, im_size, 3, num_images);


missing_rate = 0.8;

% for the image reconstruction task, using path_block function below
% for the image denoising task, using the patch_struct_noisy function
% instead.

for i = 1 : num_images
    
%     [out_dl noisy_dl] = patch_struct_noisy(data, X_result_1, dict_dl, i, k_index, missing_rate);
    [out_dl noisy_dl] = patch_block(data, X_result_1, dict_dl, i, k_index, missing_rate);

    montage_noisy(:,:,:,i) = noisy_dl;
    montage_recon(:,:,:,i) = out_dl;
end

montage_noisy = montage_noisy/255;
montage_recon = montage_recon/255;


figure
montage(montage_noisy,'size', [2 10]);

figure
montage(montage_recon,'size', [2 10]);












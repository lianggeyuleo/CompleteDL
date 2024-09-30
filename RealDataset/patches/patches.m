function out = patches(data, patch_size)

[n p] = size(data);

m = sqrt(n);
patch_num = m/patch_size;

data = reshape(data,[m m p]);
data = reshape(data, [m patch_size patch_num*p]);
data = permute(data,[2 1 3]);
data = reshape(data, [patch_size patch_size patch_num^2 * p]);
data = permute(data,[2 1 3]);

out = data;


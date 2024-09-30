function M = normalize_col(M)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [~,p] = size(M);
    for i = 1:p
        M(:,i) = M(:,i)/norm(M(:,i));
    end
end


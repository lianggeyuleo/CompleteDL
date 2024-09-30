function [X_sorted] = abssort(X)
%SORTING Summary of this function goes here
%   Detailed explanation goes here
    [n,p] = size(X);
    X_sorted = zeros(n,p);
    for i = 1:p
        X_sorted(:,i) = sort(abs(X(:,i)));
    end
end


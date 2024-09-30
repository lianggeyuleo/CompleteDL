function [X,D,time,t1] = grad_alg(Y,D_init,T,C,eta,X_sorted,eps)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    D = D_init;

    time0 = tic;
    for t1 = 1:T
        X = (abs(D' * Y) > C/2).* (D' * Y);
        D_prev = D;
        D = normalize_col(D - 2*eta*(D*X - Y)*X');
        if norm(D_prev - D)<eps
            break
        end
%         if norm(abssort(X_log_1(:,:,t1+1))-X_sorted)<eps
%             break
%         end

        if toc(time0)>300
            break
        end
    end
    
    time = toc(time0);

    
end
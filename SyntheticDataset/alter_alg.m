function [X,D,time,t1] = alter_alg(Y,D_init,T,C,X_sorted,eps)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%     [n,p] = size(Y);
    X = Y;
    D = D_init;
    
    time0 = tic;

    for t1 = 1:T
        X = (abs(D' * Y) > C/2).* (D' * Y);
        [U1,~,U2] = svd(Y * X');
        D_prev = D;
        D = U1 * U2';
        if norm(D_prev - D)<eps
            break
        end
%         if norm(abssort(X)-X_sorted)<eps
%             break
%         end
        if toc(time0)>300
            break
        end
    end
    time = toc(time0); 
    
end


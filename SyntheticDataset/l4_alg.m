function [X,D,time,t1] = l4_alg(Y,D_init,T,C,X_sorted,eps)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%     [n,p] = size(Y);
    X = Y;
    D = D_init';
    
    time0 = tic;

    for t1 = 1:T
        [U1,~,U2] = svd(4*((D*Y).^3)*Y');
        D_prev = D;
        D = U1 * U2';
        if norm(D_prev - D)<eps
            break
        end
%         X = (abs(D * Y) > C/2).* (D * Y);
%         if norm(abssort(X)-X_sorted)<eps
%             break
%         end
        if toc(time0)>300
            break
        end
    end
    D = D';
    time = toc(time0); 
    
end


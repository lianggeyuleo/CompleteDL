clear

theta = 0.3;
p_total = 10000;
p = 100;
n = 5;
C = 0.3;

Xb = randsrc(n,p_total,[1,0;theta,1-theta]);
Xg = randn(n,p_total);
X = Xb .* Xg;
X = (abs(X) > C).* X;
for i = 1:n
    for j = 1:p_total
        if abs(X(i,j))<C
            X(i,j) = sign(X(i,j)) * C;
        end
    end
end



A = randn(n,n);
A = A/norm(A);
Y = A * X;

tY = sqrtm(inv(Y*Y'/(p_total*theta)))*Y;
offset = inv(sqrtm(inv(Y*Y'/(p_total*theta))));


T = 300;  

% Here we use 8 iterations of shrinking threshold method to initialize.
D_iter = initialize(tY,2*C,8,theta,0.8);
X_iter = tY;
X_err_log = zeros(1,T);
A_err_log = zeros(1,T);

abssX = abssort(X);
compA = assignmentsolver(offset*D_iter,A);

for t = 1:T

    index = randsample(p_total,p);   
%     index = 1:p;
    
    D_prev = D_iter;
    X_iter = (abs(D_iter' * tY(:,index)) > C/2).* (D_iter' * tY(:,index));
    [U1,Sig,U2] = svd(tY(:,index) * X_iter');
    D_iter = U1 * U2';

    X_err_log(1,t) = norm(abssX(:,index) - abssort(X_iter),'fro')/norm(X(:,index));
    A_err_log(1,t) = norm(compA - offset*D_iter,'fro');

end

figure('Name','Convergence of Algorithm');
semilogy(1:t,X_err_log(1,1:t),1:t,A_err_log(1,1:t));
xlabel('Iterations');
ylabel('||X^* - X^{(t)}||_F');
legend('||X^* - X^{(t)}||_F/||X^*||_2','||A^* - A^{(t)}||_F');

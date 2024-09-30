n_list = [50 100 150 200 250 300 350 400 450 500 550 600 650 700 750 800];
n_length = length(n_list);
final_time_log = zeros(3,n_length);
final_error_log = zeros(3,n_length);
final_iter_log = zeros(3,n_length);

C = 0.3;
T = 500;
eps = 1e-7;
theta = 0.3;
repeat = 5;
for n_counter = 1:n_length
    alter_time = 0;
    grad_time = 0;
    l4_time = 0;
    alter_error = 0;
    grad_error = 0;
    l4_error = 0;
    alter_iter = 0;
    grad_iter = 0;
    l4_iter = 0;
%     disp(n_list(n_counter));
    n = n_list(n_counter);
    k = n*theta;
    p = n*100;
    for repeat_counter = 1:repeat
%         disp(repeat_counter);
        Xb = zeros(n,p);
        for i = 1:p
            atom = zeros(n,1);
            supp_atom = randsample(n,k);
            atom(supp_atom) = ones(k,1);
            Xb(:,i) = atom;
        end
        Xg = randn(n,p);
        X = Xb .* Xg;
        for i = 1:n
            for j = 1:p
                if abs(X(i,j))<C
                    X(i,j) = sign(X(i,j)) * C;
                end
            end
        end
        [D,R] = qr(randn(n));
        Y = D * X;
        X_sorted = abssort(X);
        zeta = max(max(abs(Y)));
        supp_rate = 0.5;
        [D_init, X_init, T0] = initialize(Y,zeta,1000,theta,supp_rate);

        [~,D_result_alter,time_alter, t_alter] = alter_alg(Y,D_init,T,C,X_sorted,eps);
        alter_time = alter_time + time_alter;
        alter_error = alter_error + norm(D-assignmentsolver(D,D_result_alter),'fro');
        alter_iter = alter_iter + t_alter;
        [~,D_result_grad,time_grad, t_grad] = grad_alg(Y,D_init,T,C,1e-5,X_sorted,eps);
        grad_time = grad_time + time_grad;
        grad_error = grad_error + norm(D-assignmentsolver(D,D_result_grad),'fro');
        grad_iter = grad_iter + t_grad;
        [~,D_result_l4,time_l4, t_l4] = l4_alg(Y,D_init,1000,C,X_sorted,eps);
        l4_time = l4_time + time_l4;
        l4_error = l4_error + norm(D-assignmentsolver(D,D_result_l4),'fro');
        l4_iter = l4_iter + t_l4;

    end
    final_time_log(1,n_counter) = alter_time;
    final_time_log(2,n_counter) = grad_time;
    final_time_log(3,n_counter) = l4_time;
    final_error_log(1,n_counter) = alter_error;
    final_error_log(2,n_counter) = grad_error;
    final_error_log(3,n_counter) = l4_error;
    final_iter_log(1,n_counter) = alter_iter;
    final_iter_log(2,n_counter) = grad_iter;
    final_iter_log(3,n_counter) = l4_iter;


end
final_time_log = final_time_log/repeat;
final_error_log = final_error_log/repeat;
final_iter_log = final_iter_log/repeat;

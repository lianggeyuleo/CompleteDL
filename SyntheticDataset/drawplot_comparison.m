lgd_ftsz = 17;
lb_ftsz = 17;
lwth = 3;
figure('Name','Comparison of Methods');
tiledlayout(1,2);


nexttile;
fig_1 = plot(n_list,final_time_log(1,:),n_list,final_time_log(2,:),n_list,final_time_log(3,:));
title('Convergence Time','FontSize',15,'interpreter','latex');
x_lb = xlabel('Signal Dimension $n$','interpreter','latex');
y_lb = ylabel('Convergence Time (seconds)','interpreter','latex');
lgd = legend('Our Method','Gradient Method','$\ell-4$ Maximization','interpreter','latex');
lgd.FontSize = lgd_ftsz;
x_lb.FontSize = lb_ftsz;
y_lb.FontSize = lb_ftsz;
fig_1(1).Marker = "+";
fig_1(2).Marker = "o";
fig_1(3).Marker = "*";
fig_1(1).LineWidth = lwth;
fig_1(2).LineWidth = lwth;
fig_1(3).LineWidth = lwth;
nexttile;
fig_1 = semilogy(n_list,final_error_log(1,:),n_list,final_error_log(2,:),n_list,final_error_log(3,:));
title('Final Error','FontSize',15,'interpreter','latex');
x_lb = xlabel('Signal Dimension $n$','interpreter','latex');
y_lb = ylabel('Final Error $\|\mathbf{D}^{(T)}-\mathbf{D}^*\|_F$','interpreter','latex');
lgd = legend('Our Method','Gradient Method','$\ell-4$ Maximization','interpreter','latex');
lgd.FontSize = lgd_ftsz;
x_lb.FontSize = lb_ftsz;
y_lb.FontSize = lb_ftsz;
fig_1(1).Marker = "+";
fig_1(2).Marker = "o";
fig_1(3).Marker = "*";
fig_1(1).LineWidth = lwth;
fig_1(2).LineWidth = lwth;
fig_1(3).LineWidth = lwth;
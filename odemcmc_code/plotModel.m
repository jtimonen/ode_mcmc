function [] = plotModel(n, ttt, Data, Model, theta_y, theta_x, names)
% Plot model output and data
% author: Juho Timonen
% date: 9 Jun 2017

figure('units','normalized','outerposition', [0.05 0.05 0.9 0.9])
nRows = 2;
M = Model.M;

if(M == 3)
    l1 = theta_x(1);
    l2 = theta_x(2);
    t1 = theta_x(3);
    t2 = theta_x(4);
elseif (M == 2)
    l1 = theta_x(1);
    t1 = theta_x(2);
end

% Plot data
for i = 1:n
    subplot(nRows, 2, i+1); hold on;
    plot(Data.t, Data.Y(:,i), 'o');
end

% Solve the model and plot it
[ttt, Y_model] = solveModel(ttt, [theta_y, theta_x], Model, Data.y0');

for i = 1:n
    subplot(nRows,2,i+1)
    plot(ttt, Y_model(:, i), 'Color', 0.5*ones(1,3), 'lineWidth', 1);
    title(names{i})
    axis tight;
    ylabel('Rel. Abundance');
    xlabel('Time');
end

% Plot the latent process
subplot(nRows, 2, 1)
if(M==3)
    lpf = Model.lfn(l1, l2, ttt, t1, t2);
    plot(ttt, lpf,  'Color', 0.5*ones(1,3), 'LineWidth', 1); hold on;
    xlabel('Time');
end
if(M==2)
    lpf = Model.lfn(l1, ttt, t1);
    plot(ttt, lpf, 'r', 'LineWidth', 1); hold on;
end

title('Latent process');
axis tight;

end



%% Computationally more exhaustive part
[S1, OVL1] = getOvlTraces(1);
[S2, OVL2] = getOvlTraces(2);
[S3, OVL3_12, OVL3_34] = getOvlTraces(3);

save('processed_th17', 'S1', 'S2', 'S3', ...
    'OVL1', 'OVL2', 'OVL3_12', 'OVL3_34');
%% Plotting
load('processed_th17');
labels = cell(15,1);
labels{1} = 'BATF –> STAT3';
labels{2} = 'A –> C';
labels{3} = 'B –> A';
labels{4} = 'B –> C';
labels{5} = 'C –> A';
labels{6} = 'C –> B';
labels{7} = 'A –| B';
labels{8} = 'A –| C';
labels{9} = 'B –| A';
labels{10} = 'B –| C';
labels{11} = 'BATF + IRF4 –> STAT3';
labels{12} = 'BATF + IRF4 –> STAT3';
labels{13} = 'BATF + IRF4 –> STAT3';
labels{14} = 'MAF –| BATF';
labels{15} = 'RORC –| MAF';

COL = [186,228,179; ...
       116,196,118; ...
       49,163,84;   ...
       0,109,44];
   
COL = COL/255;
colormap(COL);

% M = 1
subplot(1,6,1); EC = 'none'; WID = 1;
barh([S1{1}, S1{2}], WID, 'EdgeColor', EC);
set(gca,'ygrid','on')
set(gca,'YTickLabel', labels);
xlabel('Link weight');  axis tight;
box off;

% M = 2
W1 = S2{1}; W2 = S2{2};
for i = 1:2
    subplot(1,6,1+i);
    barh([W1(:, i), W2(:, i)], WID, 'EdgeColor', EC);
    set(gca,'ygrid','on'); set(gca,'YTickLabel', []);
    xlabel('Link weight');  axis tight;
    box off;
end

W1 = S3{1}; W2 = S3{2}; W3 = S3{3}; W4 = S3{4};
for i = 1:3
    subplot(1,6,3+i);
    barh([W1(:, i), W2(:, i), W3(:, i), W4(:, i)], WID, 'EdgeColor', EC);
    set(gca,'ygrid','on'); set(gca,'YTickLabel', []);
    xlabel('Link weight');  axis tight;
    box off;
end

figure;
LW = 1;
color_GREY = 0.6*ones(3,1);
plot(OVL1, 'k', 'LineWidth', LW); hold on;
plot(OVL2, 'Color', color_GREY, 'LineWidth', LW);
plot(OVL3_12, 'k--', 'LineWidth', LW);
plot(OVL3_34, 'Color', color_GREY, 'LineStyle', '--', 'LineWidth', LW);

legend('M = 1 (ch. 1 vs. ch. 2)', 'M = 2 (ch. 1 vs. ch. 2)', ...
    'M = 3 (ch. 1 vs. ch. 2)', 'M = 3 (ch. 3 vs. ch. 4)');


xlabel('Number of models');
ylabel('OVL');
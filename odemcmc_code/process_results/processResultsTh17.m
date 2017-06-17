
OVL1 = getOvlTraces(1);
OVL2 = getOvlTraces(2);
[OVL31, OVL32] = getOvlTraces(3);

LW = 1;
plot(OVL1, 'k', 'LineWidth', LW); hold on;
plot(OVL2, 'Color', 0.6*ones(3,1), 'LineWidth', LW); 
plot(OVL31, 'k--', 'LineWidth', LW); 
plot(OVL32, 'Color', 0.6*ones(3,1), 'LineStyle', '--', 'LineWidth', LW);
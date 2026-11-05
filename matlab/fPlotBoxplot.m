function fPlotBoxplot(mData, cLabels, sTitle, sYLabel)
% fPlotBoxplot  Boxplot without toolbox: box from the 25th to the 75th
% percentile, line at the median, whiskers to the most extreme value
% within 1.5 interquartile ranges. Outliers are not drawn.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

figure('Color', 'w');
hold on
for iCol = 1:size(mData, 2)
    vData = mData(:, iCol);
    dQ1 = fQuantile(vData, 0.25); dQ2 = fQuantile(vData, 0.50); dQ3 = fQuantile(vData, 0.75);
    dLow  = min(vData(vData >= dQ1 - 1.5 * (dQ3 - dQ1)));
    dHigh = max(vData(vData <= dQ3 + 1.5 * (dQ3 - dQ1)));
    plot([iCol - 0.25, iCol + 0.25, iCol + 0.25, iCol - 0.25, iCol - 0.25], ...
         [dQ1, dQ1, dQ3, dQ3, dQ1], 'k');
    plot([iCol - 0.25, iCol + 0.25], [dQ2, dQ2], 'k', 'LineWidth', 1.5);
    plot([iCol, iCol], [dQ3, dHigh], 'k--', [iCol, iCol], [dLow, dQ1], 'k--');
    plot([iCol - 0.1, iCol + 0.1], [dHigh, dHigh], 'k', [iCol - 0.1, iCol + 0.1], [dLow, dLow], 'k');
end
hold off
set(gca, 'XTick', 1:size(mData, 2), 'XTickLabel', cLabels, 'XLim', [0.4, size(mData, 2) + 0.6]);
title(sTitle); xlabel('Scenario'); ylabel(sYLabel); grid on; box on
end

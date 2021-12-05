load('dataLab1.mat')
addpath(genpath(pwd))

% Parse variables

fph = zeros(size(flow));
fph(1, :) = flow(1, :);
fph(:, 1) = flow(:, 1);
fph(2:end, 2:end) = (flow(2:end, 2:end)/90)*3600;
adj = struct;

% STEP 1

occ60 = occupancy(41, 2:end)';
for i = 1:size(links, 1)
    orig = find(nodes(:, 1) == links(i, 4));
    dest = find(nodes(:, 1) == links(i, 5));
    adj_bw = [0, 1;0, 0];
    gplotdc(adj_bw, [nodes(orig, 2:3); nodes(dest, 2:3)], 0, occ60(i))
    hold on
end
hold off
fig = gcf;
title('Map of Occupancy at 60 min')
exportgraphics(fig, 'Figure_1.png', 'Resolution', 100)

occ90 = occupancy(61, 2:end)';
for i = 1:size(links, 1)
    orig = find(nodes(:, 1) == links(i, 4));
    dest = find(nodes(:, 1) == links(i, 5));
    adj_bw = [0, 1;0, 0];
    gplotdc(adj_bw, [nodes(orig, 2:3); nodes(dest, 2:3)], 0, occ90(i))
    hold on
end
hold off
fig = gcf;
title('Map of Occupancy at 90 min')
exportgraphics(fig, 'Figure_2.png', 'Resolution', 100)

occ120 = occupancy(81, 2:end)';
for i = 1:size(links, 1)
    orig = find(nodes(:, 1) == links(i, 4));
    dest = find(nodes(:, 1) == links(i, 5));
    adj_bw = [0, 1;0, 0];
    gplotdc(adj_bw, [nodes(orig, 2:3); nodes(dest, 2:3)], 0, occ120(i))
    hold on
end
hold off
fig = gcf;
title('Map of Occupancy at 120 min')
exportgraphics(fig, 'Figure_3.png', 'Resolution', 100)

% STEP 2

scatter(occupancy(2:end, 22), fph(2:end, 22), 10)
hold off
fig = gcf;
title('Volume vs. Occupancy of link 22')
xlabel('Occupancy (%)')
ylabel('Volume (veh/h)')
exportgraphics(fig, 'Figure_4.png', 'Resolution', 100)

scatter((occupancy(2:end, 22) + occupancy(2:end, 48))/2, (fph(2:end, 22) + fph(2:end, 48))/2, 10)
hold off
fig = gcf;
title('Volume vs. Occupancy of average of links 22 & 48')
xlabel('Occupancy (%)')
ylabel('Volume (veh/h)')
exportgraphics(fig, 'Figure_5.png', 'Resolution', 100)

scatter(mean(occupancy(2:end, 2:end), 2), mean(fph(2:end, 2:end), 2), 10)
hold off
fig = gcf;
title('Volume vs. Occupancy of average of all links')
xlabel('Occupancy (%)')
ylabel('Volume (veh/h)')
exportgraphics(fig, 'Figure_6.png', 'Resolution', 100)

links1 = find(links(:, 6) == 1);
links2 = find(links(:, 6) == 2);
links3 = find(links(:, 6) == 3);
links4 = find(links(:, 6) == 4);

scatter(mean(occupancy(2:end, links1 + 1), 2), mean(fph(2:end, links1 + 1), 2), 10, 'blue')
hold on
scatter(mean(occupancy(2:end, links2 + 1), 2), mean(fph(2:end, links2 + 1), 2), 10, 'red')
hold on
scatter(mean(occupancy(2:end, links3 + 1), 2), mean(fph(2:end, links3 + 1), 2), 10, 'green')
hold on
scatter(mean(occupancy(2:end, links4 + 1), 2), mean(fph(2:end, links4 + 1), 2), 10, 'black')
hold off
fig = gcf;
title('Volume vs. Occupancy of regions 1 - 4')
xlabel('Occupancy (%)')
ylabel('Volume (veh/h)')
legend('Region 1', 'Region 2', 'Region 3', 'Region 4')
exportgraphics(fig, 'Figure_7.png', 'Resolution', 100)

% STEP 3

density = ((occupancy(2:end, 2:end)/100).*links(:,3)')/0.007;
linkspeed = fph(2:end, 2:end)./density;

sms1 = sum(fph(2:end, links1 + 1).*links(links1, 2)', 2)./sum(density(:, links1).*links(links1, 2)', 2);
sms2 = sum(fph(2:end, links2 + 1).*links(links2, 2)', 2)./sum(density(:, links2).*links(links2, 2)', 2);
sms3 = sum(fph(2:end, links3 + 1).*links(links3, 2)', 2)./sum(density(:, links3).*links(links3, 2)', 2);
sms4 = sum(fph(2:end, links4 + 1).*links(links4, 2)', 2)./sum(density(:, links4).*links(links4, 2)', 2);

scatter(mean(density(:, links1), 2), sms1, 10, 'blue')
hold on
scatter(mean(density(:, links2), 2), sms2, 10, 'red')
hold on
scatter(mean(density(:, links3), 2), sms3, 10, 'green')
hold on
scatter(mean(density(:, links4), 2), sms4, 10, 'black')
hold off
fig = gcf;
title('Space-Mean Speed vs. Average Density of regions 1 - 4')
xlabel('Average Density (veh/km)')
ylabel('Space-Mean Speed (km/h)')
legend('Region 1', 'Region 2', 'Region 3', 'Region 4')
exportgraphics(fig, 'Figure_8.png', 'Resolution', 100)

sms1(:, 2) = [1:80]*90;
sms2(:, 2) = [1:80]*90;
sms3(:, 2) = [1:80]*90;
sms4(:, 2) = [1:80]*90;
plot(sms1(:, 2), sms1(:, 1), 'blue')
hold on
plot(sms2(:, 2), sms2(:, 1), 'red')
hold on
plot(sms3(:, 2), sms3(:, 1), 'green')
hold on
plot(sms4(:, 2), sms4(:, 1), 'black')
hold off
fig = gcf;
title('Time Series of Space-Mean Speed of regions 1 - 4')
xlabel('Time (s)')
ylabel('Space-Mean Speed (km/h)')
legend('Region 1', 'Region 2', 'Region 3', 'Region 4')
set(gca, 'XLim', [0, 7200])
exportgraphics(fig, 'Figure_9.png', 'Resolution', 100)

% STEP 4

accumulation = density.*(links(:, 2)'/1000);
production = fph(2:end, 2:end).*(links(:,2)'/1000);

ap1 = sum(accumulation(:, links1), 2);
ap2 = sum(accumulation(:, links2), 2);
ap3 = sum(accumulation(:, links3), 2);
ap4 = sum(accumulation(:, links4), 2);
ap1(:, 2) = sum(production(:, links1), 2);
ap2(:, 2) = sum(production(:, links2), 2);
ap3(:, 2) = sum(production(:, links3), 2);
ap4(:, 2) = sum(production(:, links4), 2);
ap1 = sortrows(ap1, 1, 'ascend');
ap2 = sortrows(ap2, 1, 'ascend');
ap3 = sortrows(ap3, 1, 'ascend');
ap4 = sortrows(ap4, 1, 'ascend');

scatter(accumulation(:, 284), production(:, 284), 10)
hold off
fig = gcf;
title('Production vs. Accumulation of link 284')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
exportgraphics(fig, 'Figure_10.png', 'Resolution', 100)

scatter(accumulation(:, 296) + accumulation(:, 982), production(:, 296) + production(:, 982), 10)
hold off
fig = gcf;
title('Production vs. Accumulation of sum of links 296 & 982')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
exportgraphics(fig, 'Figure_11.png', 'Resolution', 100)

scatter(ap1(:, 1), ap1(:, 2), 10, 'blue')
hold on
scatter(ap2(:, 1), ap2(:, 2), 10, 'red')
hold on
scatter(ap3(:, 1), ap3(:, 2), 10, 'green')
hold on
scatter(ap4(:, 1), ap4(:, 2), 10, 'black')
hold off
fig = gcf;
title('Production vs. Accumulation of regions 1 - 4')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
legend('Region 1', 'Region 2', 'Region 3', 'Region 4')
exportgraphics(fig, 'Figure_12.png', 'Resolution', 100)

% STEP 5-1

[p1, S1, mu1] = polyfit(ap1(:, 1), ap1(:, 2), 2);
y1 = polyval(p1, ap1(:, 1), [], mu1);

[p2, S2, mu2] = polyfit(ap2(:, 1), ap2(:, 2), 2);
y2 = polyval(p2, ap2(:, 1), [], mu2);

[p3, S3, mu3] = polyfit(ap3(:, 1), ap3(:, 2), 2);
y3 = polyval(p3, ap3(:, 1), [], mu3);

[p4, S4, mu4] = polyfit(ap4(:, 1), ap4(:, 2), 2);
y4 = polyval(p4, ap4(:, 1), [], mu4);

scatter(ap1(:, 1), ap1(:, 2), 10, 'blue')
hold on
scatter(ap2(:, 1), ap2(:, 2), 10, 'red')
hold on
scatter(ap3(:, 1), ap3(:, 2), 10, 'green')
hold on
scatter(ap4(:, 1), ap4(:, 2), 10, 'black')
hold on

plot(ap1(:, 1), y1, color='b')
hold on
plot(ap2(:, 1), y2, color='r')
hold on
plot(ap3(:, 1), y3, color='g')
hold on
plot(ap4(:, 1), y4, color='k')
hold off
fig = gcf;
title('Fitted polynomial for MFD')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
legend('Region 1', 'Region 2', 'Region 3', 'Region 4')
exportgraphics(fig, 'Figure_13.png', 'Resolution', 100)

% STEP 5-2

tlength = sum(links(:, 2).*links(:, 6));
tlength_1 = sum(links(links1, 2).*links(links1, 6));
tlength_2 = sum(links(links2, 2).*links(links2, 6));
tlength_3 = sum(links(links3, 2).*links(links3, 6));
tlength_4 = sum(links(links4, 2).*links(links4, 6));

[lanes50_1, lanes50_1_ind] = sortrows(links(links1, :), 3, 'descend');
lanes50_1 = lanes50_1(1:round(size(lanes50_1, 1)/2), :);
lanes50_1_ind = lanes50_1_ind(1:round(size(lanes50_1_ind, 1)/2), :);
lanes50_1_names = links1(lanes50_1_ind, 1);
[lanes50_2, lanes50_2_ind] = sortrows(links(links2, :), 3, 'descend');
lanes50_2 = lanes50_2(1:round(size(lanes50_2, 1)/2), :);
lanes50_2_ind = lanes50_2_ind(1:round(size(lanes50_2_ind, 1)/2), :);
lanes50_2_names = links2(lanes50_2_ind, 1);
[lanes50_3, lanes50_3_ind] = sortrows(links(links3, :), 3, 'descend');
lanes50_3 = lanes50_3(1:round(size(lanes50_3, 1)/2), :);
lanes50_3_ind = lanes50_3_ind(1:round(size(lanes50_3_ind, 1)/2), :);
lanes50_3_names = links3(lanes50_3_ind, 1);
[lanes50_4, lanes50_4_ind] = sortrows(links(links4, :), 3, 'descend');
lanes50_4 = lanes50_4(1:round(size(lanes50_4, 1)/2), :);
lanes50_4_ind = lanes50_4_ind(1:round(size(lanes50_4_ind, 1)/2), :);
lanes50_4_names = links4(lanes50_4_ind, 1);

lanes_ratio_1 = tlength_1/sum(links(lanes50_1_names, 2).*links(lanes50_1_names, 6));
lanes_ratio_2 = tlength_2/sum(links(lanes50_2_names, 2).*links(lanes50_2_names, 6));
lanes_ratio_3 = tlength_3/sum(links(lanes50_3_names, 2).*links(lanes50_3_names, 6));
lanes_ratio_4 = tlength_4/sum(links(lanes50_4_names, 2).*links(lanes50_4_names, 6));

lanes_ap1 = sum(accumulation(:, lanes50_1_names), 2)*lanes_ratio_1;
lanes_ap2 = sum(accumulation(:, lanes50_2_names), 2)*lanes_ratio_2;
lanes_ap3 = sum(accumulation(:, lanes50_3_names), 2)*lanes_ratio_3;
lanes_ap4 = sum(accumulation(:, lanes50_4_names), 2)*lanes_ratio_4;
lanes_ap1(:, 2) = sum(production(:, lanes50_1_names), 2)*lanes_ratio_1;
lanes_ap2(:, 2) = sum(production(:, lanes50_2_names), 2)*lanes_ratio_2;
lanes_ap3(:, 2) = sum(production(:, lanes50_3_names), 2)*lanes_ratio_3;
lanes_ap4(:, 2) = sum(production(:, lanes50_4_names), 2)*lanes_ratio_4;
lanes_ap1 = sortrows(lanes_ap1, 1, 'ascend');
lanes_ap2 = sortrows(lanes_ap2, 1, 'ascend');
lanes_ap3 = sortrows(lanes_ap3, 1, 'ascend');
lanes_ap4 = sortrows(lanes_ap4, 1, 'ascend');

[length50_1, length50_1_ind] = sortrows(links(links1, :), 2, 'descend');
length50_1 = length50_1(1:round(size(length50_1, 1)/2), :);
length50_1_ind = length50_1_ind(1:round(size(length50_1_ind, 1)/2), :);
length50_1_names = links1(length50_1_ind, 1);
[length50_2, length50_2_ind] = sortrows(links(links2, :), 2, 'descend');
length50_2 = length50_2(1:round(size(length50_2, 1)/2), :);
length50_2_ind = length50_2_ind(1:round(size(length50_2_ind, 1)/2), :);
length50_2_names = links2(length50_2_ind, 1);
[length50_3, length50_3_ind] = sortrows(links(links3, :), 2, 'descend');
length50_3 = length50_3(1:round(size(length50_3, 1)/2), :);
length50_3_ind = length50_3_ind(1:round(size(length50_3_ind, 1)/2), :);
length50_3_names = links3(length50_3_ind, 1);
[length50_4, length50_4_ind] = sortrows(links(links4, :), 2, 'descend');
length50_4 = length50_4(1:round(size(length50_4, 1)/2), :);
length50_4_ind = length50_4_ind(1:round(size(length50_4_ind, 1)/2), :);
length50_4_names = links4(length50_4_ind, 1);

length_ratio_1 = tlength_1/sum(links(length50_1_names, 2).*links(length50_1_names, 6));
length_ratio_2 = tlength_2/sum(links(length50_2_names, 2).*links(length50_2_names, 6));
length_ratio_3 = tlength_3/sum(links(length50_3_names, 2).*links(length50_3_names, 6));
length_ratio_4 = tlength_4/sum(links(length50_4_names, 2).*links(length50_4_names, 6));

length_ap1 = sum(accumulation(:, length50_1_names), 2)*length_ratio_1;
length_ap2 = sum(accumulation(:, length50_2_names), 2)*length_ratio_2;
length_ap3 = sum(accumulation(:, length50_3_names), 2)*length_ratio_3;
length_ap4 = sum(accumulation(:, length50_4_names), 2)*length_ratio_4;
length_ap1(:, 2) = sum(production(:, length50_1_names), 2)*length_ratio_1;
length_ap2(:, 2) = sum(production(:, length50_2_names), 2)*length_ratio_2;
length_ap3(:, 2) = sum(production(:, length50_3_names), 2)*length_ratio_3;
length_ap4(:, 2) = sum(production(:, length50_4_names), 2)*length_ratio_4;
length_ap1 = sortrows(length_ap1, 1, 'ascend');
length_ap2 = sortrows(length_ap2, 1, 'ascend');
length_ap3 = sortrows(length_ap3, 1, 'ascend');
length_ap4 = sortrows(length_ap4, 1, 'ascend');

links(:, 7) = mean(fph(2:end, 2:end));

[flow50_1, flow50_1_ind] = sortrows(links(links1, :), 7, 'descend');
flow50_1 = flow50_1(1:round(size(flow50_1, 1)/2), :);
flow50_1_ind = flow50_1_ind(1:round(size(flow50_1_ind, 1)/2), :);
flow50_1_names = links1(flow50_1_ind, 1);
[flow50_2, flow50_2_ind] = sortrows(links(links2, :), 7, 'descend');
flow50_2 = flow50_2(1:round(size(flow50_2, 1)/2), :);
flow50_2_ind = flow50_2_ind(1:round(size(flow50_2_ind, 1)/2), :);
flow50_2_names = links2(flow50_2_ind, 1);
[flow50_3, flow50_3_ind] = sortrows(links(links3, :), 7, 'descend');
flow50_3 = flow50_3(1:round(size(flow50_3, 1)/2), :);
flow50_3_ind = flow50_3_ind(1:round(size(flow50_3_ind, 1)/2), :);
flow50_3_names = links3(flow50_3_ind, 1);
[flow50_4, flow50_4_ind] = sortrows(links(links4, :), 7, 'descend');
flow50_4 = flow50_4(1:round(size(flow50_4, 1)/2), :);
flow50_4_ind = flow50_4_ind(1:round(size(flow50_4_ind, 1)/2), :);
flow50_4_names = links4(flow50_4_ind, 1);

flow_ratio_1 = tlength_1/sum(links(flow50_1_names, 2).*links(flow50_1_names, 6));
flow_ratio_2 = tlength_2/sum(links(flow50_2_names, 2).*links(flow50_2_names, 6));
flow_ratio_3 = tlength_3/sum(links(flow50_3_names, 2).*links(flow50_3_names, 6));
flow_ratio_4 = tlength_4/sum(links(flow50_4_names, 2).*links(flow50_4_names, 6));

flow_ap1 = sum(accumulation(:, flow50_1_names), 2)*flow_ratio_1;
flow_ap2 = sum(accumulation(:, flow50_2_names), 2)*flow_ratio_2;
flow_ap3 = sum(accumulation(:, flow50_3_names), 2)*flow_ratio_3;
flow_ap4 = sum(accumulation(:, flow50_4_names), 2)*flow_ratio_4;
flow_ap1(:, 2) = sum(production(:, flow50_1_names), 2)*flow_ratio_1;
flow_ap2(:, 2) = sum(production(:, flow50_2_names), 2)*flow_ratio_2;
flow_ap3(:, 2) = sum(production(:, flow50_3_names), 2)*flow_ratio_3;
flow_ap4(:, 2) = sum(production(:, flow50_4_names), 2)*flow_ratio_4;
flow_ap1 = sortrows(flow_ap1, 1, 'ascend');
flow_ap2 = sortrows(flow_ap2, 1, 'ascend');
flow_ap3 = sortrows(flow_ap3, 1, 'ascend');
flow_ap4 = sortrows(flow_ap4, 1, 'ascend');

% STEP 5-3

[lanes_p1, lanes_S1, lanes_mu1] = polyfit(lanes_ap1(:, 1), lanes_ap1(:, 2), 2);
lanes_y1 = polyval(lanes_p1, lanes_ap1(:, 1), [], lanes_mu1);
[lanes_p2, lanes_S2, lanes_mu2] = polyfit(lanes_ap2(:, 1), lanes_ap2(:, 2), 2);
lanes_y2 = polyval(lanes_p2, lanes_ap2(:, 1), [], lanes_mu2);
[lanes_p3, lanes_S3, lanes_mu3] = polyfit(lanes_ap3(:, 1), lanes_ap3(:, 2), 2);
lanes_y3 = polyval(lanes_p3, lanes_ap3(:, 1), [], lanes_mu3);
[lanes_p4, lanes_S4, lanes_mu4] = polyfit(lanes_ap4(:, 1), lanes_ap4(:, 2), 2);
lanes_y4 = polyval(lanes_p4, lanes_ap4(:, 1), [], lanes_mu4);

[length_p1, length_S1, length_mu1] = polyfit(length_ap1(:, 1), length_ap1(:, 2), 2);
length_y1 = polyval(length_p1, length_ap1(:, 1), [], length_mu1);
[length_p2, length_S2, length_mu2] = polyfit(length_ap2(:, 1), length_ap2(:, 2), 2);
length_y2 = polyval(length_p2, length_ap2(:, 1), [], length_mu2);
[length_p3, length_S3, length_mu3] = polyfit(length_ap3(:, 1), length_ap3(:, 2), 2);
length_y3 = polyval(length_p3, length_ap3(:, 1), [], length_mu3);
[length_p4, length_S4, length_mu4] = polyfit(length_ap4(:, 1), length_ap4(:, 2), 2);
length_y4 = polyval(length_p4, length_ap4(:, 1), [], length_mu4);

[flow_p1, flow_S1, flow_mu1] = polyfit(flow_ap1(:, 1), flow_ap1(:, 2), 2);
flow_y1 = polyval(flow_p1, flow_ap1(:, 1), [], flow_mu1);
[flow_p2, flow_S2, flow_mu2] = polyfit(flow_ap2(:, 1), flow_ap2(:, 2), 2);
flow_y2 = polyval(flow_p2, flow_ap2(:, 1), [], flow_mu2);
[flow_p3, flow_S3, flow_mu3] = polyfit(flow_ap3(:, 1), flow_ap3(:, 2), 2);
flow_y3 = polyval(flow_p3, flow_ap3(:, 1), [], flow_mu3);
[flow_p4, flow_S4, flow_mu4] = polyfit(flow_ap4(:, 1), flow_ap4(:, 2), 2);
flow_y4 = polyval(flow_p4, flow_ap4(:, 1), [], flow_mu4);

scatter(lanes_ap1(:, 1), lanes_ap1(:, 2), 10, 'blue')
hold on
scatter(lanes_ap2(:, 1), lanes_ap2(:, 2), 10, 'red')
hold on
scatter(lanes_ap3(:, 1), lanes_ap3(:, 2), 10, 'green')
hold on
scatter(lanes_ap4(:, 1), lanes_ap4(:, 2), 10, 'black')
hold off
fig = gcf;
title('MFD of 50% of links with most lanes of regions 1 - 4')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
legend('Region 1', 'Region 2', 'Region 3', 'Region 4')
exportgraphics(fig, 'Figure_14.png', 'Resolution', 100)

scatter(length_ap1(:, 1), length_ap1(:, 2), 10, 'blue')
hold on
scatter(length_ap2(:, 1), length_ap2(:, 2), 10, 'red')
hold on
scatter(length_ap3(:, 1), length_ap3(:, 2), 10, 'green')
hold on
scatter(length_ap4(:, 1), length_ap4(:, 2), 10, 'black')
hold off
fig = gcf;
title('MFD of 50% of links with longest lengths of regions 1 - 4')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
legend('Region 1', 'Region 2', 'Region 3', 'Region 4')
exportgraphics(fig, 'Figure_15.png', 'Resolution', 100)

scatter(flow_ap1(:, 1), flow_ap1(:, 2), 10, 'blue')
hold on
scatter(flow_ap2(:, 1), flow_ap2(:, 2), 10, 'red')
hold on
scatter(flow_ap3(:, 1), flow_ap3(:, 2), 10, 'green')
hold on
scatter(flow_ap4(:, 1), flow_ap4(:, 2), 10, 'black')
hold off
fig = gcf;
title('MFD of 50% of links with highest avg. flows of regions 1 - 4')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
legend('Region 1', 'Region 2', 'Region 3', 'Region 4')
exportgraphics(fig, 'Figure_16.png', 'Resolution', 100)

% STEP 5-4

plot(lanes_ap1(:, 1), lanes_y1, color='b')
hold on
plot(length_ap1(:, 1), length_y1, color='r')
hold on
plot(flow_ap1(:, 1), flow_y1, color='g')
hold on
plot(ap1(:, 1), y1, color='k')
hold off
fig = gcf;
title('MFD of region 1 with different methods of selecting links')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
legend('Most Lanes', 'Longest Length', 'Highest Avg. Flow', 'All links')
exportgraphics(fig, 'Figure_17.png', 'Resolution', 100)

plot(lanes_ap2(:, 1), lanes_y2, color='b')
hold on
plot(length_ap2(:, 1), length_y2, color='r')
hold on
plot(flow_ap2(:, 1), flow_y2, color='g')
hold on
plot(ap2(:, 1), y2, color='k')
hold off
fig = gcf;
title('MFD of region 2 with different methods of selecting links')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
legend('Most Lanes', 'Longest Length', 'Highest Avg. Flow', 'All links')
exportgraphics(fig, 'Figure_18.png', 'Resolution', 100)

plot(lanes_ap3(:, 1), lanes_y3, color='b')
hold on
plot(length_ap3(:, 1), length_y3, color='r')
hold on
plot(flow_ap3(:, 1), flow_y3, color='g')
hold on
plot(ap3(:, 1), y3, color='k')
hold off
fig = gcf;
title('MFD of region 3 with different methods of selecting links')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
legend('Most Lanes', 'Longest Length', 'Highest Avg. Flow', 'All links')
exportgraphics(fig, 'Figure_19.png', 'Resolution', 100)

plot(lanes_ap4(:, 1), lanes_y4, color='b')
hold on
plot(length_ap4(:, 1), length_y4, color='r')
hold on
plot(flow_ap4(:, 1), flow_y4, color='g')
hold on
plot(ap4(:, 1), y4, color='k')
hold off
fig = gcf;
title('MFD of region 4 with different methods of selecting links')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
legend('Most Lanes', 'Longest Length', 'Highest Avg. Flow', 'All links')
exportgraphics(fig, 'Figure_20.png', 'Resolution', 100)

errors = zeros(4, 3);

[errors(1, 1), ~] = DiscreteFrechetDist([lanes_ap1(:, 1), lanes_y1], [ap1(:, 1), y1]);
[errors(1, 2), ~] = DiscreteFrechetDist([length_ap1(:, 1), length_y1], [ap1(:, 1), y1]);
[errors(1, 3), ~] = DiscreteFrechetDist([flow_ap1(:, 1), flow_y1], [ap1(:, 1), y1]);

[errors(2, 1), ~] = DiscreteFrechetDist([lanes_ap2(:, 1), lanes_y2], [ap2(:, 1), y2]);
[errors(2, 2), ~] = DiscreteFrechetDist([length_ap2(:, 1), length_y2], [ap2(:, 1), y2]);
[errors(2, 3), ~] = DiscreteFrechetDist([flow_ap2(:, 1), flow_y2], [ap2(:, 1), y2]);

[errors(3, 1), ~] = DiscreteFrechetDist([lanes_ap3(:, 1), lanes_y3], [ap3(:, 1), y3]);
[errors(3, 2), ~] = DiscreteFrechetDist([length_ap3(:, 1), length_y3], [ap3(:, 1), y3]);
[errors(3, 3), ~] = DiscreteFrechetDist([flow_ap3(:, 1), flow_y3], [ap3(:, 1), y3]);

[errors(4, 1), ~] = DiscreteFrechetDist([lanes_ap4(:, 1), lanes_y4], [ap4(:, 1), y4]);
[errors(4, 2), ~] = DiscreteFrechetDist([length_ap4(:, 1), length_y4], [ap4(:, 1), y4]);
[errors(4, 3), ~] = DiscreteFrechetDist([flow_ap4(:, 1), flow_y4], [ap4(:, 1), y4]);

% STEP 6

rand_1 = randsample(links1, round(size(links1, 1)/2));
rand_2 = randsample(links2, round(size(links2, 1)/2));
rand_3 = randsample(links3, round(size(links3, 1)/2));
rand_4 = randsample(links4, round(size(links4, 1)/2));

rand_ap1 = sum(accumulation(:, rand_1), 2)*2;
rand_ap2 = sum(accumulation(:, rand_2), 2)*2;
rand_ap3 = sum(accumulation(:, rand_3), 2)*2;
rand_ap4 = sum(accumulation(:, rand_4), 2)*2;
rand_ap1(:, 2) = sum(production(:, rand_1), 2)*2;
rand_ap2(:, 2) = sum(production(:, rand_2), 2)*2;
rand_ap3(:, 2) = sum(production(:, rand_3), 2)*2;
rand_ap4(:, 2) = sum(production(:, rand_4), 2)*2;
rand_ap1 = sortrows(rand_ap1, 1, 'ascend');
rand_ap2 = sortrows(rand_ap2, 1, 'ascend');
rand_ap3 = sortrows(rand_ap3, 1, 'ascend');
rand_ap4 = sortrows(rand_ap4, 1, 'ascend');

[rand_p1, rand_S1, rand_mu1] = polyfit(rand_ap1(:, 1), rand_ap1(:, 2), 2);
rand_y1 = polyval(rand_p1, rand_ap1(:, 1), [], rand_mu1);
[rand_p2, rand_S2, rand_mu2] = polyfit(rand_ap2(:, 1), rand_ap2(:, 2), 2);
rand_y2 = polyval(rand_p2, rand_ap2(:, 1), [], rand_mu2);
[rand_p3, rand_S3, rand_mu3] = polyfit(rand_ap3(:, 1), rand_ap3(:, 2), 2);
rand_y3 = polyval(rand_p3, rand_ap3(:, 1), [], rand_mu3);
[rand_p4, rand_S4, rand_mu4] = polyfit(rand_ap4(:, 1), rand_ap4(:, 2), 2);
rand_y4 = polyval(rand_p4, rand_ap4(:, 1), [], rand_mu4);

plot(lanes_ap1(:, 1), lanes_y1, color='b')
hold on
plot(length_ap1(:, 1), length_y1, color='r')
hold on
plot(flow_ap1(:, 1), flow_y1, color='g')
hold on
plot(rand_ap1(:, 1), rand_y1, color='m')
hold on
plot(ap1(:, 1), y1, color='k')
hold off
fig = gcf;
title('MFD of region 1 with different methods of selecting links')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
legend('Most Lanes', 'Longest Length', 'Highest Avg. Flow', 'Random Sample', 'All links')
exportgraphics(fig, 'Figure_21.png', 'Resolution', 100)

plot(lanes_ap2(:, 1), lanes_y2, color='b')
hold on
plot(length_ap2(:, 1), length_y2, color='r')
hold on
plot(flow_ap2(:, 1), flow_y2, color='g')
hold on
plot(rand_ap2(:, 1), rand_y2, color='m')
hold on
plot(ap2(:, 1), y2, color='k')
hold off
fig = gcf;
title('MFD of region 2 with different methods of selecting links')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
legend('Most Lanes', 'Longest Length', 'Highest Avg. Flow', 'Random Sample', 'All links')
exportgraphics(fig, 'Figure_22.png', 'Resolution', 100)

plot(lanes_ap3(:, 1), lanes_y3, color='b')
hold on
plot(length_ap3(:, 1), length_y3, color='r')
hold on
plot(flow_ap3(:, 1), flow_y3, color='g')
hold on
plot(rand_ap3(:, 1), rand_y3, color='m')
hold on
plot(ap3(:, 1), y3, color='k')
hold off
fig = gcf;
title('MFD of region 3 with different methods of selecting links')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
legend('Most Lanes', 'Longest Length', 'Highest Avg. Flow', 'Random Sample', 'All links')
exportgraphics(fig, 'Figure_23.png', 'Resolution', 100)

plot(lanes_ap4(:, 1), lanes_y4, color='b')
hold on
plot(length_ap4(:, 1), length_y4, color='r')
hold on
plot(flow_ap4(:, 1), flow_y4, color='g')
hold on
plot(rand_ap4(:, 1), rand_y4, color='m')
hold on
plot(ap4(:, 1), y4, color='k')
hold off
fig = gcf;
title('MFD of region 4 with different methods of selecting links')
xlabel('Accumulation (veh)')
ylabel('Production (veh*km/h)')
legend('Most Lanes', 'Longest Length', 'Highest Avg. Flow', 'Random Sample', 'All links')
exportgraphics(fig, 'Figure_24.png', 'Resolution', 100)

[errors(1, 4), ~] = DiscreteFrechetDist([rand_ap1(:, 1), rand_y1], [ap1(:, 1), y1]);
[errors(2, 4), ~] = DiscreteFrechetDist([rand_ap2(:, 1), rand_y2], [ap2(:, 1), y2]);
[errors(3, 4), ~] = DiscreteFrechetDist([rand_ap3(:, 1), rand_y3], [ap3(:, 1), y3]);
[errors(4, 4), ~] = DiscreteFrechetDist([rand_ap4(:, 1), rand_y4], [ap4(:, 1), y4]);

% links(:, 8) = sum(accumulation, 1)';
% links(:, 8) = abs(links(:, 7) - mean(links(:, 7)));
% 
% [avg50_1, avg50_1_ind] = sortrows(links(links1, :), 8, 'ascend');
% avg50_1 = avg50_1(1:round(size(avg50_1, 1)/2), :);
% avg50_1_ind = avg50_1_ind(1:round(size(avg50_1_ind, 1)/2), :);
% avg50_1_names = links1(avg50_1_ind, 1);
% [avg50_2, avg50_2_ind] = sortrows(links(links2, :), 8, 'ascend');
% avg50_2 = avg50_2(1:round(size(avg50_2, 1)/2), :);
% avg50_2_ind = avg50_2_ind(1:round(size(avg50_2_ind, 1)/2), :);
% avg50_2_names = links2(avg50_2_ind, 1);
% [avg50_3, avg50_3_ind] = sortrows(links(links3, :), 8, 'ascend');
% avg50_3 = avg50_3(1:round(size(avg50_3, 1)/2), :);
% avg50_3_ind = avg50_3_ind(1:round(size(avg50_3_ind, 1)/2), :);
% avg50_3_names = links3(avg50_3_ind, 1);
% [avg50_4, avg50_4_ind] = sortrows(links(links4, :), 8, 'ascend');
% avg50_4 = avg50_4(1:round(size(avg50_4, 1)/2), :);
% avg50_4_ind = avg50_4_ind(1:round(size(avg50_4_ind, 1)/2), :);
% avg50_4_names = links4(avg50_4_ind, 1);
% 
% avg_ap1 = sum(accumulation(:, avg50_1_names), 2)*2;
% avg_ap2 = sum(accumulation(:, avg50_2_names), 2)*2;
% avg_ap3 = sum(accumulation(:, avg50_3_names), 2)*2;
% avg_ap4 = sum(accumulation(:, avg50_4_names), 2)*2;
% avg_ap1(:, 2) = sum(production(:, avg50_1_names), 2)*2;
% avg_ap2(:, 2) = sum(production(:, avg50_2_names), 2)*2;
% avg_ap3(:, 2) = sum(production(:, avg50_3_names), 2)*2;
% avg_ap4(:, 2) = sum(production(:, avg50_4_names), 2)*2;
% avg_ap1 = sortrows(avg_ap1, 1, 'ascend');
% avg_ap2 = sortrows(avg_ap2, 1, 'ascend');
% avg_ap3 = sortrows(avg_ap3, 1, 'ascend');
% avg_ap4 = sortrows(avg_ap4, 1, 'ascend');
% 
% [avg_p1, avg_S1, avg_mu1] = polyfit(avg_ap1(:, 1), avg_ap1(:, 2), 2);
% avg_y1 = polyval(avg_p1, avg_ap1(:, 1), [], avg_mu1);
% [avg_p2, avg_S2, avg_mu2] = polyfit(avg_ap2(:, 1), avg_ap2(:, 2), 2);
% avg_y2 = polyval(avg_p2, avg_ap2(:, 1), [], avg_mu2);
% [avg_p3, avg_S3, avg_mu3] = polyfit(avg_ap3(:, 1), avg_ap3(:, 2), 2);
% avg_y3 = polyval(avg_p3, avg_ap3(:, 1), [], avg_mu3);
% [avg_p4, avg_S4, avg_mu4] = polyfit(avg_ap4(:, 1), avg_ap4(:, 2), 2);
% avg_y4 = polyval(avg_p4, avg_ap4(:, 1), [], avg_mu4);
% 
% plot(lanes_ap1(:, 1), lanes_y1, color='b')
% hold on
% plot(length_ap1(:, 1), length_y1, color='r')
% hold on
% plot(flow_ap1(:, 1), flow_y1, color='g')
% hold on
% plot(avg_ap1(:, 1), avg_y1, color='m')
% hold on
% plot(ap1(:, 1), y1, color='k')
% hold off
% fig = gcf;
% title('MFD of region 1 with different methods of selecting links')
% xlabel('Accumulation (veh)')
% ylabel('Production (veh*km/h)')
% legend('Most Lanes', 'Longest Length', 'Highest Avg. Flow', 'Closest to Avg.', 'All links')
% exportgraphics(fig, 'Figure_6_1.png', 'Resolution', 100)
% 
% plot(lanes_ap2(:, 1), lanes_y2, color='b')
% hold on
% plot(length_ap2(:, 1), length_y2, color='r')
% hold on
% plot(flow_ap2(:, 1), flow_y2, color='g')
% hold on
% plot(avg_ap2(:, 1), avg_y2, color='m')
% hold on
% plot(ap2(:, 1), y2, color='k')
% hold off
% fig = gcf;
% title('MFD of region 2 with different methods of selecting links')
% xlabel('Accumulation (veh)')
% ylabel('Production (veh*km/h)')
% legend('Most Lanes', 'Longest Length', 'Highest Avg. Flow', 'Closest to Avg.', 'All links')
% exportgraphics(fig, 'Figure_6_2.png', 'Resolution', 100)
% 
% plot(lanes_ap3(:, 1), lanes_y3, color='b')
% hold on
% plot(length_ap3(:, 1), length_y3, color='r')
% hold on
% plot(flow_ap3(:, 1), flow_y3, color='g')
% hold on
% plot(avg_ap3(:, 1), avg_y3, color='m')
% hold on
% plot(ap3(:, 1), y3, color='k')
% hold off
% fig = gcf;
% title('MFD of region 3 with different methods of selecting links')
% xlabel('Accumulation (veh)')
% ylabel('Production (veh*km/h)')
% legend('Most Lanes', 'Longest Length', 'Highest Avg. Flow', 'Closest to Avg.', 'All links')
% exportgraphics(fig, 'Figure_6_3.png', 'Resolution', 100)
% 
% plot(lanes_ap4(:, 1), lanes_y4, color='b')
% hold on
% plot(length_ap4(:, 1), length_y4, color='r')
% hold on
% plot(flow_ap4(:, 1), flow_y4, color='g')
% hold on
% plot(avg_ap4(:, 1), avg_y4, color='m')
% hold on
% plot(ap4(:, 1), y4, color='k')
% hold off
% fig = gcf;
% title('MFD of region 4 with different methods of selecting links')
% xlabel('Accumulation (veh)')
% ylabel('Production (veh*km/h)')
% legend('Most Lanes', 'Longest Length', 'Highest Avg. Flow', 'Closest to Avg.', 'All links')
% exportgraphics(fig, 'Figure_6_4.png', 'Resolution', 100)
% 
% [errors(1, 5), ~] = DiscreteFrechetDist([avg_ap1(:, 1), avg_y1], [ap1(:, 1), y1]);
% [errors(2, 5), ~] = DiscreteFrechetDist([avg_ap2(:, 1), avg_y2], [ap1(:, 1), y2]);
% [errors(3, 5), ~] = DiscreteFrechetDist([avg_ap3(:, 1), avg_y3], [ap1(:, 1), y3]);
% [errors(4, 5), ~] = DiscreteFrechetDist([avg_ap4(:, 1), avg_y4], [ap1(:, 1), y4]);

xlswrite('FrechetDistance.xlsx', errors)

% STEP 7-1

occupancy1 = occupancy(2:end, links1 + 1);
occupancy2 = occupancy(2:end, links2 + 1);
occupancy3 = occupancy(2:end, links3 + 1);
occupancy4 = occupancy(2:end, links4 + 1);

edges = 0:10:100;

h60_1 = histcounts(occupancy1(40, :), edges);
h60_2 = histcounts(occupancy2(40, :), edges);
h60_3 = histcounts(occupancy3(40, :), edges);
h60_4 = histcounts(occupancy4(40, :), edges);

bar(edges(1:end-1), [h60_1; h60_2; h60_3; h60_4]')
hold off
fig = gcf;
title('Spatial Distribution at 60 min of regions 1 - 4')
xlabel('Occupancy (%)')
ylabel('Number of Links')
legend('Region 1', 'Region 2', 'Region 3', 'Region 4')
exportgraphics(fig, 'Figure_25.png', 'Resolution', 100)

h90_1 = histcounts(occupancy1(60, :), edges);
h90_2 = histcounts(occupancy2(60, :), edges);
h90_3 = histcounts(occupancy3(60, :), edges);
h90_4 = histcounts(occupancy4(60, :), edges);

bar(edges(1:end-1), [h90_1; h90_2; h90_3; h90_4]')
hold off
fig = gcf;
title('Spatial Distribution at 90 min of regions 1 - 4')
xlabel('Occupancy (%)')
ylabel('Number of Links')
legend('Region 1', 'Region 2', 'Region 3', 'Region 4')
exportgraphics(fig, 'Figure_26.png', 'Resolution', 100)

% STEP 7-2

% 4 regions

var_60_denom = (size(occupancy, 2) - 1)*var(occupancy(41, 2:end));
var_60_numer = size(occupancy1, 2)*var(occupancy1(40, :)) + size(occupancy2, 2)*var(occupancy2(40, :)) ...
    + size(occupancy3, 2)*var(occupancy3(40, :)) + size(occupancy4, 2)*var(occupancy4(40, :));

tv = var_60_numer/var_60_denom;

var_90_denom = (size(occupancy, 2) - 1)*var(occupancy(61, 2:end));
var_90_numer = size(occupancy1, 2)*var(occupancy1(60, :)) + size(occupancy2, 2)*var(occupancy2(60, :)) ...
    + size(occupancy3, 2)*var(occupancy3(60, :)) + size(occupancy4, 2)*var(occupancy4(60, :));

tv(1, 2) = var_90_numer/var_90_denom;

% 3 regions

var_60_denom = (size(occupancy, 2) - 1)*var(occupancy(41, 2:end));
var_60_numer = (size(occupancy1, 2) + size(occupancy4, 2))*var([occupancy1(40, :), occupancy4(40, :)]) ...
    + size(occupancy2, 2)*var(occupancy2(40, :)) + size(occupancy3, 2)*var(occupancy3(40, :));

tv(2, 1) = var_60_numer/var_60_denom;

var_90_denom = (size(occupancy, 2) - 1)*var(occupancy(61, 2:end));
var_90_numer = (size(occupancy1, 2) + size(occupancy4, 2))*var([occupancy1(60, :), occupancy4(60, :)]) ...
    + size(occupancy2, 2)*var(occupancy2(60, :)) + size(occupancy3, 2)*var(occupancy3(60, :));

tv(2, 2) = var_90_numer/var_90_denom;

var_60_denom = (size(occupancy, 2) - 1)*var(occupancy(41, 2:end));
var_60_numer = (size(occupancy1, 2) + size(occupancy3, 2))*var([occupancy1(40, :), occupancy3(40, :)]) ...
    + size(occupancy2, 2)*var(occupancy2(40, :)) + size(occupancy4, 2)*var(occupancy4(40, :));

tv(3, 1) = var_60_numer/var_60_denom;

var_90_denom = (size(occupancy, 2) - 1)*var(occupancy(61, 2:end));
var_90_numer = (size(occupancy1, 2) + size(occupancy3, 2))*var([occupancy1(60, :), occupancy3(60, :)]) ...
    + size(occupancy2, 2)*var(occupancy2(60, :)) + size(occupancy4, 2)*var(occupancy4(60, :));

tv(3, 2) = var_90_numer/var_90_denom;

% 2 regions

var_60_denom = (size(occupancy, 2) - 1)*var(occupancy(41, 2:end));
var_60_numer = (size(occupancy1, 2) + size(occupancy4, 2))*var([occupancy1(40, :), occupancy4(40, :)]) ...
    + (size(occupancy2, 2) + size(occupancy3, 2))*var([occupancy2(40, :), occupancy3(40, :)]);

tv(4, 1) = var_60_numer/var_60_denom;

var_90_denom = (size(occupancy, 2) - 1)*var(occupancy(61, 2:end));
var_90_numer = (size(occupancy1, 2) + size(occupancy4, 2))*var([occupancy1(60, :), occupancy4(60, :)]) ...
    + (size(occupancy2, 2) + size(occupancy3, 2))*var([occupancy2(60, :), occupancy3(60, :)]);

tv(4, 2) = var_90_numer/var_90_denom;

var_60_denom = (size(occupancy, 2) - 1)*var(occupancy(41, 2:end));
var_60_numer = (size(occupancy1, 2) + size(occupancy3, 2))*var([occupancy1(40, :), occupancy3(40, :)]) ...
    + (size(occupancy2, 2) + size(occupancy4, 2))*var([occupancy2(40, :), occupancy4(40, :)]);

tv(5, 1) = var_60_numer/var_60_denom;

var_90_denom = (size(occupancy, 2) - 1)*var(occupancy(61, 2:end));
var_90_numer = (size(occupancy1, 2) + size(occupancy3, 2))*var([occupancy1(60, :), occupancy3(60, :)]) ...
    + (size(occupancy2, 2) + size(occupancy4, 2))*var([occupancy2(60, :), occupancy4(60, :)]);

tv(5, 2) = var_90_numer/var_90_denom;

% 1 region

var_60_denom = (size(occupancy, 2) - 1)*var(occupancy(41, 2:end));
var_60_numer = (size(occupancy1, 2) + size(occupancy3, 2) + size(occupancy2, 2) + size(occupancy4, 2))...
    *var([occupancy1(40, :), occupancy3(40, :), occupancy2(40, :), occupancy4(40, :)]);

tv(6, 1) = var_60_numer/var_60_denom;

var_90_denom = (size(occupancy, 2) - 1)*var(occupancy(61, 2:end));
var_90_numer = (size(occupancy1, 2) + size(occupancy3, 2) + size(occupancy2, 2) + size(occupancy4, 2))...
    *var([occupancy1(60, :), occupancy3(60, :), occupancy2(60, :), occupancy4(60, :)]);

tv(6, 2) = var_90_numer/var_90_denom;

xlswrite('total_variance.xlsx', tv)

% STEP 7-3

adj.links1 = zeros(length(nodes), length(nodes));
adj.links2 = zeros(length(nodes), length(nodes));
adj.links3 = zeros(length(nodes), length(nodes));
adj.links4 = zeros(length(nodes), length(nodes));
for i = 1:size(links1, 1)
    orig = find(nodes(:, 1) == links(links1(i), 4));
    dest = find(nodes(:, 1) == links(links1(i), 5));
    adj.links1(orig, dest) = 1;
end
for i = 1:size(links2, 1)
    orig = find(nodes(:, 1) == links(links2(i), 4));
    dest = find(nodes(:, 1) == links(links2(i), 5));
    adj.links2(orig, dest) = 1;
end
for i = 1:size(links3, 1)
    orig = find(nodes(:, 1) == links(links3(i), 4));
    dest = find(nodes(:, 1) == links(links3(i), 5));
    adj.links3(orig, dest) = 1;
end
for i = 1:size(links4, 1)
    orig = find(nodes(:, 1) == links(links4(i), 4));
    dest = find(nodes(:, 1) == links(links4(i), 5));
    adj.links4(orig, dest) = 1;
end

gplotdc(adj.links1, nodes(:, 2:3), 1, 0)
hold on
gplotdc(adj.links2, nodes(:, 2:3), 2, 0)
hold on
gplotdc(adj.links3, nodes(:, 2:3), 3, 0)
hold on
gplotdc(adj.links4, nodes(:, 2:3), 4, 0)
hold off
fig = gcf;
title('Map of Regions 1 - 4')
legend('', 'Region 1', '', '', 'Region 2', '', '', 'Region 3', '', '', 'Region 4')
exportgraphics(fig, 'Figure_27.png', 'Resolution', 100)

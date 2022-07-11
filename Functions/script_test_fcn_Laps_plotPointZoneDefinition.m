% script_test_fcn_Laps_plotPointZoneDefinition.m.m
% Tests fcn_Laps_plotPointZoneDefinition.m
       
% Revision history:
%      2022_04_10
%      -- first write of the code

close all
clc

%% Call the plot command to show how it works. First, put it into our figure
% to show that it will auto-label the axes and create a new figure (NOT
% figure 11 here) to plot the data.
figure(11);
plot_style = 'g-';
zone_center = [1 2];
zone_radius = 5;
fcn_Laps_plotPointZoneDefinition(zone_center,zone_radius,plot_style);

%% Show that the fig_num option works
fig_num = 11121;
plot_style = 'g-.';
fcn_Laps_plotPointZoneDefinition(zone_center,zone_radius,plot_style,fig_num);

%% Call to show coloring
fig_num = 11122;
plot_style = 'r-';
fcn_Laps_plotPointZoneDefinition(zone_center,zone_radius,plot_style,fig_num);

%% Call to plot style can be empty (defaults to green solid)
fig_num = 11123;
plot_style = [];
fcn_Laps_plotPointZoneDefinition(zone_center,zone_radius,plot_style,fig_num);
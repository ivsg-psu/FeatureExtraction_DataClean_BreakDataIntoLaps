% script_test_fcn_Laps_plotPointZoneDefinition.m.m
% Tests fcn_Laps_plotPointZoneDefinition.m
       
% Revision history:
%      2022_04_10
%      -- first write of the code
%      2022_07_23 S. Brennan, sbrennan@psu.edu
%      -- more examples

close all

%% Call the plot command to show how it works. 
fig_num = 1;
figure(fig_num);
clf;

% Demonstrate that defaults work
zone_center = [1 2];
num_points = 3;
zone_radius = 5;
zone_definition = [zone_radius num_points zone_center];
fcn_Laps_plotPointZoneDefinition(zone_definition);

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% Show specification of plot style. 
fig_num = 2;
figure(fig_num);
clf;

% Demonstrate that defaults work
zone_center = [1 2];
num_points = 3;
zone_radius = 5;
zone_definition = [zone_radius num_points zone_center];
fcn_Laps_plotPointZoneDefinition(zone_definition,'r-');

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% Show specification of figure without plot style. 
fig_num = 3;
figure(fig_num);
clf;

% Demonstrate that defaults work
zone_center = [1 2];
num_points = 3;
zone_radius = 5;
zone_definition = [zone_radius num_points zone_center];
fcn_Laps_plotPointZoneDefinition(zone_definition,[],fig_num);

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% Show zone, plot style, and fig number together. Note that the plotting goes to the user-specified figure
fig_num = 4;
figure(fig_num);
clf;

figure(11);
plot_style = 'g-';
zone_center = [1 2];
num_points = 3;
zone_radius = 5;
zone_definition = [zone_radius num_points zone_center];
fcn_Laps_plotPointZoneDefinition(zone_definition,plot_style, fig_num);

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% Show that the fig_num option works
fig_num = 5;
figure(fig_num);
clf;

plot_style = 'g-.';
zone_center = [1 2];
num_points = 3;
zone_radius = 5;
zone_definition = [zone_radius num_points zone_center];
fcn_Laps_plotPointZoneDefinition(zone_definition,plot_style,fig_num);

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

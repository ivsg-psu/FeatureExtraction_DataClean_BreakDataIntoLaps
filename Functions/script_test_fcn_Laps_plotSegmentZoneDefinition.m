% script_test_fcn_Laps_plotSegmentZoneDefinition.m
% Tests fcn_Laps_plotSegmentZoneDefinition.m
       
% Revision history:
%      2022_04_10
%      -- first write of the code
%      2022_07_23
%      -- more examples

close all

%% Call the plot command to show how it works. 
fig_num = 1;
figure(fig_num);
clf;

% For it to use defaults
fcn_Laps_plotSegmentZoneDefinition([1 2; 3 4], [], fig_num);
axis([-5 5 -5 5]);

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% Call the plot command without figure number to show it defaults to last figure
fig_num = 2;
figure(fig_num);
clf;

% For it to use defaults
fcn_Laps_plotSegmentZoneDefinition([1 2; 3 4]);
axis([-5 5 -5 5]);

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% Show that can set the color
fig_num = 3;
figure(fig_num);
clf;


% First, put it into our figure
% to show that it will auto-label the axes and create a new figure (NOT
% figure 11 here) to plot the data.
figure(11);
plot_style = 'b.-';
fcn_Laps_plotSegmentZoneDefinition([1 2; 3 4],plot_style,fig_num);
axis([-5 5 -5 5]);

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% Show that can set the figure without specifying plot color
fig_num = 4;
figure(fig_num);
clf;


% leave the plot style empty
fcn_Laps_plotSegmentZoneDefinition([1 2; 3 4],[],fig_num);
axis([-5 5 -5 5]);

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% Call the plot command to show how it works. First, put it into our figure
fig_num_wrong = 5;
figure(fig_num_wrong);
clf;

% to show that it will auto-label the axes and create a new figure (NOT
% figure 11 here) to plot the data.
fig_num = 11121;
plot_style = 'g.-.';
fcn_Laps_plotSegmentZoneDefinition([1 2; 3 4],plot_style,fig_num);

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% Call to show coloring
fig_num = 6;
figure(fig_num);
clf;

plot_style = 'r.-';
fcn_Laps_plotSegmentZoneDefinition([1 2; 3 4],plot_style,fig_num);

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

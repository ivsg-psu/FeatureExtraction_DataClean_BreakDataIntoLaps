% script_test_fcn_Laps_plotTraversalsXY.m
% Tests fcn_Laps_plotLapsXY
       
% Revision history:
%      2022_04_02
%      -- first write of the code

close all


%% Call the plot command to show how it works. First, put it into our figure
fig_num = 1;
figure(fig_num);
clf;

% Fill in some dummy data
laps = fcn_Laps_fillSampleLaps;
 

% Convert laps into traversals
for i_traveral = 1:length(laps)
    traversal = fcn_Path_convertPathToTraversalStructure(laps{i_traveral});
    data.traversal{i_traveral} = traversal;
end


% to show that it will auto-label the axes and create a new figure (NOT
% figure 11 here) to plot the data.
fcn_Laps_plotLapsXY(data);

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% Next, specify the figure number to show that it will NOT auto-label
fig_num = 2;
figure(fig_num);
clf;

% Fill in some dummy data
laps = fcn_Laps_fillSampleLaps;
 

% Convert laps into traversals
for i_traveral = 1:length(laps)
    traversal = fcn_Path_convertPathToTraversalStructure(laps{i_traveral});
    data.traversal{i_traveral} = traversal;
end


figure(11);
% axes if figure is already given and it puts the plots into this figure.
fcn_Laps_plotLapsXY(data,fig_num);

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

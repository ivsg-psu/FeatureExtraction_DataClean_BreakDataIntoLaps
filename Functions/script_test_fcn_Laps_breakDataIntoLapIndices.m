% script_test_fcn_Laps_breakDataIntoLapIndices.m
% tests fcn_Laps_breakDataIntoLapIndices.m

% Revision history
%     2022_07_23 - sbrennan@psu.edu
%     -- wrote the code originally, using breakDataIntoLaps as starter

%% Set up the workspace
close all
clear laps_array data single_lap



%% Call the function to show it operating on the 9th data set

fig_num = 9001;
figure(fig_num);
clf;

dataSetNumber = 9;

% Load some test data 
tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);

start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
excursion_definition = []; % empty

[cell_array_of_lap_indices, ...
    cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
    fcn_Laps_breakDataIntoLapIndices(...
    tempXYdata,...
    start_definition,...
    end_definition,...
    excursion_definition,...
    fig_num);

% Do we get 3 laps?
assert(isequal(3,length(cell_array_of_entry_indices)));

% Are the laps starting at expected points?
assert(isequal(2,min(cell_array_of_lap_indices{1})));
assert(isequal(102,min(cell_array_of_lap_indices{2})));
assert(isequal(215,min(cell_array_of_lap_indices{3})));

% Are the laps ending at expected points?
assert(isequal(88,max(cell_array_of_lap_indices{1})));
assert(isequal(199,max(cell_array_of_lap_indices{2})));
assert(isequal(293,max(cell_array_of_lap_indices{3})));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));


% Plot the results
if 1==0
    fig_num = 9901;
    INTERNAL_plot_results(tempXYdata,cell_array_of_entry_indices,cell_array_of_lap_indices,cell_array_of_exit_indices,fig_num);
end

%% Show how a lap is missed if start zone is not big enough, 9th example data
fig_num = 9002;
figure(fig_num);
clf;

dataSetNumber = 9;

% Load some test data 
tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);

start_definition = [6 3 0 0]; % Radius 10, 3 points must pass near [0,0]
end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
excursion_definition = []; % empty

[cell_array_of_lap_indices, ...
    cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
    fcn_Laps_breakDataIntoLapIndices(...
    tempXYdata,...
    start_definition,...
    end_definition,...
    excursion_definition,...
    fig_num);

% Do we get 2 laps?
assert(isequal(2,length(cell_array_of_entry_indices)));

% Are the laps starting at expected points?
assert(isequal(3,min(cell_array_of_lap_indices{1})));
assert(isequal(216,min(cell_array_of_lap_indices{2})));

% Are the laps ending at expected points?
assert(isequal(88,max(cell_array_of_lap_indices{1})));
assert(isequal(293,max(cell_array_of_lap_indices{2})));


% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));


% Plot the results
if 1==0
    fig_num = 9902;
    INTERNAL_plot_results(tempXYdata,cell_array_of_entry_indices,cell_array_of_lap_indices,cell_array_of_exit_indices,fig_num);
end

%% Show the use of segment definition, 9th example data
fig_num = 9003;
figure(fig_num);
clf;

dataSetNumber = 9;

% Load some test data 
tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);

start_definition = [10 0; -10 0]; % start at [10 0], end at [-10 0]
end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
excursion_definition = []; % empty
[cell_array_of_lap_indices, ...
    cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
    fcn_Laps_breakDataIntoLapIndices(...
    tempXYdata,...
    start_definition,...
    end_definition,...
    excursion_definition,...
    fig_num);

% Do we get 3 laps?
assert(isequal(3,length(cell_array_of_entry_indices)));

% Are the laps starting at expected points?
assert(isequal(3,min(cell_array_of_lap_indices{1})));
assert(isequal(103,min(cell_array_of_lap_indices{2})));
assert(isequal(216,min(cell_array_of_lap_indices{3})));

% Are the laps ending at expected points?
assert(isequal(88,max(cell_array_of_lap_indices{1})));
assert(isequal(199,max(cell_array_of_lap_indices{2})));
assert(isequal(293,max(cell_array_of_lap_indices{3})));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));


% Plot the results
if 1==0
    fig_num = 9903;
    INTERNAL_plot_results(tempXYdata,cell_array_of_entry_indices,cell_array_of_lap_indices,cell_array_of_exit_indices,fig_num);
end

%% Call the function to show it operating on the 9th data set, NO PLOTTING, FAST MODE
fig_num = 9004;
figure(fig_num);
close(fig_num);

dataSetNumber = 9;

% Load some test data 
tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);

start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
excursion_definition = []; % empty

[cell_array_of_lap_indices, ...
    cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
    fcn_Laps_breakDataIntoLapIndices(...
    tempXYdata,...
    start_definition,...
    end_definition,...
    excursion_definition,...
    -1);

% Do we get 3 laps?
assert(isequal(3,length(cell_array_of_entry_indices)));

% Are the laps starting at expected points?
assert(isequal(2,min(cell_array_of_lap_indices{1})));
assert(isequal(102,min(cell_array_of_lap_indices{2})));
assert(isequal(215,min(cell_array_of_lap_indices{3})));

% Are the laps ending at expected points?
assert(isequal(88,max(cell_array_of_lap_indices{1})));
assert(isequal(199,max(cell_array_of_lap_indices{2})));
assert(isequal(293,max(cell_array_of_lap_indices{3})));

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==fig_num));


% Plot the results
if 1==0
    fig_num = 9904;
    INTERNAL_plot_results(tempXYdata,cell_array_of_entry_indices,cell_array_of_lap_indices,cell_array_of_exit_indices,fig_num);
end

%% Call the function to show it operating on the 9th data set, NO PLOTTING
fig_num = 9005;
figure(fig_num);
close(fig_num);

dataSetNumber = 9;

% Load some test data 
tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);

start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
excursion_definition = []; % empty

[cell_array_of_lap_indices, ...
    cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
    fcn_Laps_breakDataIntoLapIndices(...
    tempXYdata,...
    start_definition,...
    end_definition,...
    excursion_definition,...
    []);

% Do we get 3 laps?
assert(isequal(3,length(cell_array_of_entry_indices)));

% Are the laps starting at expected points?
assert(isequal(2,min(cell_array_of_lap_indices{1})));
assert(isequal(102,min(cell_array_of_lap_indices{2})));
assert(isequal(215,min(cell_array_of_lap_indices{3})));

% Are the laps ending at expected points?
assert(isequal(88,max(cell_array_of_lap_indices{1})));
assert(isequal(199,max(cell_array_of_lap_indices{2})));
assert(isequal(293,max(cell_array_of_lap_indices{3})));

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==fig_num));


% Plot the results
if 1==0
    fig_num = 9905;
    INTERNAL_plot_results(tempXYdata,cell_array_of_entry_indices,cell_array_of_lap_indices,cell_array_of_exit_indices,fig_num);
end

%% Call the function with 8th example data
fig_num = 8001;
figure(fig_num);
clf;

dataSetNumber = 8;

% Load some test data 
tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);

start_definition = [0 -10; 0 10]; % Line segment
end_definition = [90 0; 110 0]; % Line segment
excursion_definition = []; % empty

fig_num = 5;
[cell_array_of_lap_indices, ...
    cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
    fcn_Laps_breakDataIntoLapIndices(...
    tempXYdata,...
    start_definition,...
    end_definition,...
    excursion_definition,...
    fig_num);

% Do we get 3 laps?
assert(isequal(3,length(cell_array_of_entry_indices)));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));


% Plot the results
if 1==0
    fig_num = 8801;
    INTERNAL_plot_results(tempXYdata,cell_array_of_entry_indices,cell_array_of_lap_indices,cell_array_of_exit_indices,fig_num);
end

%% Call the function to show it operating, 8th data set
fig_num = 8002;
figure(fig_num);
clf;

dataSetNumber = 8;

% Load some test data 
tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);

start_definition = [0 10; 0 -10]; % Line segment, flipped direction
end_definition = [90 0; 110 0]; % Line segment
excursion_definition = []; % empty

[cell_array_of_lap_indices, ...
    cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
    fcn_Laps_breakDataIntoLapIndices(...
    tempXYdata,...
    start_definition,...
    end_definition,...
    excursion_definition,...
    fig_num);

% Do we get 3 laps?
assert(isequal(3,length(cell_array_of_entry_indices)));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

% Plot the results
if 1==0
    fig_num = 8802;
    INTERNAL_plot_results(tempXYdata,cell_array_of_entry_indices,cell_array_of_lap_indices,cell_array_of_exit_indices,fig_num);
end

%% Use a new set of laps data, 5th data set
fig_num = 5001;
figure(fig_num);
clf;

dataSetNumber = 5;

% Load some test data 
tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);

start_definition = [20 0; -20 0]; % Line segment
end_definition = [-120 0; -80 0]; % Line segment
excursion_definition = []; % empty

[cell_array_of_lap_indices, ...
    cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
    fcn_Laps_breakDataIntoLapIndices(...
    tempXYdata,...
    start_definition,...
    end_definition,...
    excursion_definition,...
    fig_num);

% Do we get 3 laps?
assert(isequal(3,length(cell_array_of_entry_indices)));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

% Plot the results
if 1==0
    fig_num = 5501;
    INTERNAL_plot_results(tempXYdata,cell_array_of_entry_indices,cell_array_of_lap_indices,cell_array_of_exit_indices,fig_num);
end

%% Call the function to show it gives nothing if line segments are backwards, 5th data set
fig_num = 5002;
figure(fig_num);
clf;

dataSetNumber = 5;

% Load some test data 
tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);

start_definition = [20 0; -20 0]; % Line segment
end_definition = [ -80 0; -120 0;]; % Line segment
excursion_definition = []; % empty

[cell_array_of_lap_indices, ...
    cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
    fcn_Laps_breakDataIntoLapIndices(...
    tempXYdata,...
    start_definition,...
    end_definition,...
    excursion_definition,...
    fig_num);

% Do we get 0 laps?
assert(isequal(0,length(cell_array_of_entry_indices)));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

% Plot the results
if 1==0
    fig_num = 5502;
    INTERNAL_plot_results(tempXYdata,cell_array_of_entry_indices,cell_array_of_lap_indices,cell_array_of_exit_indices,fig_num);
end

%% Use a new set of laps data, 6th data set
fig_num = 6001;
figure(fig_num);
clf;

dataSetNumber = 6;

% Load some test data 
tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);

% Call the function to show it operating
start_definition = [20 0; -20 0]; % Line segment
end_definition = [-120 0; -80 0]; % Line segment
excursion_definition = []; % empty

[cell_array_of_lap_indices, ...
    cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
    fcn_Laps_breakDataIntoLapIndices(...
    tempXYdata,...
    start_definition,...
    end_definition,...
    excursion_definition,...
    fig_num);

% Do we get 3 laps?
assert(isequal(3,length(cell_array_of_entry_indices)));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

% Plot the results
if 1==0
    fig_num = 6601;
    INTERNAL_plot_results(tempXYdata,cell_array_of_entry_indices,cell_array_of_lap_indices,cell_array_of_exit_indices,fig_num);
end

%% Call the function to show gives weird results with repeated start overlaps
fig_num = 6002;
figure(fig_num);
clf;

dataSetNumber = 6;

% Load some test data 
tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);

start_definition = [20 0; -20 0]; % Line segment
end_definition = []; % empty
excursion_definition = []; % empty

[cell_array_of_lap_indices, ...
    cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
    fcn_Laps_breakDataIntoLapIndices(...
    tempXYdata,...
    start_definition,...
    end_definition,...
    excursion_definition,...
    fig_num);

% Do we get 3 laps?
assert(isequal(6,length(cell_array_of_entry_indices)));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

% Plot the results
if 1==0
    fig_num = 6602;
    INTERNAL_plot_results(tempXYdata,cell_array_of_entry_indices,cell_array_of_lap_indices,cell_array_of_exit_indices,fig_num);
end




%% Check assertions for basic path operations and function testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              _   _                 
%      /\                     | | (_)                
%     /  \   ___ ___  ___ _ __| |_ _  ___  _ __  ___ 
%    / /\ \ / __/ __|/ _ \ '__| __| |/ _ \| '_ \/ __|
%   / ____ \\__ \__ \  __/ |  | |_| | (_) | | | \__ \
%  /_/    \_\___/___/\___|_|   \__|_|\___/|_| |_|___/
%                                                    
%                                                    
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Assertions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% This one returns nothing since there is no portion of the path in the
% % criteria
% traversal = fcn_Path_convertPathToTraversalStructure([-1 1; 1 1]);
% start_definition = [0.2 3 0 0]; % Located at [0,0] with radius 0.2, 3 points
% 
% [lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLapIndices(...
%     traversal,...
%     start_definition);
% 
% assert(isempty(lap_traversals));
% assert(isequal(entry_traversal,traversal));
% assert(isempty(exit_traversal));
% 
% %% This one returns nothing since there is one point in criteria
% traversal = fcn_Path_convertPathToTraversalStructure([-1 1; 0 0; 1 1]);
% start_definition = [0.2 3 0 0]; % Located at [0,0] with radius 0.2, 3 points
% [lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLapIndices(...
%     traversal,...
%     start_definition);
% 
% assert(isempty(lap_traversals));
% assert(isequal(entry_traversal,traversal));
% assert(isempty(exit_traversal));
% 
% %% This one returns nothing since there is only two points in criteria
% traversal = fcn_Path_convertPathToTraversalStructure([-1 1; 0 0; 0.1 0; 1 1]);
% start_definition = [0.2 3 0 0]; % Located at [0,0] with radius 0.2, 3 points
% [lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLapIndices(...
%     traversal,...
%     start_definition);
% 
% assert(isempty(lap_traversals));
% assert(isequal(entry_traversal,traversal));
% assert(isempty(exit_traversal));
% 
% %% This one returns nothing since the minimum point is at the start
% % and so there is no strong minimum inside the zone
% traversal = fcn_Path_convertPathToTraversalStructure([-1 1; 0 0; 0.01 0; 0.02 0; 0.03 0; 1 1]);
% start_definition = [0.2 3 0 0]; % Located at [0,0] with radius 0.2, 3 points
% [lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLapIndices(...
%     traversal,...
%     start_definition);
% 
% assert(isempty(lap_traversals));
% assert(isequal(entry_traversal,traversal));
% assert(isempty(exit_traversal));
% 
% %% This one returns nothing since the minimum point is at the end
% % and so there is no strong minimum inside the zone
% traversal = fcn_Path_convertPathToTraversalStructure([-1 1; -0.03 0; -0.02 0; -0.01 0; 0 0; 1 1]);
% start_definition = [0.2 3 0 0]; % Located at [0,0] with radius 0.2, 3 points
% [lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLapIndices(...
%     traversal,...
%     start_definition);
% 
% assert(isempty(lap_traversals));
% assert(isequal(entry_traversal,traversal));
% assert(isempty(exit_traversal));
% 
% %% This one returns nothing since the path doesn't come back to start
% % There is no end after the start
% fig_num = 123;
% traversal = fcn_Path_convertPathToTraversalStructure([-1 1; -0.03 0; -0.02 0; 0 0; 0.1 0; 1 1]);
% start_definition = [0.2 3 0 0]; % Located at [0,0] with radius 0.2, 3 points
% 
% [lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLapIndices(...
%     traversal,...
%     start_definition,...
%     [],...
%     [],...
%     fig_num);
% 
% assert(isempty(lap_traversals));
% assert(isequal(entry_traversal,traversal));
% assert(isempty(exit_traversal));
% 
% %% This one returns nothing since the end is incomplete
% fig_num = 123;
% 
% % Create some data to plot
% full_steps = (-1:0.1:1)';
% zero_full_steps = 0*full_steps;
% half_steps = (-1:0.1:0)';
% zero_half_steps = 0*half_steps;
% 
% traversal = fcn_Path_convertPathToTraversalStructure(...
%     [full_steps zero_full_steps; zero_half_steps half_steps]);
% 
% start_definition = [0.2 3 0 0]; % Located at [0,0] with radius 0.2, 3 points
% 
% [lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLapIndices(...
%     traversal,...
%     start_definition,...
%     [],...
%     [],...
%     fig_num);
% 
% assert(isempty(lap_traversals));
% assert(isequal(entry_traversal,traversal));
% assert(isempty(exit_traversal));
% 
% %% Show that the start and end points can overlap by their boundaries
% fig_num = 1234;
% 
% traversal = fcn_Path_convertPathToTraversalStructure(...
%     [full_steps zero_full_steps]);
% start_definition = [0.5 3 -0.5 0]; % Located at [-0.5,0] with radius 0.5, 3 points
% end_definition = [0.5 3 0.5 0]; % Located at [0.5,0] with radius 0.5, 3 points
% 
% [lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLapIndices(...
%     traversal,...
%     start_definition,...
%     end_definition,...
%     [],...
%     fig_num);
% 
% % Do we get 1 laps?
% assert(isequal(1,length(lap_traversals.traversal)));
% 
% 
% %% Show that the start and end points can be at the absolute ends
% fig_num = 1234;
% 
% traversal = fcn_Path_convertPathToTraversalStructure(...
%     [full_steps zero_full_steps]);
% 
% start_definition = [0.5 3 -1 0]; % Located at [-1,0] with radius 0.5, 3 points
% end_definition = [0.5 3 1 0]; % Located at [1,0] with radius 0.5, 3 points
% 
% [lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLapIndices(...
%     traversal,...
%     start_definition,...
%     end_definition,...
%     [],...
%     fig_num);
% 
% % Do we get 1 laps?
% assert(isequal(1,length(lap_traversals.traversal)));


%% Fail conditions
if 1==0
    %
    %     %% Fails because start_definition is not correct type
    %     clc
    %     start_definition = [1 2];
    %     [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLapIndices(...
    %         single_lap.traversal{1},...
    %         start_definition); %#ok<*ASGLU>
    %
    %     %% Fails because start_definition is not correct type
    %     % Radius input is negative
    %     clc
    %     start_definition = [-1 2 3 4];
    %     [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLapIndices(...
    %         single_lap.traversal{1},...
    %         start_definition);
    %
    %     %% Fails because start_definition is not correct type
    %     % Radius input is negative
    %     clc
    %     start_definition = [0 2 3 4];
    %     [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLapIndices(...
    %         single_lap.traversal{1},...
    %         start_definition);
    %
    %     %% Fails because start_definition is not correct type
    %     % Num_inputs input is not positive
    %     clc
    %     start_definition = [1 0 3 4];
    %     [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLapIndices(...
    %         single_lap.traversal{1},...
    %         start_definition);
    %
    %     %% Warning because start_definition is 3D not 2D
    %     % Start_zone definition is a 3D point [radius num_points X Y Z]
    %     clc
    %     start_definition = [1 2 3 4 5];
    %     [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLapIndices(...
    %         single_lap.traversal{1},...
    %         start_definition);
    %
    %     %% Warning because start_definition is 3D not 2D
    %     % Start_zone definition is a 3D point [X Y Z; X Y Z]
    %     clc
    %     start_definition = [1 2 3; 4 5 6];
    %     [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLapIndices(...
    %         single_lap.traversal{1},...
    %         start_definition);
    %
    %     %% Warning because end_definition is 3D not 2D
    %     % End_zone definition is a 3D point [radius num_points X Y Z]
    %     clc
    %     start_definition = [1 2 3 4];
    %     end_definition = [1 2 3 4 5];
    %
    %     [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLapIndices(...
    %         single_lap.traversal{1},...
    %         start_definition,...
    %         end_definition);
    %
    %     %% Warning because excursion_definition is 3D not 2D
    %     % Excursion_zone definition is a 3D point [radius num_points X Y Z]
    %     clc
    %     start_definition = [1 2 3 4];
    %     end_definition = [1 2 3 4];
    %     excursion_definition = [1 2 3 4 5];
    %
    %     [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLapIndices(...
    %         single_lap.traversal{1},...
    %         start_definition,...
    %         end_definition,...
    %         excursion_definition);
end

function INTERNAL_plot_results(tempXYdata,cell_array_of_entry_indices,cell_array_of_lap_indices,cell_array_of_exit_indices,fig_num)
figure(fig_num);
clf

% Make first subplot
subplot(1,3,1);  
axis square
hold on;
title('Laps');
legend_text = {};
    
for ith_lap = 1:length(cell_array_of_lap_indices)
    plot(tempXYdata(cell_array_of_lap_indices{ith_lap},1),tempXYdata(cell_array_of_lap_indices{ith_lap},2),'.-','Linewidth',3);
    legend_text = [legend_text, sprintf('Lap %d',ith_lap)]; %#ok<AGROW>    
end
h_legend = legend(legend_text);
set(h_legend,'AutoUpdate','off');
temp1 = axis;

% Make second subplot
subplot(1,3,2);  
axis square
hold on;
title('Entry');
legend_text = {};
    
for ith_lap = 1:length(cell_array_of_entry_indices)
    plot(tempXYdata(cell_array_of_entry_indices{ith_lap},1),tempXYdata(cell_array_of_entry_indices{ith_lap},2),'.-','Linewidth',3);
    legend_text = [legend_text, sprintf('Lap %d',ith_lap)]; %#ok<AGROW>    
end
h_legend = legend(legend_text);
set(h_legend,'AutoUpdate','off');
temp2 = axis;

% Make third subplot
subplot(1,3,3);  
axis square
hold on;
title('Exit');
legend_text = {};
    
for ith_lap = 1:length(cell_array_of_exit_indices)
    plot(tempXYdata(cell_array_of_exit_indices{ith_lap},1),tempXYdata(cell_array_of_exit_indices{ith_lap},2),'.-','Linewidth',3);
    legend_text = [legend_text, sprintf('Lap %d',ith_lap)]; %#ok<AGROW>    
end
h_legend = legend(legend_text);
set(h_legend,'AutoUpdate','off');
temp3 = axis;

% Set all axes to same value, maximum range
max_axis = max([temp1; temp2; temp3]);
min_axis = min([temp1; temp2; temp3]);
good_axis = [min_axis(1) max_axis(2) min_axis(3) max_axis(4)];
subplot(1,3,1); axis(good_axis);
subplot(1,3,2); axis(good_axis);
subplot(1,3,3); axis(good_axis);


end


%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§
%% fcn_INTERNAL_loadExampleData
function tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber)
% Call the function to fill in an array of "path" type
laps_array = fcn_Laps_fillSampleLaps(-1);


% Convert paths to traversals structures. Each traversal instance is a
% "traversal" type, and the array called "data" below is a "traversals"
% type.
for i_Path = 1:length(laps_array)
    traversal = fcn_Path_convertPathToTraversalStructure(laps_array{i_Path});
    data.traversal{i_Path} = traversal;
end

% Plot the last one
if 1==0
    example_lap_data = data.traversal{dataSetNumber};
    fig_num = 999;
    fcn_Laps_plotLapsXY(example_lap_data,fig_num);
end

% Use the last data
tempXYdata = laps_array{dataSetNumber};
end % Ends fcn_INTERNAL_loadExampleData
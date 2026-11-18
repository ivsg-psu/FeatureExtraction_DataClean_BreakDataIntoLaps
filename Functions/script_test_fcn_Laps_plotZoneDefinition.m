% script_test_fcn_Laps_plotZoneDefinition.m.m
% Tests fcn_Laps_plotZoneDefinition.m.m
       
% REVISION HISTORY:
%
% 2022_07_23 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_Laps_plotZoneDefinition
%   % * First write of the code, based on fcn_Laps_plotSegmentZoneDefinition
% 
% 2025_07_03 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_Laps_plotZoneDefinition
%   % * Standardized headers on all test scripts
%
% 2026_11_18 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_Laps_plotZoneDefinition
%   % * Standardized header comments into current convention
%   % * Variable renaming to avoid underscores
%   % * Test case 10002 titled "defaults to last figure", but its 
%   %   % assertion actually checks that a new figure opened, 
%   %   % so the test is incorrect. This is fixed.
%   % * Added tests of cellArrayOfPlotHandles
%   % * Tightened handle checks: both returned handles must be valid
%   %   % graphics objects in the expected figure (fcn_INTERNAL_checkPlotHandles)
%   % * Added case 10007: point zone without figNum, segment zone with -1
%   % * Converted calls to Name=Value optional inputs (PlotStyle, FigNum)

% TO-DO:
%
% 2025_11_21 by Sean Brennan, sbrennan@psu.edu
% - (fill in items here)


%% Set up the workspace
close all

%% Code demos start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____                              ____   __    _____          _
%  |  __ \                            / __ \ / _|  / ____|        | |
%  | |  | | ___ _ __ ___   ___  ___  | |  | | |_  | |     ___   __| | ___
%  | |  | |/ _ \ '_ ` _ \ / _ \/ __| | |  | |  _| | |    / _ \ / _` |/ _ \
%  | |__| |  __/ | | | | | (_) \__ \ | |__| | |   | |___| (_) | (_| |  __/
%  |_____/ \___|_| |_| |_|\___/|___/  \____/|_|    \_____\___/ \__,_|\___|
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Demos%20Of%20Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 1

close all;
fprintf(1,'Figure: 1XXXXXX: DEMO cases\n');

%% DEMO case: Basic demo
figNum = 10001;
titleString = sprintf('DEMO case: Basic demo');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill in some working data
segment_zone_definition = [1 2; 3 4]; % Starts at 1,2 and ends at 3,4

cellArrayOfPlotHandles = fcn_Laps_plotZoneDefinition(segment_zone_definition);
axis([-5 5 -5 5]);

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(cellArrayOfPlotHandles));

% Check variable sizes
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, 2, figNum);

% Check variable values
% Are the laps starting at expected points?

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: Show default point zone 
figNum = 10002;
titleString = sprintf('DEMO case: Show default point zone');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;


zone_center = [-1 2];
num_points = 3;
zone_radius = 2;
point_zone_definition = [zone_radius num_points zone_center];

cellArrayOfPlotHandles = fcn_Laps_plotZoneDefinition(point_zone_definition, FigNum=figNum);
axis([-5 5 -5 5]);

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(cellArrayOfPlotHandles));

% Check variable sizes
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, 2, figNum);

% Check variable values
% Are the laps starting at expected points?

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: Show that can set the color segment zone
figNum = 10003;
titleString = sprintf('DEMO case: Show that can set the color segment zone');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill in some working data
segment_zone_definition = [1 2; 3 4]; % Starts at 1,2 and ends at 3,4

cellArrayOfPlotHandles = fcn_Laps_plotZoneDefinition(segment_zone_definition, PlotStyle='r', FigNum=figNum);
axis([-5 5 -5 5]);

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(cellArrayOfPlotHandles));

% Check variable sizes
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, 2, figNum);

% Check variable values
% Are the laps starting at expected points?

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: Show that can set the color point zone
figNum = 10004;
titleString = sprintf('DEMO case: Show that can set the color point zone');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

zone_center = [-1 2];
num_points = 3;
zone_radius = 2;
point_zone_definition = [zone_radius num_points zone_center];

cellArrayOfPlotHandles = fcn_Laps_plotZoneDefinition(point_zone_definition, PlotStyle='r', FigNum=figNum);
axis([-5 5 -5 5]);

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(cellArrayOfPlotHandles));

% Check variable sizes
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, 2, figNum);

% Check variable values
% Are the laps starting at expected points?

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));


%% DEMO case: Specify zone, style, and figure
figNum = 10005;
titleString = sprintf('DEMO case: Specify zone, style, and figure');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill in some working data
segment_zone_definition = [1 2; 3 4]; % Starts at 1,2 and ends at 3,4

zone_center = [-1 2];
num_points = 3;
zone_radius = 2;
point_zone_definition = [zone_radius num_points zone_center];


plotStyle = 'g-';
cellArrayOfPlotHandles = fcn_Laps_plotZoneDefinition(point_zone_definition, PlotStyle=plotStyle, FigNum=figNum);
sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(cellArrayOfPlotHandles));

% Check variable sizes
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, 2, figNum);

% Check variable values
% Are the laps starting at expected points?

cellArrayOfPlotHandles = fcn_Laps_plotZoneDefinition(segment_zone_definition, PlotStyle=plotStyle, FigNum=figNum);
axis([-5 5 -5 5]);

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(cellArrayOfPlotHandles));

% Check variable sizes
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, 2, figNum);

% Check variable values
% Are the laps starting at expected points?

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));


%% DEMO case: Show that can set the figure without specifying plot color
figNum = 10006;
titleString = sprintf('DEMO case: Show that can set the figure without specifying plot color');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;


% Fill in some working data
segment_zone_definition = [1 2; 3 4]; % Starts at 1,2 and ends at 3,4

zone_center = [-1 2];
num_points = 3;
zone_radius = 2;
point_zone_definition = [zone_radius num_points zone_center];


% leave the plot style empty
cellArrayOfPlotHandles = fcn_Laps_plotZoneDefinition(segment_zone_definition,FigNum=figNum);

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(cellArrayOfPlotHandles));

% Check variable sizes
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, 2, figNum);

% Check variable values
% Are the laps starting at expected points?

cellArrayOfPlotHandles = fcn_Laps_plotZoneDefinition(point_zone_definition,FigNum=figNum);
axis([-5 5 -5 5]);

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(cellArrayOfPlotHandles));

% Check variable sizes
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, 2, figNum);

% Check variable values
% Are the laps starting at expected points?

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: Point zone without figure number, then segment zone with figNum of -1
figNum = 10007;
titleString = sprintf('DEMO case: Point zone without figure number, then segment zone with figNum of -1');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

zone_center = [-1 2];
num_points = 3;
zone_radius = 2;
point_zone_definition = [zone_radius num_points zone_center];
segment_zone_definition = [1 2; 3 4]; % Starts at 1,2 and ends at 3,4

% No figure number, so the plot goes into the current figure (figNum)
cellArrayOfPlotHandles = fcn_Laps_plotZoneDefinition(point_zone_definition);
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, 2, figNum);

% figNum of -1 skips input checks and also plots into the current figure
cellArrayOfPlotHandles = fcn_Laps_plotZoneDefinition(segment_zone_definition, PlotStyle='r', FigNum=-1);
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, 2, figNum);
axis([-5 5 -5 5]);

sgtitle(titleString, 'Interpreter','none');

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% Fast Mode Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ______        _     __  __           _        _______        _
% |  ____|      | |   |  \/  |         | |      |__   __|      | |
% | |__ __ _ ___| |_  | \  / | ___   __| | ___     | | ___  ___| |_ ___
% |  __/ _` / __| __| | |\/| |/ _ \ / _` |/ _ \    | |/ _ \/ __| __/ __|
% | | | (_| \__ \ |_  | |  | | (_) | (_| |  __/    | |  __/\__ \ |_\__ \
% |_|  \__,_|___/\__| |_|  |_|\___/ \__,_|\___|    |_|\___||___/\__|___/
%
%
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Fast%20Mode%20Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 8

close all;
fprintf(1,'Figure: 8XXXXXX: FAST mode cases (there are no fast modes for plotting functions) \n');
% 
% %% Basic example - NO FIGURE
% figNum = 80001;
% fprintf(1,'Figure: %.0f: FAST mode, empty figNum\n',figNum);
% figure(figNum); close(figNum);
% 
% dataSetNumber = 9;
% 
% % Load some test data 
% tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);
% 
% start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
% end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
% excursion_definition = []; % empty
% 
% [cell_array_of_lap_indices, ...
%     cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%     fcn_Laps_breakDataIntoLapIndices(...
%         tempXYdata,...
%         start_definition,...
%         EndZone=end_definition,...
%         ExcursionZone=excursion_definition,...
%         FigNum=[]);
% 
% % Check variable types
% assert(iscell(cell_array_of_lap_indices));
% assert(iscell(cell_array_of_entry_indices));
% assert(iscell(cell_array_of_exit_indices));
% 
% % Check variable sizes
% Nlaps = 3;
% assert(isequal(Nlaps,length(cell_array_of_lap_indices))); 
% assert(isequal(Nlaps,length(cell_array_of_entry_indices))); 
% assert(isequal(Nlaps,length(cell_array_of_exit_indices))); 
% 
% % Check variable values
% % Are the laps starting at expected points?
% assert(isequal(2,min(cell_array_of_lap_indices{1})));
% assert(isequal(102,min(cell_array_of_lap_indices{2})));
% assert(isequal(215,min(cell_array_of_lap_indices{3})));
% 
% % Are the laps ending at expected points?
% assert(isequal(88,max(cell_array_of_lap_indices{1})));
% assert(isequal(199,max(cell_array_of_lap_indices{2})));
% assert(isequal(293,max(cell_array_of_lap_indices{3})));
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
% 
% 
% %% Basic fast mode - NO FIGURE, FAST MODE
% figNum = 80002;
% fprintf(1,'Figure: %.0f: FAST mode, figNum=-1\n',figNum);
% figure(figNum); close(figNum);
% 
% dataSetNumber = 9;
% 
% % Load some test data 
% tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);
% 
% start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
% end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
% excursion_definition = []; % empty
% 
% [cell_array_of_lap_indices, ...
%     cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%     fcn_Laps_breakDataIntoLapIndices(...
%         tempXYdata,...
%         start_definition,...
%         EndZone=end_definition,...
%         ExcursionZone=excursion_definition,...
%         FigNum=-1);
% 
% % Check variable types
% assert(iscell(cell_array_of_lap_indices));
% assert(iscell(cell_array_of_entry_indices));
% assert(iscell(cell_array_of_exit_indices));
% 
% % Check variable sizes
% Nlaps = 3;
% assert(isequal(Nlaps,length(cell_array_of_lap_indices))); 
% assert(isequal(Nlaps,length(cell_array_of_entry_indices))); 
% assert(isequal(Nlaps,length(cell_array_of_exit_indices))); 
% 
% % Check variable values
% % Are the laps starting at expected points?
% assert(isequal(2,min(cell_array_of_lap_indices{1})));
% assert(isequal(102,min(cell_array_of_lap_indices{2})));
% assert(isequal(215,min(cell_array_of_lap_indices{3})));
% 
% % Are the laps ending at expected points?
% assert(isequal(88,max(cell_array_of_lap_indices{1})));
% assert(isequal(199,max(cell_array_of_lap_indices{2})));
% assert(isequal(293,max(cell_array_of_lap_indices{3})));
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
% 
% 
% %% Compare speeds of pre-calculation versus post-calculation versus a fast variant
% figNum = 80003;
% fprintf(1,'Figure: %.0f: FAST mode comparisons\n',figNum);
% figure(figNum);
% close(figNum);
% 
% dataSetNumber = 9;
% 
% % Load some test data 
% tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);
% 
% start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
% end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
% excursion_definition = []; % empty
% 
% 
% Niterations = 50;
% 
% % Do calculation without pre-calculation
% tic;
% for ith_test = 1:Niterations
%     % Call the function
%     [cell_array_of_lap_indices, ...
%         cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%         fcn_Laps_breakDataIntoLapIndices(...
%             tempXYdata,...
%             start_definition,...
%             EndZone=end_definition,...
%             ExcursionZone=excursion_definition,...
%             FigNum=[]);
% end
% slow_method = toc;
% 
% % Do calculation with pre-calculation, FAST_MODE on
% tic;
% for ith_test = 1:Niterations
%     % Call the function
%     [cell_array_of_lap_indices, ...
%         cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%         fcn_Laps_breakDataIntoLapIndices(...
%             tempXYdata,...
%             start_definition,...
%             EndZone=end_definition,...
%             ExcursionZone=excursion_definition,...
%             FigNum=-1);
% end
% fast_method = toc;
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
% 
% % Plot results as bar chart
% figure(373737);
% clf;
% hold on;
% 
% X = categorical({'Normal mode','Fast mode'});
% X = reordercats(X,{'Normal mode','Fast mode'}); % Forces bars to appear in this exact order, not alphabetized
% Y = [slow_method fast_method ]*1000/Niterations;
% bar(X,Y)
% ylabel('Execution time (Milliseconds)')
% 
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));


%% BUG cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ____  _    _  _____
% |  _ \| |  | |/ ____|
% | |_) | |  | | |  __    ___ __ _ ___  ___  ___
% |  _ <| |  | | | |_ |  / __/ _` / __|/ _ \/ __|
% | |_) | |__| | |__| | | (_| (_| \__ \  __/\__ \
% |____/ \____/ \_____|  \___\__,_|___/\___||___/
%
% See: http://patorjk.com/software/taag/#p=display&v=0&f=Big&t=BUG%20cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All bug case figures start with the number 9

% close all;

%% BUG 
%% Fail conditions
if 1==0
    
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

%% fcn_INTERNAL_checkPlotHandles
function fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, Nexpected, figNumExpected)
% Checks that the plot function returned a column cell array with exactly
% Nexpected entries, that every entry is a valid graphics handle (an empty
% cell would otherwise pass a length check), and that every handle was
% drawn into the expected figure.
assert(iscell(cellArrayOfPlotHandles));
assert(isequal([Nexpected 1], size(cellArrayOfPlotHandles)));
for ith_handle = 1:Nexpected
    thisHandle = cellArrayOfPlotHandles{ith_handle};
    assert(~isempty(thisHandle));
    assert(all(isgraphics(thisHandle)));
    assert(isequal(figNumExpected, get(ancestor(thisHandle,'figure'),'Number')));
end
end % Ends fcn_INTERNAL_checkPlotHandles

% script_test_fcn_Laps_plotLapsXY.m
% Tests fcn_Laps_plotLapsXY
       
% REVISION HISTORY:
%
% 2022_04_02 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_Laps_plotLapsXY
%   % * First write of the code
% 
% 2025_07_02 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_Laps_plotLapsXY
%   % * Removed traversal input type and replaced with cell array of paths
% 
% 2025_07_03 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_Laps_plotLapsXY
%   % * Standardized headers on all test scripts
%
% 2026_11_18 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_Laps_plotLapsXY
%   % * Standardized header comments into current convention
%   % * Variable renaming to avoid underscores
%   % * Added tests for the plot handle cell array outputs
%   % * Tightened handle checks: every returned handle must be a valid
%   %   % graphics object in the expected figure (fcn_INTERNAL_checkPlotHandles)
%   % * Added cases: no figNum, row cell array, empty entries and legend
%   %   % contents, and figNum of -1
%   % * Converted calls to Name=Value optional inputs (FigNum)

% TO-DO:
%
% 2025_11_21 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_Laps_plotLapsXY
%   % * (fill in items here)


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


% Fill in some dummy data
cellArrayOfPaths = fcn_Laps_fillSampleLaps;
 

% to show that it will auto-label the axes and create a new figure (NOT
% figure 11 here) to plot the data.
cellArrayOfPlotHandles = fcn_Laps_plotLapsXY(cellArrayOfPaths, FigNum=figNum);

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(cellArrayOfPlotHandles));

% Check variable sizes
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, numel(cellArrayOfPaths), figNum);

% Check variable values
% Are the laps starting at expected points?

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: Specify the figure number to show that it will NOT auto-label
figNum = 10002;
titleString = sprintf('DEMO case: Specify the figure number to show that it will NOT auto-label');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill in some dummy data
cellArrayOfPaths = fcn_Laps_fillSampleLaps;

figure(11);
% axes if figure is already given and it puts the plots into this figure.
cellArrayOfPlotHandles = fcn_Laps_plotLapsXY(cellArrayOfPaths,FigNum=figNum);

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(cellArrayOfPlotHandles));

% Check variable sizes
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, numel(cellArrayOfPaths), figNum);

% Check variable values
% Are the laps starting at expected points?

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: Call without figure number to show it plots into the current figure
figNum = 10003;
titleString = sprintf('DEMO case: Call without figure number to show it plots into the current figure');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill in some dummy data
cellArrayOfPaths = fcn_Laps_fillSampleLaps;

% No figure number, so the plot goes into the current figure (figNum)
cellArrayOfPlotHandles = fcn_Laps_plotLapsXY(cellArrayOfPaths);

% Check variable types, sizes, and that every handle is a line in figNum
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, numel(cellArrayOfPaths), figNum);

sgtitle(titleString, 'Interpreter','none');

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% TEST case: Row (1 x N) cell array input
figNum = 20001;
titleString = sprintf('TEST case: Row (1 x N) cell array input');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill in some dummy data, then make it a row cell array
cellArrayOfPaths = fcn_Laps_fillSampleLaps;
cellArrayOfPaths = cellArrayOfPaths';
assert(1==size(cellArrayOfPaths,1));

cellArrayOfPlotHandles = fcn_Laps_plotLapsXY(cellArrayOfPaths, FigNum=figNum);

% Output is still a column, one handle per path
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, numel(cellArrayOfPaths), figNum);

sgtitle(titleString, 'Interpreter','none');

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% TEST case: Empty entries keep their place and are hidden from the legend
figNum = 20002;
titleString = sprintf('TEST case: Empty entries keep their place and are hidden from the legend');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill in some dummy data, with empty entries in the middle and at the end
samplePaths = fcn_Laps_fillSampleLaps;
cellArrayOfPaths = {samplePaths{1}; []; samplePaths{2}; []};

cellArrayOfPlotHandles = fcn_Laps_plotLapsXY(cellArrayOfPaths, FigNum=figNum);

% One handle per entry, including the empty ones
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, 4, figNum);

% Handles keep the position of their path
assert(strcmp(get(cellArrayOfPlotHandles{3},'DisplayName'),'Path 3'));

% Only the two non-empty paths appear in the legend. The empty paths and
% the green/red start/end markers are hidden from it.
h_legend = legend('show');
assert(isequal(sort(h_legend.String), {'Path 1','Path 3'}));

sgtitle(titleString, 'Interpreter','none');

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% TEST case: figNum of -1 skips input checks and plots into the current figure
figNum = 20003;
titleString = sprintf('TEST case: figNum of -1 skips input checks and plots into the current figure');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill in some dummy data
cellArrayOfPaths = fcn_Laps_fillSampleLaps;

cellArrayOfPlotHandles = fcn_Laps_plotLapsXY(cellArrayOfPaths, FigNum=-1);

% Plot went into the current figure, which is figNum
fcn_INTERNAL_checkPlotHandles(cellArrayOfPlotHandles, numel(cellArrayOfPaths), figNum);

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

% script_test_fcn_Laps_breakDataIntoLaps.m
% tests fcn_Laps_breakDataIntoLaps.m

% Revision history
%     2022_04_03
%     -- first write of the code
%     2022_04_03
%     -- added external call to zone calculation function

close all
clc

clear laps_array data single_lap

% Call the function to fill in an array of "path" type
laps_array = fcn_Laps_fillSampleLaps;


% Convert paths to traversals structures. Each traversal instance is a
% "traversal" type, and the array called "data" below is a "traversals"
% type.
for i_Path = 1:length(laps_array)
    traversal = fcn_Path_convertPathToTraversalStructure(laps_array{i_Path});
    data.traversal{i_Path} = traversal;
end

% Plot the last one
fig_num = 1222;
single_lap.traversal{1} = data.traversal{end};
fcn_Laps_plotLapsXY(single_lap,fig_num);

%% Call the function
start_definition = [0 0 10]; % Located at [0,0] with radius 6
end_definition = [0 -60 30]; % Located at [0,-60] with radius 30
excursion_definition = []; % empty
fig_num = 1;
lap_traversals = fcn_Laps_breakDataIntoLaps(...
    single_lap.traversal{1},...
    start_definition,...
    end_definition,...
    excursion_definition,...
    fig_num);

% lap_traversals = fcn_Laps_breakDataIntoLaps(single_lap.traversal{1},start_definition,end_definition,excursion_definition,fig_num);


%% Show how the output works if use full argument list
[lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLaps(...
    single_lap.traversal{1},...
    start_definition,...
    end_definition,...
    excursion_definition,...
    fig_num);

% [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLaps(single_lap.traversal{1},start_definition,end_definition,excursion_definition,fig_num);

%% Show how a lap is missed if start is not big enough
start_definition = [0 0 6]; % Located at [0,0] with radius 6
end_definition = [0 -60 30]; % Located at [0,-60] with radius 30
excursion_definition = []; % empty
fig_num = 1;
lap_traversals = fcn_Laps_breakDataIntoLaps(...
    single_lap.traversal{1},...
    start_definition,...
    end_definition,...
    excursion_definition,...
    fig_num);



%% Check assertions
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

%% This one returns nothing since there is no portion of the path in the
% criteria
traversal = fcn_Path_convertPathToTraversalStructure([-1 1; 1 1]);
start_definition = [0 0 0.2]; % Located at [0,0] with radius 0.2
[lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLaps(...
    traversal,...
    start_definition);

assert(isempty(lap_traversals));
assert(isequal(entry_traversal,traversal));
assert(isempty(exit_traversal));

%% This one returns nothing since there is one portion of the path in the
% criteria
traversal = fcn_Path_convertPathToTraversalStructure([-1 1; 0 0; 1 1]);
start_definition = [0 0 0.2]; % Located at [0,0] with radius 0.2
[lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLaps(...
    traversal,...
    start_definition);

assert(isempty(lap_traversals));
assert(isequal(entry_traversal,traversal));
assert(isempty(exit_traversal));

%% This one returns nothing since there is only two points the path in the
% criteria
traversal = fcn_Path_convertPathToTraversalStructure([-1 1; 0 0; 0.1 0; 1 1]);
start_definition = [0 0 0.2]; % Located at [0,0] with radius 0.2
[lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLaps(...
    traversal,...
    start_definition);

assert(isempty(lap_traversals));
assert(isequal(entry_traversal,traversal));
assert(isempty(exit_traversal));

%% This one returns nothing since the minimum point is at the start
% and so there is no strong minimum inside the zone
traversal = fcn_Path_convertPathToTraversalStructure([-1 1; 0 0; 0.01 0; 0.02 0; 0.03 0; 1 1]);
start_definition = [0 0 0.2]; % Located at [0,0] with radius 0.2
[lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLaps(...
    traversal,...
    start_definition);

assert(isempty(lap_traversals));
assert(isequal(entry_traversal,traversal));
assert(isempty(exit_traversal));

%% This one returns nothing since the minimum point is at the end
% and so there is no strong minimum inside the zone
traversal = fcn_Path_convertPathToTraversalStructure([-1 1; -0.03 0; -0.02 0; -0.01 0; 0 0; 1 1]);
start_definition = [0 0 0.2]; % Located at [0,0] with radius 0.2
[lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLaps(...
    traversal,...
    start_definition);

assert(isempty(lap_traversals));
assert(isequal(entry_traversal,traversal));
assert(isempty(exit_traversal));

%% This one returns nothing since there is no end
fig_num = 123;
traversal = fcn_Path_convertPathToTraversalStructure([-1 1; -0.03 0; -0.02 0; 0 0; 0.1 0; 1 1]);
start_definition = [0 0 0.2]; % Located at [0,0] with radius 0.2
[lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLaps(...
    traversal,...
    start_definition,...
    [],...
    [],...
    fig_num);

assert(isempty(lap_traversals));
assert(isequal(entry_traversal,traversal));
assert(isempty(exit_traversal));

%% This one returns nothing since the end is incomplete
fig_num = 123;

% Create some data to plot
full_steps = (-1:0.1:1)';
zero_full_steps = 0*full_steps;
half_steps = (-1:0.1:0)';
zero_half_steps = 0*half_steps;

traversal = fcn_Path_convertPathToTraversalStructure(...
    [full_steps zero_full_steps; zero_half_steps half_steps]);
start_definition = [0 0 0.2]; % Located at [0,0] with radius 0.2
[lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLaps(...
    traversal,...
    start_definition,...
    [],...
    [],...
    fig_num);

assert(isempty(lap_traversals));
assert(isequal(entry_traversal,traversal));
assert(isempty(exit_traversal));

%% Show that the start and end points can overlap by their boundaries
fig_num = 1234;

traversal = fcn_Path_convertPathToTraversalStructure(...
    [full_steps zero_full_steps]);
start_definition = [-0.5 0 0.5]; 
end_definition = [0.5 0 0.5]; 
[lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLaps(...
    traversal,...
    start_definition,...
    [],...
    [],...
    fig_num);

assert(isempty(lap_traversals));
assert(isequal(entry_traversal,traversal));
assert(isempty(exit_traversal));

%% Show that the start and end points can be at the absolute ends
fig_num = 1234;

traversal = fcn_Path_convertPathToTraversalStructure(...
    [full_steps zero_full_steps]);
start_definition = [-1 0 0.5]; 
end_definition = [1 0 0.5]; 
[lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLaps(...
    traversal,...
    start_definition,...
    [],...
    [],...
    fig_num);

assert(isempty(lap_traversals));
assert(isequal(entry_traversal,traversal));
assert(isempty(exit_traversal));


%% Fail conditions
if 1==0
    
    %% Fails because start_definition is not correct type
    clc
    start_definition = [1 2];
    [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLaps(...
        single_lap.traversal{1},...
        start_definition); %#ok<*ASGLU>
    
    %% Fails because start_definition is not correct type
    clc
    start_definition = [1 2 3 4];
    [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLaps(...
        single_lap.traversal{1},...
        start_definition); 

    %% Fails because end_definition is not correct type
    clc
    start_definition = [1 2 3];
    end_definition = [1 2];
    [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLaps(...
        single_lap.traversal{1},...
        start_definition,...
        end_definition); 
    
    %% Fails because end_definition is not correct type
    clc
    start_definition = [1 2 3];
    end_definition = [1 2 3 4];
    [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLaps(...
        single_lap.traversal{1},...
        start_definition,...
        end_definition); 
    
    %% Fails because excursion_definition is not correct type
    clc
    start_definition = [1 2 3];
    end_definition = [1 2 3];
    excursion_definition = [1 2 3 4];
    [lap_traversals, input_and_exit_traversals] = fcn_Laps_breakDataIntoLaps(...
        single_lap.traversal{1},...
        start_definition,...
        end_definition,...
        excursion_definition); 
end
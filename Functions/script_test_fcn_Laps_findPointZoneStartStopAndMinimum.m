% script_test_fcn_Laps_findPointZoneStartStopAndMinimum.m
% tests fcn_Laps_findPointZoneStartStopAndMinimum.m

% Revision history
%     2022_04_08
%     -- first write of the code

close all
clc

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
% criteria, even though the path goes right over the criteria
fig_num = 1;

query_path = [-1 1; 1 1];
zone_definition = [0 0 0.2]; % Located at [0,0] with radius 0.2
[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_definition,...
    [],...
    fig_num);

assert(isempty(zone_start_indices));
assert(isempty(zone_end_indices));
assert(isempty(zone_min_indices));



%% This one returns nothing since there is one portion of the path in the
% criteria
fig_num = 2;

query_path = [-1 1; 0 0; 1 1];
zone_definition = [0 0 0.2]; % Located at [0,0] with radius 0.2
[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_definition,...
    [],...
    fig_num);

assert(isempty(zone_start_indices));
assert(isempty(zone_end_indices));
assert(isempty(zone_min_indices));

%% This one returns nothing since there is only two points the path in the
% criteria
fig_num = 3;

query_path = [-1 1; 0 0; 0.1 0.1; 1 1];
zone_definition = [0 0 0.2]; % Located at [0,0] with radius 0.2
[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_definition,...
    [],...
    fig_num);

assert(isempty(zone_start_indices));
assert(isempty(zone_end_indices));
assert(isempty(zone_min_indices));

%% This one returns one zone
% criteria
fig_num = 4;

query_path = [-1 1; -0.1 -0.1; 0 0; 0.1 0.1; 1 1];
zone_definition = [0 0 0.2]; % Located at [0,0] with radius 0.2
[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_definition,...
    [],...
    fig_num);

assert(isequal(zone_start_indices,2));
assert(isequal(zone_end_indices,4));
assert(isequal(zone_min_indices,3));


%% This one returns nothing since the end is incomplete
fig_num = 123;

% Create some data to plot
full_steps = (-1:0.1:1)';
zero_full_steps = 0*full_steps;
half_steps = (-1:0.1:0)';
zero_half_steps = 0*half_steps;

query_path = ...
    [full_steps zero_full_steps; zero_half_steps half_steps];

zone_definition = [0 0 0.2]; % Located at [0,0] with radius 0.2
[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_definition,...
    [],...
    fig_num);

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
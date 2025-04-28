% script_test_fcn_Laps_findSegmentZoneStartStop.m
% tests fcn_Laps_findSegmentZoneStartStop.m

% Revision history
%     2022_07_12
%     -- first write of the code

close all

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

%% BASIC EXAMPLE: This one returns one hit
fig_num = 1001;
figure(fig_num);
clf;

% Create some data to plot
full_steps = (-1:0.1:1)';
% zero_full_steps = 0*full_steps; 
ones_full_steps = ones(length(full_steps(:,1)),1);
% half_steps = (-1:0.1:0)';
% zero_half_steps = 0*half_steps;
% ones_half_steps = ones(length(half_steps(:,1)),1); 

% Create the query path
query_path = ...
    [full_steps 0.4*ones_full_steps];

segment_definition = [0 0; 0 1]; % Starts at [0,0], ends at [0 1]
[zone_start_indices, zone_end_indices] = ...
    fcn_Laps_findSegmentZoneStartStop(...
    query_path,...
    segment_definition,...
    fig_num);

assert(isequal(zone_start_indices,10));
assert(isequal(zone_end_indices,11));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% BASIC EXAMPLE: This one returns one hit, NO PLOTTING
fig_num = 1002;
figure(fig_num);
close(fig_num);

% Create some data to plot
full_steps = (-1:0.1:1)';
% zero_full_steps = 0*full_steps; 
ones_full_steps = ones(length(full_steps(:,1)),1);
% half_steps = (-1:0.1:0)';
% zero_half_steps = 0*half_steps;
% ones_half_steps = ones(length(half_steps(:,1)),1); 

% Create the query path
query_path = ...
    [full_steps 0.4*ones_full_steps];

segment_definition = [0 0; 0 1]; % Starts at [0,0], ends at [0 1]
[zone_start_indices, zone_end_indices] = ...
    fcn_Laps_findSegmentZoneStartStop(...
    query_path,...
    segment_definition,...
    []);

assert(isequal(zone_start_indices,10));
assert(isequal(zone_end_indices,11));

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==fig_num));

%% BASIC EXAMPLE: This one returns one hit, NO PLOTTING, FAST MODE
fig_num = 1003;
figure(fig_num);
close(fig_num);

% Create some data to plot
full_steps = (-1:0.1:1)';
% zero_full_steps = 0*full_steps; 
ones_full_steps = ones(length(full_steps(:,1)),1);
% half_steps = (-1:0.1:0)';
% zero_half_steps = 0*half_steps;
% ones_half_steps = ones(length(half_steps(:,1)),1); 

% Create the query path
query_path = ...
    [full_steps 0.4*ones_full_steps];

segment_definition = [0 0; 0 1]; % Starts at [0,0], ends at [0 1]
[zone_start_indices, zone_end_indices] = ...
    fcn_Laps_findSegmentZoneStartStop(...
    query_path,...
    segment_definition,...
    -1);

assert(isequal(zone_start_indices,10));
assert(isequal(zone_end_indices,11));

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==fig_num));

%% This one returns nothing since there is no portion of the path in the
% criteria, even though the path goes right over the criteria
fig_num = 2;
figure(fig_num);
clf;

% Create some data to plot
full_steps = (-1:0.1:1)';
zero_full_steps = 0*full_steps; 
ones_full_steps = ones(length(full_steps(:,1)),1);
half_steps = (-1:0.1:0)';
zero_half_steps = 0*half_steps;
ones_half_steps = ones(length(half_steps(:,1)),1); 

% Create the query path
query_path = ...
    [full_steps 0.4*ones_full_steps];

segment_definition = [0 0; 1 0]; % Starts at [0,0], ends at [1 0]
[zone_start_indices, zone_end_indices] = ...
    fcn_Laps_findSegmentZoneStartStop(...
    query_path,...
    segment_definition,...
    fig_num);

assert(isempty(zone_start_indices));
assert(isempty(zone_end_indices));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));


%% This one returns one hit, right on start of path
fig_num = 3;
figure(fig_num);
clf;

% Create some data to plot
full_steps = (-1:0.1:1)';
% zero_full_steps = 0*full_steps; 
ones_full_steps = ones(length(full_steps(:,1)),1);
% half_steps = (-1:0.1:0)';
% zero_half_steps = 0*half_steps;
% ones_half_steps = ones(length(half_steps(:,1)),1); 

% Create the query path
query_path = ...
    [full_steps 0.4*ones_full_steps];

segment_definition = [-1 0; -1 1]; % Starts at [-1,0], ends at [-1 1]
[zone_start_indices, zone_end_indices] = ...
    fcn_Laps_findSegmentZoneStartStop(...
    query_path,...
    segment_definition,...
    fig_num);

assert(isequal(zone_start_indices,1));
assert(isequal(zone_end_indices,2));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% This one returns no hit, crossed wrong way
fig_num = 4;
figure(fig_num);
clf;

% Create some data to plot
full_steps = (-1:0.1:1)';
% zero_full_steps = 0*full_steps; 
ones_full_steps = ones(length(full_steps(:,1)),1);
% half_steps = (-1:0.1:0)';
% zero_half_steps = 0*half_steps;
% ones_half_steps = ones(length(half_steps(:,1)),1); 

% Create the query path
query_path = ...
    [flipud(full_steps) 0.4*ones_full_steps];

segment_definition = [0 0; 0 1]; % Starts at [0,0], ends at [0 1]
[zone_start_indices, zone_end_indices] = ...
    fcn_Laps_findSegmentZoneStartStop(...
    query_path,...
    segment_definition,...
    fig_num);

assert(isempty(zone_start_indices));
assert(isempty(zone_end_indices));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% This one returns no hit, also crossed wrong way
fig_num = 5;
figure(fig_num);
clf;

% Create some data to plot
full_steps = (-1:0.1:1)';
% zero_full_steps = 0*full_steps; 
ones_full_steps = ones(length(full_steps(:,1)),1);
% half_steps = (-1:0.1:0)';
% zero_half_steps = 0*half_steps;
% ones_half_steps = ones(length(half_steps(:,1)),1); 

% Create the query path
query_path = ...
    [full_steps 0.4*ones_full_steps];

segment_definition = [0 1; 0 0]; % Starts at [0,1], ends at [0 0]
[zone_start_indices, zone_end_indices] = ...
    fcn_Laps_findSegmentZoneStartStop(...
    query_path,...
    segment_definition,...
    fig_num);

assert(isempty(zone_start_indices));
assert(isempty(zone_end_indices));
% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% This one returns two hits, even though crossed three times
% One crossing is in the wrong direction!
fig_num = 6;
figure(fig_num);
clf;

% Create some data to plot
full_steps = (-1:0.1:1)';
% zero_full_steps = 0*full_steps; 
ones_full_steps = ones(length(full_steps(:,1)),1);
half_steps = (-1:0.1:0)';
% zero_half_steps = 0*half_steps;
% ones_half_steps = ones(length(half_steps(:,1)),1); 

% Create the query path
query_path = ...
    [full_steps 0.4*ones_full_steps; 
    flipud(full_steps) 0.6*ones_full_steps;
    full_steps 0.8*ones_full_steps];

segment_definition = [0 0; 0 1]; % Starts at [0,0], ends at [0 1]
[zone_start_indices, zone_end_indices] = ...
    fcn_Laps_findSegmentZoneStartStop(...
    query_path,...
    segment_definition,...
    fig_num);

assert(isequal(zone_start_indices,[10; 52]));
assert(isequal(zone_end_indices,[11; 53]));
% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% Multiple crossings
fig_num = 7;
figure(fig_num);
clf;

% Create some data to plot
% full_steps = (-1:0.1:1)';
% zero_full_steps = 0*full_steps; 
% ones_full_steps = ones(length(full_steps(:,1)),1);
% half_steps = (-1:0.1:0)';
% zero_half_steps = 0*half_steps;
% ones_half_steps = ones(length(half_steps(:,1)),1); 

% Create the query path
query_path = ...
    [-1 2; 1 2; -1 1; 0 1; -1 0; 0 0; 1 0; 0 -1; 1 -1; -1 -2; 0 -2];

segment_definition = [0 -2; 0 2]; % Starts at [0,0], ends at [0 1]
[zone_start_indices, zone_end_indices] = ...
    fcn_Laps_findSegmentZoneStartStop(...
    query_path,...
    segment_definition,...
    fig_num);

assert(isequal(zone_start_indices,[1; 3; 5; 8; 10]));
assert(isequal(zone_end_indices,[2; 4; 6; 9; 11]));
% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% Multiple crossings, NO FIGURE
fig_num = 8;
figure(fig_num);
close(fig_num);

% Create some data to plot
% full_steps = (-1:0.1:1)';
% zero_full_steps = 0*full_steps; 
% ones_full_steps = ones(length(full_steps(:,1)),1);
% half_steps = (-1:0.1:0)';
% zero_half_steps = 0*half_steps;
% ones_half_steps = ones(length(half_steps(:,1)),1); 

% Create the query path
query_path = ...
    [-1 2; 1 2; -1 1; 0 1; -1 0; 0 0; 1 0; 0 -1; 1 -1; -1 -2; 0 -2];

segment_definition = [0 -2; 0 2]; % Starts at [0,0], ends at [0 1]
[zone_start_indices, zone_end_indices] = ...
    fcn_Laps_findSegmentZoneStartStop(...
    query_path,...
    segment_definition,...
    []);

assert(isequal(zone_start_indices,[1; 3; 5; 8; 10]));
assert(isequal(zone_end_indices,[2; 4; 6; 9; 11]));
% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==fig_num));

%% Fail conditions
if 1==0
    
    %% Fails because segment_definition is not correct type
    clc
    
    segment_definition = [0; 1]; % Starts at ?, ends at ?
    [~, ~] = ...
        fcn_Laps_findSegmentZoneStartStop(...
        query_path,...
        segment_definition,...
        []);
    
    %% Warns because segment_definition is 3D
    clc
    
    segment_definition = [0 0 0; 1 0 0]; % Starts at [0 0 0], ends at [1 0 0]
    [~, ~] = ...
        fcn_Laps_findSegmentZoneStartStop(...
        query_path,...
        segment_definition,...
        []);
   
end
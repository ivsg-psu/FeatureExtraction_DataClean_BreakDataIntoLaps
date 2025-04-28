% script_test_fcn_Laps_findPointZoneStartStopAndMinimum.m
% tests fcn_Laps_findPointZoneStartStopAndMinimum.m

% Revision history
%     2022_04_08
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

%% BASIC EXAMPLE, This one returns the last three points
% The zone is nudged over to the three points
fig_num = 1001;
figure(fig_num);
clf;

% Create some data to plot
full_steps = (-1:0.1:1)';
zero_full_steps = 0*full_steps; %#ok<*NASGU>
ones_full_steps = ones(length(full_steps(:,1)),1);
half_steps = (-1:0.1:0)';
zero_half_steps = 0*half_steps;
ones_half_steps = ones(length(half_steps(:,1)),1); %#ok<*PREALL>

query_path = ...
    [half_steps zero_half_steps];

zone_center = [-0.02 0]; % Located at [0.02,0]
zone_radius = 0.2;

[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_center,...
    zone_radius,...
    [],...
    fig_num);

assert(isequal(zone_start_indices,9));
assert(isequal(zone_end_indices,11));
assert(isequal(zone_min_indices,11));
% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% BASIC EXAMPLE, This one returns the last three points, NO PLOTTING
% The zone is nudged over to the three points
fig_num = 1002;
figure(fig_num);
close(fig_num);

% Create some data to plot
full_steps = (-1:0.1:1)';
zero_full_steps = 0*full_steps; %#ok<*NASGU>
ones_full_steps = ones(length(full_steps(:,1)),1);
half_steps = (-1:0.1:0)';
zero_half_steps = 0*half_steps;
ones_half_steps = ones(length(half_steps(:,1)),1); %#ok<*PREALL>

query_path = ...
    [half_steps zero_half_steps];

zone_center = [-0.02 0]; % Located at [0.02,0]
zone_radius = 0.2;

[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_center,...
    zone_radius,...
    [],...
    []);

assert(isequal(zone_start_indices,9));
assert(isequal(zone_end_indices,11));
assert(isequal(zone_min_indices,11));
% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==fig_num));

%% BASIC EXAMPLE, This one returns the last three points, NO PLOTTING, FAST MODE
% The zone is nudged over to the three points
fig_num = 1003;
figure(fig_num);
close(fig_num);

% Create some data to plot
full_steps = (-1:0.1:1)';
zero_full_steps = 0*full_steps; %#ok<*NASGU>
ones_full_steps = ones(length(full_steps(:,1)),1);
half_steps = (-1:0.1:0)';
zero_half_steps = 0*half_steps;
ones_half_steps = ones(length(half_steps(:,1)),1); %#ok<*PREALL>

query_path = ...
    [half_steps zero_half_steps];

zone_center = [-0.02 0]; % Located at [0.02,0]
zone_radius = 0.2;

[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_center,...
    zone_radius,...
    [],...
    -1);

assert(isequal(zone_start_indices,9));
assert(isequal(zone_end_indices,11));
assert(isequal(zone_min_indices,11));
% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==fig_num));

%% This one returns nothing since there is no portion of the path in the
% criteria, even though the path goes right over the criteria
fig_num = 1;
figure(fig_num);
clf;

% Create some data to plot
full_steps = (-1:0.1:1)';
zero_full_steps = 0*full_steps; %#ok<*NASGU>
ones_full_steps = ones(length(full_steps(:,1)),1);
half_steps = (-1:0.1:0)';
zero_half_steps = 0*half_steps;
ones_half_steps = ones(length(half_steps(:,1)),1); %#ok<*PREALL>

query_path = ...
    [full_steps 0.4*ones_full_steps];

zone_center = [0 0]; % Located at [0,0]
zone_radius = 0.2;   % Radius is 0.2
[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_center,...
    zone_radius,...
    [],...
    fig_num);

assert(isempty(zone_start_indices));
assert(isempty(zone_end_indices));
assert(isempty(zone_min_indices));
% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));



%% This one returns nothing since there is one portion of the path in the
% criteria
fig_num = 2;
figure(fig_num);
clf;

% Create some data to plot
full_steps = (-1:0.1:1)';
zero_full_steps = 0*full_steps; %#ok<*NASGU>
ones_full_steps = ones(length(full_steps(:,1)),1);
half_steps = (-1:0.1:0)';
zero_half_steps = 0*half_steps;
ones_half_steps = ones(length(half_steps(:,1)),1); %#ok<*PREALL>

query_path = ...
    [full_steps 0.2*ones_full_steps];

zone_center = [0 0]; % Located at [0,0]
zone_radius = 0.2;   % Radius is 0.2
[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_center,...
    zone_radius,...
    [],...
    fig_num);

assert(isempty(zone_start_indices));
assert(isempty(zone_end_indices));
assert(isempty(zone_min_indices));
% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% This one returns nothing since there are only two points only within boundary
% The default is 3
fig_num = 3;
figure(fig_num);
clf;

% Create some data to plot
full_steps = (-1:0.1:1)';
zero_full_steps = 0*full_steps; %#ok<*NASGU>
ones_full_steps = ones(length(full_steps(:,1)),1);
half_steps = (-1:0.1:0)';
zero_half_steps = 0*half_steps;
ones_half_steps = ones(length(half_steps(:,1)),1); %#ok<*PREALL>


query_path = ...
    [full_steps 0.2*ones_full_steps];

zone_center = [0.05 0]; % Located at [0.05,0]
zone_radius = 0.23;

[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_center,...
    zone_radius,...
    [],...
    fig_num);

assert(isempty(zone_start_indices));
assert(isempty(zone_end_indices));
assert(isempty(zone_min_indices));
% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));



%% This one returns nothing since there is only two points the path in the
% criteria. The third point is not strictly within the radius
fig_num = 4;
figure(fig_num);
clf;

% Create some data to plot
full_steps = (-1:0.1:1)';
zero_full_steps = 0*full_steps; %#ok<*NASGU>
ones_full_steps = ones(length(full_steps(:,1)),1);
half_steps = (-1:0.1:0)';
zero_half_steps = 0*half_steps;
ones_half_steps = ones(length(half_steps(:,1)),1); %#ok<*PREALL>

query_path = ...
    [half_steps zero_half_steps];

zone_center = [0 0]; % Located at [0,0]
zone_radius = 0.2;

[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_center,...
    zone_radius,...
    [],...
    fig_num);

assert(isempty(zone_start_indices));
assert(isempty(zone_end_indices));
assert(isempty(zone_min_indices));
% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));



%% Show effect of minimum_number_of_indices_in_zone

% Show that the previous one that failed now works if lower number to 2
% points in the zone
fig_num = 6;
figure(fig_num);
clf;

% Create some data to plot
full_steps = (-1:0.1:1)';
zero_full_steps = 0*full_steps; %#ok<*NASGU>
ones_full_steps = ones(length(full_steps(:,1)),1);
half_steps = (-1:0.1:0)';
zero_half_steps = 0*half_steps;
ones_half_steps = ones(length(half_steps(:,1)),1); %#ok<*PREALL>

query_path = ...
    [full_steps 0.2*ones_full_steps];


zone_center = [0.05 0]; % Located at [0.05,0]
zone_radius = 0.23;

zone_num_points = 2;

[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_center,...
    zone_radius,...
    zone_num_points,...
    fig_num);

assert(isequal(zone_start_indices,11));
assert(isequal(zone_end_indices,12));
assert(isequal(zone_min_indices,12));
% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

% Show that the previous one that worked now fails if raise number to 4
% points in the zone
fig_num = 6;


query_path = ...
    [half_steps zero_half_steps];

zone_center = [-0.02 0]; % Located at [0.02,0]
zone_radius = 0.2;
zone_num_points = 4;


[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_center,...
    zone_radius,...
    zone_num_points,...
    fig_num);

assert(isempty(zone_start_indices));
assert(isempty(zone_end_indices));
assert(isempty(zone_min_indices));
% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));


%% Multiple laps
fig_num = 7;
figure(fig_num);
clf;

% Create some data to plot
full_steps = (-1:0.1:1)';
zero_full_steps = 0*full_steps; %#ok<*NASGU>
ones_full_steps = ones(length(full_steps(:,1)),1);
half_steps = (-1:0.1:0)';
zero_half_steps = 0*half_steps;
ones_half_steps = ones(length(half_steps(:,1)),1); %#ok<*PREALL>

% Create some data to plot
full_steps = (-1:0.1:1)';
zero_full_steps = 0*full_steps;
ones_full_steps = ones(length(full_steps(:,1)),1);
half_steps = (-1:0.1:0)';
zero_half_steps = 0*half_steps;
ones_half_steps = ones(length(half_steps(:,1)),1);


query_path = ...
    [full_steps 0*ones_full_steps; -full_steps 0.1*ones_full_steps; full_steps 0.2*ones_full_steps ];


zone_center = [0.05 0]; % Located at [0.05,0]
zone_radius = 0.23;
zone_num_points = 3;

[zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_center,...
    zone_radius,...
    zone_num_points,...
    fig_num);

assert(isequal(zone_start_indices,[10; 30]));
assert(isequal(zone_end_indices,  [13; 33]));
assert(isequal(zone_min_indices,  [12; 31]));
% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

%% Fail conditions
if 1==0
    
    %% Fails because zone_center is not correct type
    clc
    
    zone_center = 0.05; % Located at ????
    zone_radius = 0.23;
    zone_num_points = 3;
    
    [~, ~, ~] = ...
        fcn_Laps_findPointZoneStartStopAndMinimum(...
        query_path,...
        zone_center,...
        zone_radius,...
        zone_num_points,...
        fig_num);
    
    
    %% Fails because zone_center is not correct type
    clc
    
    zone_center = [0.05 0 0 2]; % Located at ????
    zone_radius = 0.23;
    zone_num_points = 3;
    
    [~, ~, ~] = ...
        fcn_Laps_findPointZoneStartStopAndMinimum(...
        query_path,...
        zone_center,...
        zone_radius,...
        zone_num_points,...
        fig_num);
    
    
    %% Fails because radius is negative
    clc
    zone_center = [0.05 0]; % Located at [0.05,0]
    zone_radius = -0.23;
    zone_num_points = 3;
    
    [~, ~, ~] = ...
        fcn_Laps_findPointZoneStartStopAndMinimum(...
        query_path,...
        zone_center,...
        zone_radius,...
        zone_num_points,...
        fig_num);

    %% Fails because zone_num_points is negative
    clc
    zone_center = [0.05 0]; % Located at [0.05,0]
    zone_radius = 0.23;
    zone_num_points = -3;
    
    [~, ~, ~] = ...
        fcn_Laps_findPointZoneStartStopAndMinimum(...
        query_path,...
        zone_center,...
        zone_radius,...
        zone_num_points,...
        fig_num);

    %% Fails because zone_num_points is not an integer
    clc
    zone_center = [0.05 0]; % Located at [0.05,0]
    zone_radius = 0.23;
    zone_num_points = 3.2;
    
    [~, ~, ~] = ...
        fcn_Laps_findPointZoneStartStopAndMinimum(...
        query_path,...
        zone_center,...
        zone_radius,...
        zone_num_points,...
        fig_num);
    
   
end
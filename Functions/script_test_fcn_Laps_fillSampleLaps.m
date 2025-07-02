% script_test_fcn_Laps_fillSampleLaps.m
% tests fcn_Laps_fillSampleLaps.m

% Revision history
% 2022_04_02 by Sean Brennan
% -- first write of the code
% 2025_07_02 by Sean Brennan
% -- updated Path library calls to use paths, not traversals

close all

%% Basic call
fig_num = 1;
figure(fig_num);
clf;


% Call the function to fill in an array of "path" type
laps_array = fcn_Laps_fillSampleLaps(fig_num);

assert(iscell(laps_array));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),fig_num));

if 1==1
    % Show how to convert to single lap
    clear single_lap

    % We can even save one of these as a single "path"
    single_path = laps_array{1};

    % Call the plot command to show results in XY
    fig_num = 111;
    %fcn_Path_plotTraversalsXY(data,fig_num);
    fcn_Laps_plotLapsXY(laps_array,fig_num);


    % Show how to plot just one of them
    %fcn_Path_plotTraversalsXY(data,fig_num);
    fig_num = 1222;
    single_lap = laps_array{end};
    fcn_Laps_plotLapsXY({single_lap},fig_num);
end

%% Basic call - NO PLOTTING
fig_num = 2;
figure(fig_num);
close(fig_num);


% Call the function to fill in an array of "path" type
laps_array = fcn_Laps_fillSampleLaps([]);

assert(iscell(laps_array));

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==fig_num));

%% Basic call - NO PLOTTING, FAST MODE
fig_num = 2;
figure(fig_num);
close(fig_num);


% Call the function to fill in an array of "path" type
laps_array = fcn_Laps_fillSampleLaps(-1);

assert(iscell(laps_array));

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==fig_num));



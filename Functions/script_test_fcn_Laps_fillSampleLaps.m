% script_test_fcn_Laps_fillSampleLaps.m
% tests fcn_Laps_fillSampleLaps.m

% REVISION HISTORY:
%
% 2022_04_02 by Sean Brennan, sbrennan@psu.edu
% - first write of the code
% 
% 2025_07_02 by Sean Brennan, sbrennan@psu.edu
% - updated Path library calls to use paths, not traversals
% 
% 2025_07_03 by Sean Brennan, sbrennan@psu.edu
% - standardized headers on all test scripts
%
% 2026_11_18 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_Laps_fillSampleLaps
%   % * Converted calls to Name=Value optional inputs
%   % * Speed comparison now also times input checks turned off by
%   %   % the MATLABFLAG_LAPS_FLAG_CHECK_INPUTS environment variable

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


% Call the function to fill in an array of "path" type
laps_array = fcn_Laps_fillSampleLaps(FigNum=figNum);

sgtitle(titleString, 'Interpreter','none');

assert(iscell(laps_array));
% Check variable types
assert(iscell(laps_array));

% Check variable sizes
Nlaps = 9;
assert(isequal(Nlaps,length(laps_array))); 

% Check variable values

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
fprintf(1,'Figure: 8XXXXXX: FAST mode cases\n');

%% Basic example - NO FIGURE
figNum = 80001;
fprintf(1,'Figure: %.0f: FAST mode, empty figNum\n',figNum);
figure(figNum); close(figNum);

% Call the function to fill in an array of "path" type
laps_array = fcn_Laps_fillSampleLaps(FigNum=[]);

assert(iscell(laps_array));
% Check variable types
assert(iscell(laps_array));

% Check variable sizes
Nlaps = 9;
assert(isequal(Nlaps,length(laps_array))); 

% Check variable values

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));


%% Basic fast mode - NO FIGURE, FAST MODE
figNum = 80002;
fprintf(1,'Figure: %.0f: FAST mode, figNum=-1\n',figNum);
figure(figNum); close(figNum);

% Call the function to fill in an array of "path" type
laps_array = fcn_Laps_fillSampleLaps(FigNum=-1);

assert(iscell(laps_array));
% Check variable types
assert(iscell(laps_array));

% Check variable sizes
Nlaps = 9;
assert(isequal(Nlaps,length(laps_array))); 

% Check variable values

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));


%% Compare speeds of pre-calculation versus post-calculation versus a fast variant
figNum = 80003;
fprintf(1,'Figure: %.0f: FAST mode comparisons\n',figNum);
figure(figNum);
close(figNum);

Niterations = 20;

% Do calculation without pre-calculation
tic;
for ith_test = 1:Niterations
    % Call the function
    laps_array = fcn_Laps_fillSampleLaps(FigNum=[]);
end
slow_method = toc;

% Do calculation with pre-calculation, FAST_MODE on
tic;
for ith_test = 1:Niterations
    % Call the function
    laps_array = fcn_Laps_fillSampleLaps(FigNum=-1);
end
fast_method = toc;

% Do calculation with input checks turned off by environment variable.
% The code reads these variables only when both are set. Save the user's
% settings and restore them afterward, even if a call errors.
old_check_inputs = getenv("MATLABFLAG_LAPS_FLAG_CHECK_INPUTS");
old_do_debug     = getenv("MATLABFLAG_LAPS_FLAG_DO_DEBUG");
setenv("MATLABFLAG_LAPS_FLAG_CHECK_INPUTS","0");
setenv("MATLABFLAG_LAPS_FLAG_DO_DEBUG","0");
try
    tic;
    for ith_test = 1:Niterations
        % Call the function
        laps_array = fcn_Laps_fillSampleLaps(FigNum=[]);
    end
    env_method = toc;
catch ME
    setenv("MATLABFLAG_LAPS_FLAG_CHECK_INPUTS",old_check_inputs);
    setenv("MATLABFLAG_LAPS_FLAG_DO_DEBUG",old_do_debug);
    rethrow(ME);
end
setenv("MATLABFLAG_LAPS_FLAG_CHECK_INPUTS",old_check_inputs);
setenv("MATLABFLAG_LAPS_FLAG_DO_DEBUG",old_do_debug);

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));

% Plot results as bar chart
figure(373737);
clf;
hold on;

barLabels = {'Normal mode','Checks off (environment variable)','Fast mode (FigNum=-1)'};
X = categorical(barLabels);
X = reordercats(X,barLabels); % Forces bars to appear in this exact order, not alphabetized
Y = [slow_method env_method fast_method]*1000/Niterations;
bar(X,Y)
ylabel('Execution time (Milliseconds)')
fprintf(1,'Average time per call (ms): normal %.3f, checks off by environment variable %.3f, fast mode %.3f\n',Y(1),Y(2),Y(3));


% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));


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
    %
    
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





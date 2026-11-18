function cellArrayOfPlotHandles = fcn_Laps_plotLapsXY(cellArrayOfPaths, options)
% fcn_Laps_plotLapsXY
% Plots the XY positions of a set of laps, each given as a path. This is a
% modified version of fcn_Path_plotTraversalsXY from the "Path" library of
% functions. The start of each lap is marked with a green circle and the
% end with a red circle.
%
% FORMAT:
%
%       cellArrayOfPlotHandles = fcn_Laps_plotLapsXY(cellArrayOfPaths, (FigNum=figNum))
%
%      Optional inputs are given as Name=Value pairs after the required
%      inputs, in any order. Any option not given takes its default.
%
% INPUTS:
%
%      cellArrayOfPaths: a cell array of paths to plot, given either as a
%      column (N x 1) or row (1 x N) cell array. Each path is a M x 2 or
%      M x 3 set of coordinates representing the [X Y] or [X Y Z]
%      coordinates, in sequence, of a path. Only X and Y are plotted.
%      Empty cells are allowed and produce an empty (NaN) line.
%
%     (OPTIONAL INPUTS, given as Name=Value pairs)
%
%      FigNum: a figure number to plot into. If empty or omitted, plots
%      into the current figure (creating one if none exists). If set to
%      -1, input checking is skipped and the plot also goes into the
%      current figure.
%
% OUTPUTS:
%
%      cellArrayOfPlotHandles: an [N x 1] cell array of line handles, one
%      per entry of cellArrayOfPaths, in the same order. Each line's
%      DisplayName is 'Path k'. The green/red start and end markers are
%      hidden from legends and are not returned.
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
%       See the script: script_test_fcn_Laps_plotLapsXY.m for a full test
%       suite.
%
% This function was written on 2022_04_02 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% 2022_04_02 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotLapsXY
%   % * Wrote the code originally
%
% 2025_04_25 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotLapsXY
%   % * Added global debugging options
%
% 2025_07_02 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotLapsXY
%   % * Removed traversal input type and replaced with cell array of paths
%
% 2025_07_03 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotLapsXY
%   % * Cleanup of Debugging area codes
%   % * Turn on fast mode for Path calls
%
% 2026_11_18 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotLapsXY
%   % * Fixed errors in comments
%   % * Standardized header comments into current convention
%   % * Variable renaming to avoid underscores
%   % * Changed output handles to a column cell array
%   % * Plots into the current figure when figNum is empty, omitted, or
%   %   % -1 (previously plotted nothing unless figNum was given)
%   % * Fixed error with 1 x N (row) cell array inputs
%   % * Returns one handle per input cell, including empty cells, so
%   %   % handle k always matches path k
%   % * Added DisplayName to each line; start/end markers are hidden
%   %   % from legends
%   % * Replaced tab indentation with spaces
%   % * Changed optional inputs from positional arguments to Name=Value
%   %   % pairs, declared in a bare arguments block (names and defaults
%   %   % only). Clean break: positional optional inputs no longer work.
%   %   % Option names: FigNum
%   % * Fast mode is now FigNum=-1. Input checks are still gated by fast
%   %   % mode and MATLABFLAG_LAPS_FLAG_CHECK_INPUTS, as before
%   % * narginchk removed; the arguments block checks the input count

% TO-DO:
%
% 2026_11_18 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotLapsXY
%   % * (fill in items here)



% Declare the inputs. This block only names the inputs and sets the
% option defaults: it has no class, size, or validator checks, so it
% adds little time to each call. The real input checks are in the
% gated section below, which can be skipped with FigNum=-1 or with
% the MATLABFLAG_LAPS_FLAG_CHECK_INPUTS environment variable.
arguments
    cellArrayOfPaths
    options.FigNum = [] % Figure to plot into; [] for current figure, -1 for fast mode
end

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the FigNum option is given
% a value of -1, which is not a valid figure number.
flag_max_speed = 0; % The default. This runs code with all error checking
if isequal(options.FigNum,-1)
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_LAPS_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_LAPS_FLAG_CHECK_INPUTS");
    MATLABFLAG_LAPS_FLAG_DO_DEBUG = getenv("MATLABFLAG_LAPS_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_LAPS_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_LAPS_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_LAPS_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_LAPS_FLAG_CHECK_INPUTS);
    end
end

% flag_do_debug = 1;

if flag_do_debug % If debugging is on, print on entry/exit to the function
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_figNum = 999978; %#ok<NASGU>
else
    debug_figNum = []; %#ok<NASGU>
end

%% check input arguments?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0==flag_max_speed
    if flag_check_inputs
        % The number of inputs and the option names are checked by the
        % arguments block above

        % Check the cellArrayOfPaths input
        if ~iscell(cellArrayOfPaths)
            error('cellArrayOfPaths input must be a cell type');
        end
        for ith_cell = 1:numel(cellArrayOfPaths)
            if ~isempty(cellArrayOfPaths{ith_cell})
                fcn_DebugTools_checkInputsToFunctions(cellArrayOfPaths{ith_cell}, 'path2or3D');
            end
        end
    end
end

% Which figure to plot into? Plotting is the purpose of this function, so
% it always plots: into the given figure, or else into the current figure.
figNum = []; % Default is to use the current figure
if (0==flag_max_speed)
    temp = options.FigNum;
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp;
    end
end

if isempty(figNum)
    temp_h = gcf;
else
    temp_h = figure(figNum);
end
flag_this_is_a_new_figure = isempty(get(temp_h,'Children'));

%% Main code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use linear indexing throughout so row and column cell arrays both work
NumPaths = numel(cellArrayOfPaths);
cellArrayOfPlotHandles = cell(NumPaths,1);

axis equal;

% Check to see if hold is already on. If it is not, set a flag to turn it
% off after this function is over so it doesn't affect future plotting
flag_shut_hold_off = 0;
if ~ishold
    flag_shut_hold_off = 1;
    hold on
end

% Plot each path. Empty paths get a NaN line, hidden from legends, so that
% handle k always corresponds to path k.
for ith_path = 1:NumPaths
    thisPath = cellArrayOfPaths{ith_path};
    if ~isempty(thisPath)
        cellArrayOfPlotHandles{ith_path} = plot(thisPath(:,1),thisPath(:,2),'-o',...
            'DisplayName',sprintf('Path %d',ith_path));
    else
        cellArrayOfPlotHandles{ith_path} = plot(NaN,NaN,'-o',...
            'DisplayName',sprintf('Path %d',ith_path),'HandleVisibility','off');
    end
end

% Plot the start and end values as green and red respectively. These are
% markers only, so keep them out of any legend.
for ith_path = 1:NumPaths
    thisPath = cellArrayOfPaths{ith_path};
    if ~isempty(thisPath)
        plot(thisPath(1,1),thisPath(1,2),'go','HandleVisibility','off');
        plot(thisPath(end,1),thisPath(end,2),'ro','HandleVisibility','off');
    end
end

% Shut the hold off?
if flag_shut_hold_off
    hold off;
end

% Add labels?
if flag_this_is_a_new_figure
    title('X vs Y')
    xlabel('X [m]')
    ylabel('Y [m]')

    % Make axis slightly larger
    temp = axis;
    axis_range_x = temp(2)-temp(1);
    axis_range_y = temp(4)-temp(3);
    percent_larger = 0.3;
    axis([temp(1)-percent_larger*axis_range_x, temp(2)+percent_larger*axis_range_x,  temp(3)-percent_larger*axis_range_y, temp(4)+percent_larger*axis_range_y]);
end


%% Any debugging?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end
end

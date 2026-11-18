function varargout = fcn_Laps_breakDataIntoLaps(...
    input_path,...
    start_definition,...
    options)
% fcn_Laps_breakDataIntoLaps
% Given an input path, breaks the data into laps using the XY data of the
% path by checking whether the data meet particular conditions to define
% the meaning of a lap. The function returns the laps as a cell array of
% paths, with each path being one lap. Any entry and exit portions that are
% not full laps are also returned as paths. If no laps are detected, then
% the input path is assumed to be only an entry path and
% lap_cellArrayOfPaths is empty.
%
% This function is a thin wrapper around fcn_Laps_breakDataIntoLapIndices:
% all zone detection and lap matching is done there, and this function
% only slices the input path by the returned indices. See
% fcn_Laps_breakDataIntoLapIndices for the full description of how the
% start, end, and excursion conditions are interpreted.
%
% The conditions to specify a lap can be given as either (1) points or (2)
% line segments. These conditions are used to define situations that start
% a lap, end a lap, or define an excursion. The end and excursion inputs
% are optional. If an optional end condition is not specified, then the
% start condition is used for both the start and end condition. If the
% excursion condition is not given, then no excursion is required.
%
% Of the two types of conditions, the definitions are as follows:
% (1) For point conditions, the inputs are formatted as:
% [radius num_points X Y] wherein X and Y specify the XY coordinates for
% the point, radius specifies the radius from the point that the path must
% pass, and num_points specifies the number of consecutive points that must
% be strictly inside the zone for the condition to be met.
%
% (2) For line segment conditions, the inputs are formatted as:
% [X_start Y_start; X_end Y_end] wherein start denotes the starting
% coordinate of the line segment, end denotes the ending coordinate of the
% line segment. For the condition to be met, the path must pass over the
% line segment, or directly through one of the end points. Further, the
% path must pass in the positive cross-product direction through the
% segment, wherein the positive direction is denoted from the vector from
% start to end of the line segment.
%
% FORMAT:
%
%      [lap_cellArrayOfPaths, (entry_path, exit_path)] = ...
%      fcn_Laps_breakDataIntoLaps(...
%            input_path,...
%            start_definition,...
%            (EndZone=end_definition),...
%            (ExcursionZone=excursion_definition),...
%            (FigNum=figNum));
%
%      Optional inputs are given as Name=Value pairs after the required
%      inputs, in any order. Any option not given takes its default.
%
% INPUTS:
%
%      input_path: a N x 2 or N x 3 set of coordinates representing the
%      [X Y] or [X Y Z] coordinates, in sequence, of a path that is to be
%      broken up into laps. Only the XY columns are used to detect laps;
%      all columns are kept in the outputs.
%
%      start_definition: the condition, defined as a point/radius or line
%      segment, defining the start condition to break the data into laps.
%      It is of one of two forms. A zone defined by a center point, radius,
%      and number of points that must pass through that "circle", given in
%      a 1-row format as:
%
%        [zone_radius zone_num_points zone_center_x zone_center_y] (or)
%        [zone_radius zone_num_points zone_center_x zone_center_y zone_center_z]
%
%      OR, a zone can be given by a segment defined by a start and end
%      point, given by two rows.
%
%        [zone_start_x zone_start_y; zone_end_x zone_end_y]
%      (NOTE: there's no 3-d equivalent of a starting line or finish line)
%
%      (OPTIONAL INPUTS, given as Name=Value pairs)
%
%      EndZone: the condition, defined as a point/radius or line
%      segment, defining the end condition to break the data into laps. If
%      not specified, the start condition is used. The same type is used as
%      the start_definition.
%
%      ExcursionZone: the condition, defined as a point/radius or
%      line segment, defining a situation that must be met between the
%      start and end conditions. If not specified, then no excursion point
%      is used. The same type is used as the start_definition.
%
%      FigNum: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      lap_cellArrayOfPaths: an [Nlaps x 1] cell array containing the
%      resulting laps, with each lap being a path
%
%      OPTIONAL OUTPUTS:
%
%      entry_path: a path (numeric array) containing the portion of the
%      input path up to and including the start of the first lap. Empty if
%      this portion is a single point. If no laps are found, this is the
%      entire input path.
%
%      exit_path: a path (numeric array) containing the portion of the
%      input path from the end of the last lap onward. Empty if this
%      portion is a single point, or if no laps are found.
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%      fcn_Laps_checkZoneType
%      fcn_Laps_breakDataIntoLapIndices
%      fcn_Laps_plotLapsXY
%      fcn_Laps_plotZoneDefinition
%
% EXAMPLES:
%
%     See the script: script_test_fcn_Laps_breakDataIntoLaps
%     for a full test suite.
%
% This function was written on 2022_04_03 by S. Brennan
% Questions or comments? sbrennan@psu.edu


% REVISION HISTORY:
%
% 2022_04_03 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_breakDataIntoLaps
%   % * Wrote the code originally
% 
% 2022_04_23 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_breakDataIntoLaps
%   % * Added external call to zone calculation function
% 
% 2022_05_21 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_breakDataIntoLaps
%   % * Cleaned up the comments
%   % * Fixed bugs in excursion zone flag shutting off code
%   % * Fixed bugs in excursion zone and end zone definitions
%   % * Fixed scalar comparison in size function of argument check
% 
% 2022_05_21 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_breakDataIntoLaps
%   % * Fixed plotting, made outputs variable argument types
% 
% 2022_07_11 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_breakDataIntoLaps
%   % * Corrected calls to zone function to allow number of points,
%   %   % changed format to allow 3d circles
% 
% 2022_07_12 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_breakDataIntoLaps
%   % * Allow zone definitions based on segments
% 
% 2025_04_25 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_breakDataIntoLaps
%   % * Added global debugging options
% 
% 2025_07_03 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_breakDataIntoLaps
%   % * Cleanup of Debugging area codes
%   % * Turn on fast mode for Path calls
% 
% 2025_11_12 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_breakDataIntoLaps
%   % * Cleaned up variable naming: fig_+num to figNum
% 
% 2026_11_18 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_breakDataIntoLaps
%   % * Standardized header comments into current convention
%   % * Refactored to call fcn_Laps_breakDataIntoLapIndices and slice the
%   %   % path by the returned indices, removing ~400 lines of code that
%   %   % duplicated the zone detection and lap matching logic
%   % * Fixed crash for N x 3 paths with point zones (zone detection now uses
%   %   % only the XY columns, while outputs keep all columns)
%   % * Removed unused INTERNAL_plot_circle
%   % * Fixed legend, which showed "data1, data2, ..." entries and an
%   %   % entry for every start/end marker; lines are now labeled with
%   %   % DisplayName and each zone gets one legend entry
%   % * Changed optional inputs from positional arguments to Name=Value
%   %   % pairs, declared in a bare arguments block (names and defaults
%   %   % only). Clean break: positional optional inputs no longer work.
%   %   % Option names: EndZone, ExcursionZone, FigNum
%   % * Fast mode is now FigNum=-1. Input checks are still gated by fast
%   %   % mode and MATLABFLAG_LAPS_FLAG_CHECK_INPUTS, as before
%   % * narginchk removed; the arguments block checks the input count

% TO-DO:
%
% 2026_11_18 by Sean Brennan, sbrennan@psu.edu
% - (fill in items here)



% Declare the inputs. This block only names the inputs and sets the
% option defaults: it has no class, size, or validator checks, so it
% adds little time to each call. The real input checks are in the
% gated section below, which can be skipped with FigNum=-1 or with
% the MATLABFLAG_LAPS_FLAG_CHECK_INPUTS environment variable.
arguments
    input_path
    start_definition
    options.EndZone = []       % Zone that ends a lap; [] uses the start zone
    options.ExcursionZone = [] % Zone that must be reached mid-lap; [] for none
    options.FigNum = []        % Figure to plot into; [] for no plot, -1 for fast mode
end

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the FigNum option is given
% a value of -1, which is not a valid figure number.
flag_max_speed = 0; % The default. This runs code with all error checking
if isequal(options.FigNum,-1)
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % Flag to plot the results for debugging
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

        % Check the input_path variables
        fcn_DebugTools_checkInputsToFunctions(input_path, 'path2or3D');

        % NOTE: the zone definitions are checked below
    end
end

% Check the zone definitions here (rather than leaving it to
% fcn_Laps_breakDataIntoLapIndices) so that any 3D zones are flattened
% once, with one warning, and the 2D versions are available for plotting.

% Set the start values
[~, start_definition] = fcn_Laps_checkZoneType(start_definition, 'start_definition', FigNum=-1);

% Does the user want to specify the end_definition?
end_definition = []; % Default case: fcn_Laps_breakDataIntoLapIndices uses the start definition
temp = options.EndZone;
if ~isempty(temp)
    [~, end_definition] = fcn_Laps_checkZoneType(temp, 'end_definition', FigNum=-1);
end

% Does the user want to specify excursion_definition?
excursion_definition = []; % Default case: no excursion zone
temp = options.ExcursionZone;
if ~isempty(temp)
    [~, excursion_definition] = fcn_Laps_checkZoneType(temp, 'excursion_definition', FigNum=-1);
end

% Does user want to show the plots?
flag_do_plots = 0; % Default is to NOT show plots
if (0==flag_max_speed)
    temp = options.FigNum;
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp;
        flag_do_plots = 1;
    end
end

% Check the outputs
nargoutchk(0,3)


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

% Inputs were already checked above, so call the index function in fast
% mode. If debugging, call it in normal mode instead so that its own debug
% printing of zones and laps is shown (it does not plot unless given a
% figure number).
if flag_do_debug
    indices_figNum = [];
else
    indices_figNum = -1;
end

[cell_array_of_lap_indices, cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
    fcn_Laps_breakDataIntoLapIndices(...
        input_path,...
        start_definition,...
        EndZone=end_definition,...
        ExcursionZone=excursion_definition,...
        FigNum=indices_figNum);

Nlaps = length(cell_array_of_lap_indices);

% Fill defaults (used if no laps are found)
lap_cellArrayOfPaths = {};
entry_path = input_path;
exit_path = [];

if Nlaps>0
    % Slice out each lap, keeping all columns of the input path
    lap_cellArrayOfPaths = cell(Nlaps,1);
    for ith_lap = 1:Nlaps
        lap_cellArrayOfPaths{ith_lap} = input_path(cell_array_of_lap_indices{ith_lap},:);
    end

    % The entry path is everything up to the start of the first lap, and
    % the exit path is everything from the end of the last lap onward.
    % Single-point fragments are returned as empty.
    entry_path = INTERNAL_sliceIfMoreThanOnePoint(input_path, cell_array_of_entry_indices{1});
    exit_path  = INTERNAL_sliceIfMoreThanOnePoint(input_path, cell_array_of_exit_indices{end});
end

if flag_do_debug
    fprintf(1,'Number of complete laps: %d\n',Nlaps);
    fprintf(1,'Points in entry path: %d\n',size(entry_path,1));
    fprintf(1,'Points in exit path: %d\n',size(exit_path,1));
end

% Save outputs depending on which ones the user asks for
if nargout >= 1
    varargout{1} = lap_cellArrayOfPaths;
end
if nargout >= 2
    varargout{2} = entry_path;
end
if nargout >= 3
    varargout{3} = exit_path;
end


%% Plot the results (for debugging)?
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
if flag_do_plots

    % plot the final XY result
    figure(figNum);
    clf;

    % Everything put together
    hold on;
    grid on
    axis equal
    title('Results of breaking data into laps');

    plot_cellArrayOfPaths = cell(Nlaps+3,1);
    plot_cellArrayOfPaths{1} = input_path;
    for ith_lap = 1:Nlaps
        plot_cellArrayOfPaths{ith_lap+1} = lap_cellArrayOfPaths{ith_lap};
    end
    if nargout > 1
        plot_cellArrayOfPaths{Nlaps+2} = entry_path;
        plot_cellArrayOfPaths{Nlaps+3} = exit_path;
    end

    cellArrayOfPlotHandles = fcn_Laps_plotLapsXY(plot_cellArrayOfPaths,FigNum=figNum);

    % Make input be thin line
    set(cellArrayOfPlotHandles{1},'Color',[0 0 0],'Marker','.','MarkerSize',10,'Linewidth', 0.75);

    % Make all the laps have thick lines
    for ith_plot = 2:(length(cellArrayOfPlotHandles))
        set(cellArrayOfPlotHandles{ith_plot},'Marker','.','MarkerSize',20,'Linewidth', 5);
    end

    % Label each line for the legend. fcn_Laps_plotLapsXY hides empty
    % paths and the start/end markers from the legend already.
    set(cellArrayOfPlotHandles{1},'DisplayName','Input path');
    for ith_lap = 1:Nlaps
        set(cellArrayOfPlotHandles{ith_lap+1},'DisplayName',sprintf('Lap %d',ith_lap));
    end
    set(cellArrayOfPlotHandles{Nlaps+2},'DisplayName','Entry');
    set(cellArrayOfPlotHandles{Nlaps+3},'DisplayName','Exit');

    % Plot the start zone in green and the end zone in red. If no end
    % zone was given, the start zone is also the end zone.
    startZoneHandles = fcn_Laps_plotZoneDefinition(start_definition,PlotStyle='g',FigNum=figNum);
    if isempty(end_definition)
        endZoneHandles = fcn_Laps_plotZoneDefinition(start_definition,PlotStyle='r',FigNum=figNum);
    else
        endZoneHandles = fcn_Laps_plotZoneDefinition(end_definition,PlotStyle='r',FigNum=figNum);
    end
    INTERNAL_labelZoneForLegend(startZoneHandles,'Start zone');
    INTERNAL_labelZoneForLegend(endZoneHandles,'End zone');

    % Build the legend once, after everything is plotted, from the
    % DisplayName of each visible line
    h_legend = legend('Interpreter','none');
    set(h_legend,'AutoUpdate','off');

end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends main function

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% INTERNAL_labelZoneForLegend
function INTERNAL_labelZoneForLegend(cellArrayOfZoneHandles, labelString)
% Gives the first zone handle (point-zone center or segment line) the
% legend label, and hides the remaining zone handles (boundary circle or
% direction arrow) from the legend so each zone gets one legend entry.
for ith_handle = 1:numel(cellArrayOfZoneHandles)
    thisHandle = cellArrayOfZoneHandles{ith_handle};
    if isempty(thisHandle)
        continue;
    end
    if 1==ith_handle
        set(thisHandle,'DisplayName',labelString);
    else
        set(thisHandle,'HandleVisibility','off');
    end
end
end % Ends INTERNAL_labelZoneForLegend

%% INTERNAL_sliceIfMoreThanOnePoint
function sliced_path = INTERNAL_sliceIfMoreThanOnePoint(input_path, indices)
% Returns the rows of input_path given by indices, or empty if the indices
% select fewer than two points (a single point is not a path).
if length(indices)>1
    sliced_path = input_path(indices,:);
else
    sliced_path = [];
end
end % Ends INTERNAL_sliceIfMoreThanOnePoint
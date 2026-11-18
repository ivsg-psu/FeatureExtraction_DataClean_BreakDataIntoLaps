function cellArrayOfPlotHandles = fcn_Laps_plotZoneDefinition(zoneDefinition, options)
% fcn_Laps_plotZoneDefinition - Plots the zone definition for Laps codes
%
% Accepts as an optional second input standard plot style specifications,
% for example 'r-' for a red line.
%
% As optional third input, plots this in a user-specified figure. Returns
% the plot handle as the output. 
%
% FORMAT: 
%
%       cellArrayOfPlotHandles = fcn_Laps_plotZoneDefinition(zoneDefinition, (PlotStyle=plotStyle), (FigNum=figNum))
%
%      Optional inputs are given as Name=Value pairs after the required
%      inputs, in any order. Any option not given takes its default.
%
% INPUTS:
%
%      zoneDefinition: the definition of the zone as given in a point zone
%      or segment zone style. See fcn_Laps_breakDataIntoLapIndices for
%      details.
%
%      (OPTIONAL INPUTS, given as Name=Value pairs)
%   
%      PlotStyle: the standard plot specification style allowing line and
%      color, for example 'r-'. Type "help plot" for a listing of options.
%
%      FigNum: a figure number to plot into. If empty or omitted, plots
%      into the current figure (creating one if none exists). If set to
%      -1, input checking is skipped and the plot also goes into the
%      current figure.
%
% OUTPUTS:
%
%      cellArrayOfPlotHandles: a [2 x 1] cell array of handles, as returned
%      by fcn_Laps_plotPointZoneDefinition (center, boundary) or
%      fcn_Laps_plotSegmentZoneDefinition (line, direction arrow).
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%      fcn_Laps_checkZoneType
%      fcn_Laps_plotSegmentZoneDefinition
%      fcn_Laps_plotPointZoneDefinition
%
% EXAMPLES:
%      
%       See the script: script_test_fcn_Laps_plotZoneDefinition.m for
%       a full test suite.
%
% This function was written on 2022_07_23 by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% REVISION HISTORY:
%
% 2022_07_23 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotZoneDefinition
%   % * Wrote the code originally
% 
% 2025_04_25 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotZoneDefinition
%   % * Added global debugging options
% 
% 2025_07_03 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotZoneDefinition
%   % * Cleanup of Debugging area codes
%   % * Turn on fast mode for Path calls
%
% 2026_11_18 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotZoneDefinition
%   % * Standardized header comments into current convention
%   % * Variable renaming to avoid underscores
%   % * Fixed bug where, if figNum is empty, does not plot. Now plots into
%   %   % the current figure when figNum is empty, omitted, or -1
%   % * Changed output handles to a column cell array
%   % * Initialize a default output
%   % * Renamed zone_definition input to zoneDefinition
%   % * Replaced tab indentation with spaces
%   % * Changed optional inputs from positional arguments to Name=Value
%   %   % pairs, declared in a bare arguments block (names and defaults
%   %   % only). Clean break: positional optional inputs no longer work.
%   %   % Option names: PlotStyle, FigNum
%   % * Fast mode is now FigNum=-1. Input checks are still gated by fast
%   %   % mode and MATLABFLAG_LAPS_FLAG_CHECK_INPUTS, as before
%   % * narginchk removed; the arguments block checks the input count

% TO-DO:
%
% 2025_11_21 by Sean Brennan, sbrennan@psu.edu
% - (fill in items here)



% Declare the inputs. This block only names the inputs and sets the
% option defaults: it has no class, size, or validator checks, so it
% adds little time to each call. The real input checks are in the
% gated section below, which can be skipped with FigNum=-1 or with
% the MATLABFLAG_LAPS_FLAG_CHECK_INPUTS environment variable.
arguments
    zoneDefinition
    options.PlotStyle = [] % Line spec such as 'r-'; [] for default colors
    options.FigNum = []    % Figure to plot into; [] for current figure, -1 for fast mode
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
    end
end

% Check for plot style input
plotStyle = []; % Leave it empty for defaults
temp = options.PlotStyle;
if ~isempty(temp)
    plotStyle = temp;
end

% Does user want to show the plots?
figNum = [];
flag_do_plots = 1; % Always plot: this is a plotting function
if (0==flag_max_speed)
    temp = options.FigNum;
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp;
        flag_do_plots = 1;
    end
end

% If no figure was given (or -1 was given), plot into the current figure
if isempty(figNum)
    temp_h = gcf;
    figNum = temp_h.Number;
end
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

% Initialize outputs
cellArrayOfPlotHandles = cell(2,1);

% What type is it?
[flag_is_a_point_zone_type, new_zoneDefinition] = fcn_Laps_checkZoneType(zoneDefinition, 'plot_zone_definition', FigNum=-1);

% Is it a point-zone type?
if 1==flag_do_plots
    if flag_is_a_point_zone_type
        cellArrayOfPlotHandles = fcn_Laps_plotPointZoneDefinition(new_zoneDefinition,PlotStyle=plotStyle,FigNum=figNum);
    else % No, it's a segment zone
        cellArrayOfPlotHandles = fcn_Laps_plotSegmentZoneDefinition(new_zoneDefinition,PlotStyle=plotStyle,FigNum=figNum);
    end
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
if flag_do_plots
    % Nothing in here yet
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end


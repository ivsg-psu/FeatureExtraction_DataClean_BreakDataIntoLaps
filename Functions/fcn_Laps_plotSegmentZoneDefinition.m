function cellArrayOfPlotHandles = fcn_Laps_plotSegmentZoneDefinition(zoneDefinition, options)
% fcn_Laps_plotSegmentZoneDefinition
% Plots the segment zone definition given by the input variable, zoneDefinition.
%
% Accepts as an optional second input standard plot style specifications,
% for example 'r-' for a red line.
%
% As optional third input, plots this in a user-specified figure. Returns
% the plot handle as the output. 
%
% FORMAT: 
%
%       cellArrayOfPlotHandles = fcn_Laps_plotSegmentZoneDefinition(zoneDefinition, (PlotStyle=plotStyle), (FigNum=figNum))
%
%      Optional inputs are given as Name=Value pairs after the required
%      inputs, in any order. Any option not given takes its default.
%
% INPUTS:
%
%      zoneDefinition: the definition of the zone as given in a 2x2 matrix
%      with the following format [Xstart Ystart; Xend Yend], where X,Y
%      denote the coordinates of the starting and ending point
%      respectively.
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
%      cellArrayOfPlotHandles: a [2 x 1] cell array of handles: {1} is the
%      segment line (DisplayName 'Segment zone definition') and {2} is the
%      direction arrow (DisplayName 'Segment zone direction').
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%      
%       See the script: script_test_fcn_Laps_plotSegmentZoneDefinition.m for
%       a full test suite.
%
% This function was written on 2022_04_10 by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% REVISION HISTORY:
%
% 2022_04_10 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotSegmentZoneDefinition
%   % * Wrote the code
% 
% 2022_04_12 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotSegmentZoneDefinition
%   % * Fixed minor bug with showing the arrowhead
% 
% 2022_07_23 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotSegmentZoneDefinition
%   % * Fixed minor bug with arrow being different color than line segment
%   % * Fixed major bug with arrow being in the wrong direction (!)
% 
% 2025_04_25 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotSegmentZoneDefinition
%   % * Added global debugging options
% 
% 2025_07_03 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotSegmentZoneDefinition
%   % * Cleanup of Debugging area codes
%   % * Turn on fast mode for Path calls
%
% 2026_11_18 by Sean Brennan, sbrennan@psu.edu
% - In fcn_Laps_plotSegmentZoneDefinition
%   % * Fixed errors in comments
%   % * Moved variables away from underscore convention
%   % * Standardized header comments into current convention
%   % * Fixed bug where calling without figNum opened an empty new figure
%   %   % and plotted nothing (flag_do_plots defaulted to 0). Now plots
%   %   % into the current figure when figNum is empty, omitted, or -1
%   % * Added missing semicolon on input check
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
% - In fcn_Laps_plotSegmentZoneDefinition
%   % * (fill in items here)



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

        % Check the zoneDefinition input that it has 2 columns, and exactly 2
        % rows
        fcn_DebugTools_checkInputsToFunctions(zoneDefinition, '2column_of_numbers',[2 2]);
    end
end

% Check for plot style input
flag_plotStyle_is_specified = 0; % Set default flag value
temp = options.PlotStyle;
if ~isempty(temp)
    plotStyle = temp;
    flag_plotStyle_is_specified = 1;
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
cellArrayOfPlotHandles = cell(2,1);

% Fill in the key data
Xstart = zoneDefinition(1,1);
Ystart = zoneDefinition(1,2);
Xend   = zoneDefinition(2,1);
Yend   = zoneDefinition(2,2);

% Calculate the unit vector
start_point = mean(zoneDefinition,1);
magnitude = sum((zoneDefinition(2,:)-zoneDefinition(1,:)).^2,2).^0.5;
unit_direction = (zoneDefinition(2,:)-zoneDefinition(1,:))./magnitude*[cos(pi/2) -sin(pi/2); sin(pi/2) cos(pi/2)];
vector_with_magnitude = unit_direction*magnitude/2; % Use smaller ratio to make it look good.

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
    % Prep the figure for plotting
    temp_h = figure(figNum);
    flag_rescale_axis = 0;
    if isempty(get(temp_h,'Children'))
        flag_rescale_axis = 1;
    end      
    
    % Is this 2D or 3D?
    dimension_of_points = 2; 

    % Find size of plotting domain
    allPoints = [Xstart Ystart; Xend Yend];

    max_plotValues = max(allPoints);
    min_plotValues = min(allPoints);
    sizePlot = max(max_plotValues) - min(min_plotValues);
    nudge = sizePlot*0.006; %#ok<NASGU>


    % Find size of plotting domain
    if flag_rescale_axis
        percent_larger = 0.1;
        axis_range = max_plotValues - min_plotValues;
        if (0==axis_range(1,1))
            axis_range(1,1) = 1/percent_larger;
        end
        if (0==axis_range(1,2))
            axis_range(1,2) = 1/percent_larger;
        end
        if dimension_of_points==3 && (0==axis_range(1,3))
            axis_range(1,3) = 1/percent_larger;
        end

        
        % Force the axis to be equal?
        if 1==0
            min_valuesInPlot = min(min_plotValues);
            max_valuesInPlot = max(max_plotValues);
        else
            min_valuesInPlot = min_plotValues;
            max_valuesInPlot = max_plotValues;
            
        end

        % Stretch the axes
        stretched_min_vertexValues = min_valuesInPlot - percent_larger.*axis_range;
        stretched_max_vertexValues = max_valuesInPlot + percent_larger.*axis_range;
        axesTogether = [stretched_min_vertexValues; stretched_max_vertexValues];
        newAxis = reshape(axesTogether, 1, []);
        axis(newAxis);

    end
    goodAxis = axis;

    % Check to see if hold is already on. If it is not, set a flag to turn it
    % off after this function is over so it doesn't affect future plotting
    flag_shut_hold_off = 0;
    if ~ishold
        flag_shut_hold_off = 1;
        hold on
    end

    grid on;
    axis equal;



    % Plot the line
    if flag_plotStyle_is_specified
        cellArrayOfPlotHandles{1,1} = plot([Xstart Xend],[Ystart Yend],plotStyle,'Markersize',20,'Linewidth',2,'DisplayName','Segment zone definition');
    else
        cellArrayOfPlotHandles{1,1} = plot([Xstart Xend],[Ystart Yend],'-','Linewidth',2,'DisplayName','Segment zone definition');
        main_color = get(cellArrayOfPlotHandles{1},'Color');
    end

    % Plot the direction arrow?
    if 1==1
        U = vector_with_magnitude(1,1);
        V = vector_with_magnitude(1,2);
        if flag_plotStyle_is_specified
            cellArrayOfPlotHandles{2,1} = quiver(start_point(1,1),start_point(1,2),U,V,0,plotStyle,'Linewidth',2,'Markersize',20,'ShowArrowHead','on','MaxHeadSize',2,'DisplayName','Segment zone direction');
        else
            cellArrayOfPlotHandles{2,1} = quiver(start_point(1,1),start_point(1,2),U,V,0,'color',main_color,'Linewidth',2,'Markersize',20,'ShowArrowHead','on','MaxHeadSize',2,'DisplayName','Segment zone direction');
        end
    end

    axis(goodAxis);

    % Shut the hold off?
    if flag_shut_hold_off
        hold off;
    end
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end


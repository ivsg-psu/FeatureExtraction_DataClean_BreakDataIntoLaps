function varargout = fcn_Laps_breakDataIntoLapIndices(...
    input_path,...
    start_zone_definition,...
    varargin)
%fcn_Laps_breakDataIntoLapIndices
%     fcn_Laps_breakDataIntoLapIndices(path,zone_definition) - gives
%     indices of each lap meeting the zone definition
%
% Given an input of "path" type, breaks data into laps by checking whether
% the data meet particular "zone" conditions to define the meaning of a
% lap. The function returns the indices of each lap as a cell array. Any
% entry and exit portions that are not full laps are also returned as
% optional output arguments. If no laps are detected, then the input path
% is assumed to be only an entry case and the cell_array_of_lap_indices is
% empty.
%
% The zone conditions to specify a lap can be given as either (1) points or
% (2) line segments. These conditions are used to define situations that
% start a lap, ends a lap, or defines an excursion as defined below. The
% end and excursion inputs are optional. If an optional end condition is
% not specified, then the start condition is used for both the start and
% end condition. If the excursion condition is not given, then no
% requirement for this is checked.
%
% The start_zone_definition condition defines how a lap should start,
% namely the conditions wherein the given path is beginning the lap.
% The XY point of the path immediately prior to the start condition
% being met is considered the start of the lap. Note: this can cause
% path indices to be repeated if laps are stacked onto each other after
% partitioning.
%
% The end_zone_definition condition, an optional input, defines how a lap
% should end, namely the conditions wherein the given path is ending
% the lap. The XY point of the path immediately after to the end
% condition being met is considered the end of the lap. Note: this can
% cause indices to be repeated as noted in the start condition.
%
% The excursion_zone_definition condition, an optional input, defines a
% condition that must be met after the start condition and before the end
% condition. This specification allows one to define an area away from the
% start and end condition that must be reached in order for the lap to be
% allowed to end. The end condition immediately after the excursion is
% considered the end of the lap.
%
% Of the two types of conditions, the definitions are as follows:
% (1) For point conditions, the inputs are condition = [radius num_points X
% Y] wherein X and Y specify the XY coordinates for the point, and radius
% specifies the radius from the point that the traversal must pass, and
% num_points specify the number of points that must be in the zone for the
% condition to be met. The minimum distance from the portion of the
% traversal within the radius to the XY point is considered the
% corresponding best condition.
%
% (2) For line segment conditions, the inputs are condition formatted as:
% [X_start Y_start; X_end Y_end] wherein start denotes the starting
% coordinate of the line segment, end denotes the ending coordinate of the
% line segment. For the condition to be met, the traversal must pass
% over the line segment, or directly through one of the end points.
% Further, the traversal must pass in the positive cross-product direction
% through the point, wherein the positive direction is denoted from the
% vector from start to end of the line segment.
%
% FORMAT:
%
%      [cell_array_of_lap_indices, ...
%       (cell_array_of_entry_indices, cell_array_of_exit_indices)] = ...
%      fcn_Laps_breakDataIntoLapIndices(...
%            input_traversal,...
%            start_zone_definition,...
%            (end_zone_definition),...
%            (excursion_zone_definition),...
%            (fig_num));
%
% INPUTS:
%
%      input_traversal: the traversal that is to be broken up into laps. It
%      is a traversals type consistent with the Paths library of functions.
%
%      start_zone_definition: the condition, defined as a point/radius or
%      line segment, defining the start condition to break the data into
%      laps. It is of one of two forms. A zone defined by a center point,
%      radius, and number of points that must past through that "circle",
%      given in a 1-row format as:
%
%        [zone_radius zone_num_points zone_center_x zone_center_y] (or)
%        [zone_radius zone_num_points zone_center_x zone_center_y
%        zone_center_z]
%
%      OR, a zone can be given by a segment defined by a start and end
%      point, given by two rows.
%
%        [zone_start_x zone_start_y; zone_end_x zone_end_y]
%      (NOTE: there's no 3-d equivalent of a starting line or finish line)
%
%      (OPTIONAL INPUTS)
%
%      end_zone_definition: the condition, defined as a point/radius or
%      line segment, defining the end condition to break the data into
%      laps. If not specified, the start condition is used. The same type
%      is used as the start_definition.
%
%      excursion_zone_definition: the condition, defined as a point/radius
%      or line segment, defining a situation that must be met between the
%      start and end conditions. If not specified, then no excursion point
%      is used. The same type is used as the start_definition.
%
%      fig_num: a figure number to plot results.
%
% OUTPUTS:
%
%      cell_array_of_lap_indices: a cell array containint the indices for
%      each lap
%
%      OPTIONAL OUTPUTS:
%
%      cell_array_of_entry_indices: a structure containing the indices
%      prior to each staring condition, that are not part of a lap.
%
%      cell_array_of_exit_indices: a structure containing the indices after
%      to each ending condition, that are not part of a lap.

%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%      fcn_Laps_checkZoneType
%      fcn_Laps_findPointZoneStartStopAndMinimum
%      fcn_Laps_findSegmentZoneStartStop
%      fcn_DebugTools_debugPrintStringToNCharacters
%
% EXAMPLES:
%
%     See the script: script_test_fcn_Laps_breakDataIntoLapIndices
%     for a full test suite.
%
% This function was written on 2022_07_23 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history:
% 2022_07_23 - sbrennan@psu.edu
% -- wrote the code originally, using breakDataIntoLaps as starter
% 2025_04_25 by Sean Brennan
% -- added global debugging options
% 2025_07_03 - S. Brennan
% -- cleanup of Debugging area codes
% -- turn on fast mode for Path calls
% 2025_07_05 - S. Brennan
% -- fixed poorly constructed input area (bad copy)

% TO-DO
% (none)

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 5; % The largest Number of argument inputs to the function
flag_max_speed = 0; % The default. This runs code with all error checking
if (nargin==MAX_NARGIN && isequal(varargin{end},-1))
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
    debug_fig_num = 999978; 
else
    debug_fig_num = []; 
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
        % Are there the right number of inputs?
        narginchk(2,MAX_NARGIN);

        % Check the input_path to be sure it has 2 or 3 columns, minimum 2 rows
        % or more
        fcn_DebugTools_checkInputsToFunctions(input_path, '2or3column_of_numbers',[2 3]);
    end
end



% Set the start values
[flag_start_is_a_point_type, start_zone_definition] = fcn_Laps_checkZoneType(start_zone_definition, 'start_definition', -1);


% The following area checks for variable argument inputs (varargin)

% Does the user want to specify the end_definition?
% Set defaults first:
end_zone_definition = start_zone_definition; % Default case
flag_end_is_a_point_type = flag_start_is_a_point_type; % Inheret the start case
% Check for user input
if 3 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        % Set the end values
        [flag_end_is_a_point_type, end_zone_definition] = fcn_Laps_checkZoneType(temp, 'end_definition', -1);
    end
end

% Does the user want to specify excursion_definition?
flag_use_excursion_definition = 0; % Default case
flag_excursion_is_a_point_type = 1; % Default case
if 4 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        % Set the excursion values
        [flag_excursion_is_a_point_type, excursion_definition] = fcn_Laps_checkZoneType(temp, 'excursion_definition',-1);
        flag_use_excursion_definition = 1;
    end
end

% Does user want to show the plots?
flag_do_plots = 0; % Default is to NOT show plots
if (0==flag_max_speed) && (MAX_NARGIN == nargin) 
    temp = varargin{end};
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        fig_num = temp;
        figure(fig_num);
        flag_do_plots = 1;
    end
end

% For debugging
flag_do_start_end = 1; % Flag to calculate the start and end segments

% Check the outputs
nargoutchk(0,3)

% Show results thus far
if flag_do_debug
    fprintf(1,'After variable checks, here are the flags: \n');
    fprintf(1,'Flag: flag_start_is_a_point_type = \t\t%d\n',flag_start_is_a_point_type);
    fprintf(1,'Flag: flag_end_is_a_point_type = \t\t%d\n',flag_end_is_a_point_type);
    fprintf(1,'Flag: flag_use_excursion_definition = \t%d\n',flag_use_excursion_definition);
    fprintf(1,'Flag: flag_excursion_is_a_point_type = \t%d\n',flag_excursion_is_a_point_type);
end


%% Main code starts here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fill deafults
cell_array_of_lap_indices = {};
cell_array_of_entry_indices = {};
cell_array_of_exit_indices = {};


% Steps used:
% 1) extract the path, and create an array that is all zeros the same
% length of the path
% 2) find the start, excursion, and end possibilities and label them as 1,
% 2, and 3 respectively in the array. Keep track of the zones where start
% and end zones occur, as need to sometimes search backwards in next step
% 3) progress through the array, matching the start, to transition, to end.
% At each end, rewind back to the start of that end's zone so we can look
% for the next start
% 4) save results out to arrays.

%% Step 1
% extract the path, and create an array that is all zeros the same length
% of the path

% Grab the XY data out of the variable
path_original = input_path(:,1:2);
path_flag_array = zeros(length(input_path(:,1)),1);
Npoints = length(path_original(:,1));

%% Step 2
% find the start, excursion, and end possibilities and label them as 1,
% 2, and 3 respectively in the array. Keep track of the zones where start
% and end zones occur, as need to sometimes search backwards in next step

flag_keep_going = 0; % Default is to assume there is no start zones yet, as there's no sense to keep going if not

% Do start zone calculations
if flag_start_is_a_point_type==1
    % Define start zone and indices based on point zone type:
    % A point zone is the location meeting the distance criteria, and where
    % the path has at least minimum_width points inside the given area.
    % Among these points, find the minimum distance index. The start point
    % is the index immediately prior to the minimum.
    
    zone_center = start_zone_definition(1,3:end);
    zone_radius = start_zone_definition(1,1);
    zone_num_points = start_zone_definition(1,2);
    
    [start_zone_start_indices, start_zone_end_indices, start_zone_min_indices] = ...
        fcn_Laps_findPointZoneStartStopAndMinimum(...
        path_original,...
        zone_center,...
        zone_radius,...
        zone_num_points,...
        -1);
    
    start_indices = start_zone_min_indices + 1;
    path_flag_array(start_indices,1) = 1;
    
    if ~isempty(start_zone_start_indices) % No minimum detected, so no laps exist
        flag_keep_going = 1;
    end
    
else % Define start zone and indices based on segment zone type
    
    [start_zone_start_indices, start_zone_end_indices] = ...
        fcn_Laps_findSegmentZoneStartStop(...
        path_original,...
        start_zone_definition,...
        -1);
    start_zone_min_indices = start_zone_start_indices; %#ok<*NASGU>
    
    path_flag_array(start_zone_start_indices,1) = 1;
    
    if ~isempty(start_zone_start_indices) % No start zone detected, so no laps exist
        flag_keep_going = 1;
    end
end

% Do excursion zone calculations
if flag_keep_going
    if flag_use_excursion_definition
        flag_keep_going = 0; % Default is to assume there is no excursion zones yet, as there's no sense to keep going if not
        if flag_excursion_is_a_point_type==1
            % Define excursion zone and indices,
            % A zone is the location meeting the distance criteria, and where the path
            % has at least 3 points inside the given area. Among these three points,
            % find the minimum distance index.
            
            %             [excursion_zone, min_indices] = INTERNAL_fcn_Laps_findZoneStartStopAndMinimum(...
            %                 path_original,...
            %                 excursion_definition,...
            %                 minimum_width);
            zone_center = excursion_definition(1,3:end);
            zone_radius = excursion_definition(1,1);
            zone_num_points = excursion_definition(1,2);
            
            [excursion_zone_start_indices, excursion_zone_end_indices, excursion_zone_min_indices] = ...
                fcn_Laps_findPointZoneStartStopAndMinimum(...
                path_original,...
                zone_center,...
                zone_radius,...
                zone_num_points,...
                -1);
            
            if ~isempty(excursion_zone_start_indices) % No minimum detected, so no laps exist
                flag_keep_going = 1;
            end
            
            path_flag_array(excursion_zone_min_indices,1) = 2;
        else % It's a line segement type
            [excursion_zone_start_indices, excursion_zone_end_indices] = ...
                fcn_Laps_findSegmentZoneStartStop(...
                path_original,...
                excursion_definition,...
                -1);
            excursion_zone_min_indices = excursion_zone_start_indices;
            
            path_flag_array(excursion_zone_min_indices,1) = 2;
            
            if ~isempty(start_zone_start_indices) % No excursion zone detected, so no laps exist
                flag_keep_going = 1;
            end
        end
    else % No excursion zones given, so default to the indices after the start zone
        excursion_zone_start_indices = min(start_zone_end_indices+1,Npoints);
        excursion_zone_end_indices = min(start_zone_end_indices+1,Npoints);
        excursion_zone_min_indices = min(start_zone_end_indices+1,Npoints);
        
    end
end % Ends check to see if keep going

% Do end zone calculations
if flag_keep_going
    flag_keep_going = 0; % Default is to assume there is no end zones yet, as there's no sense to keep going if not
    if flag_end_is_a_point_type==1
        % Define end zone and indices, A zone is the location meeting the
        % distance criteria, and where the path has at least 3 points
        % inside the given area. Among these three points, find the minimum
        % distance index. The end zone finishes the point after the
        % minimum.
        
        
        zone_center = end_zone_definition(1,3:end);
        zone_radius = end_zone_definition(1,1);
        zone_num_points = end_zone_definition(1,2);
        
        [end_zone_start_indices, end_zone_end_indices, end_zone_min_indices] = ...
            fcn_Laps_findPointZoneStartStopAndMinimum(...
            path_original,...
            zone_center,...
            zone_radius,...
            zone_num_points,...
            -1);
        
        if ~isempty(end_zone_start_indices) % No minimum detected, so no laps exist
            flag_keep_going = 1;
        end
        end_indices = end_zone_min_indices + 1;
        path_flag_array(end_indices,1) = 3; 
        
    else % Segment type
        [end_zone_start_indices, end_zone_end_indices] = ...
            fcn_Laps_findSegmentZoneStartStop(...
            path_original,...
            end_zone_definition,...
            -1);
        end_zone_min_indices = end_zone_start_indices;
        
        end_indices = end_zone_min_indices + 1;
        path_flag_array(end_indices,1) = 3; 
        
        if ~isempty(end_zone_start_indices) % No excursion zone detected, so no laps exist
            flag_keep_going = 1;
        end
    end
end % Ends check to see if keep going

%% Step 3
% progress through the array, matching the start, to transition, to end.

% The process is set up to loop from the start of the path all the way to
% the end using a forced-increment while loop. This avoids lock-up if
% something goes wrong, but requires the for loop index to be shifted after
% an entire lap is found. The process is set up as a series of if
% statements that look for the following sequence order to define a
% complete lap:
%
% start index
% find minimum index in start zone and record index before minimum - this
% is the start of the lap
% end of start zone
% excursion index
% end of exursion zone (use end of start zone if excursions not used)
% end index
% find minimum index in end zone and record index after minimum - this is
% the end of the lap
% start of end zone
%
% Once a lap is found, the loop is rewound back to the start of the last
% end-index zone, in case the next start point is hiding in there

%% Summarize where we are:

if flag_do_debug
    print_width = 20;
    fprintf(1,'\n');
    fprintf(1,'Summary of Zone results:\n');
    fprintf(1,'Start Zone Indices:\n');
    H1 = sprintf('%s','Start');
    H2 = sprintf('%s','End');
    H3 = sprintf('%s','Minimum');
    short_H1 = fcn_DebugTools_debugPrintStringToNCharacters(H1,print_width);
    short_H2 = fcn_DebugTools_debugPrintStringToNCharacters(H2,print_width);
    short_H3 = fcn_DebugTools_debugPrintStringToNCharacters(H3,print_width);
    fprintf(1,'%s %s %s\n',short_H1, short_H2, short_H3);
    for ith_index = 1:length(start_zone_start_indices)
        T1 = sprintf('%d',start_zone_start_indices(ith_index));
        T2 = sprintf('%d',start_zone_end_indices(ith_index));
        T3 = sprintf('%d',start_zone_min_indices(ith_index));
        short_T1 = fcn_DebugTools_debugPrintStringToNCharacters(T1,print_width);
        short_T2 = fcn_DebugTools_debugPrintStringToNCharacters(T2,print_width);
        short_T3 = fcn_DebugTools_debugPrintStringToNCharacters(T3,print_width);
        fprintf(1,'%s %s %s\n',short_T1, short_T2, short_T3);
    end
    
    fprintf(1,'\n');
    fprintf(1,'Excursion Zone Indices:\n');
    fprintf(1,'%s %s %s\n',short_H1, short_H2, short_H3);
    try
        for ith_index = 1:length(excursion_zone_start_indices)
            T1 = sprintf('%d',excursion_zone_start_indices(ith_index));
            T2 = sprintf('%d',excursion_zone_end_indices(ith_index));
            T3 = sprintf('%d',excursion_zone_min_indices(ith_index));
            short_T1 = fcn_DebugTools_debugPrintStringToNCharacters(T1,print_width);
            short_T2 = fcn_DebugTools_debugPrintStringToNCharacters(T2,print_width);
            short_T3 = fcn_DebugTools_debugPrintStringToNCharacters(T3,print_width);
            fprintf(1,'%s %s %s\n',short_T1, short_T2, short_T3);
        end
    catch
        fprintf('None detected');
    end
    
    fprintf(1,'\n');
    fprintf(1,'End Zone Indices:\n');
    fprintf(1,'%s %s %s\n',short_H1, short_H2, short_H3);
    try
        for ith_index = 1:length(end_zone_start_indices)
            T1 = sprintf('%d',end_zone_start_indices(ith_index));
            T2 = sprintf('%d',end_zone_end_indices(ith_index));
            T3 = sprintf('%d',end_zone_min_indices(ith_index));
            short_T1 = fcn_DebugTools_debugPrintStringToNCharacters(T1,print_width);
            short_T2 = fcn_DebugTools_debugPrintStringToNCharacters(T2,print_width);
            short_T3 = fcn_DebugTools_debugPrintStringToNCharacters(T3,print_width);
            fprintf(1,'%s %s %s\n',short_T1, short_T2, short_T3);
        end
    catch
        fprintf('None detected');
    end
end

%%  Loop through each start points, checking for next excursion and end point

% Initialize our test laps as a N x 3 NaN matrix to store results
% The first column is the start index of each lap, first point in startzone
% The second column is the first point within the excursion zone
% The third column is the end index of each lap, last point in the endzone
test_laps = nan(length(start_zone_start_indices),3);
last_end = 0;
Nlaps = 0;
for ith_start = 1:length(start_zone_start_indices)
    % Start point must be greater than or equal to last end point
    if start_zone_start_indices(ith_start)>=last_end
        test_laps(ith_start,1) = start_zone_start_indices(ith_start);
        % Excursion point must be greater than or equal to last start point
        next_excursionzone   = find(excursion_zone_start_indices>=test_laps(ith_start,1),1,'first');
        if ~isempty(next_excursionzone)
            test_laps(ith_start,2) = excursion_zone_end_indices(next_excursionzone);
            % End point must be greater than or equal to last excursion point
            next_endzone   = find(end_zone_start_indices>=test_laps(ith_start,2),1,'first');
            if ~isempty(next_endzone)
                % Current lap ends at END of current endzone
                test_laps(ith_start,3) = end_zone_end_indices(next_endzone);
                % Start next search point at the START of the current
                % endzone
                last_end = end_zone_start_indices(next_endzone);
            end
        end
    end
    % Count the number of complete laps
    if all(~isnan(test_laps(ith_start,:)))
        Nlaps = Nlaps+1;
    end
end

%% Summarize results to this point
if flag_do_debug
    print_width = 20;
    fprintf(1,'\n');
    fprintf(1,'Summary of Test Lap results:\n');
    H1 = sprintf('%s','Start');
    H2 = sprintf('%s','Transition');
    H3 = sprintf('%s','End');
    short_H1 = fcn_DebugTools_debugPrintStringToNCharacters(H1,print_width);
    short_H2 = fcn_DebugTools_debugPrintStringToNCharacters(H2,print_width);
    short_H3 = fcn_DebugTools_debugPrintStringToNCharacters(H3,print_width);
    fprintf(1,'%s %s %s\n',short_H1, short_H2, short_H3);
    for ith_index = 1:length(test_laps(:,1))
        T1 = sprintf('%d',test_laps(ith_index,1));
        T2 = sprintf('%d',test_laps(ith_index,2));
        T3 = sprintf('%d',test_laps(ith_index,3));
        short_T1 = fcn_DebugTools_debugPrintStringToNCharacters(T1,print_width);
        short_T2 = fcn_DebugTools_debugPrintStringToNCharacters(T2,print_width);
        short_T3 = fcn_DebugTools_debugPrintStringToNCharacters(T3,print_width);
        fprintf(1,'%s %s %s\n',short_T1, short_T2, short_T3);
    end
    fprintf(1,'Number of comlete laps: %d\n',Nlaps);
end

%% Save everything in a laps array - this is an array of ONLY complete laps
if Nlaps>0
    laps_array = zeros(Nlaps,3);
    current_lap = 1;
    for ith_test_lap = 1:length(test_laps(:,1))
        % Count the number of complete laps
        if all(~isnan(test_laps(ith_test_lap,:)))
            laps_array(current_lap,:) = test_laps(ith_test_lap,:);
            current_lap = current_lap + 1;
        end
    end
else
    laps_array = []; % Make it empty
end

%% Summarize results to this point
if flag_do_debug
    print_width = 20;
    fprintf(1,'\n');
    fprintf(1,'Summary of Final Lap results:\n');
    if Nlaps>0
        H1 = sprintf('%s','Start');
        H2 = sprintf('%s','Transition');
        H3 = sprintf('%s','End');
        short_H1 = fcn_DebugTools_debugPrintStringToNCharacters(H1,print_width);
        short_H2 = fcn_DebugTools_debugPrintStringToNCharacters(H2,print_width);
        short_H3 = fcn_DebugTools_debugPrintStringToNCharacters(H3,print_width);
        fprintf(1,'%s %s %s\n',short_H1, short_H2, short_H3);
        for ith_index = 1:length(laps_array(:,1))
            T1 = sprintf('%d',laps_array(ith_index,1));
            T2 = sprintf('%d',laps_array(ith_index,2));
            T3 = sprintf('%d',laps_array(ith_index,3));
            short_T1 = fcn_DebugTools_debugPrintStringToNCharacters(T1,print_width);
            short_T2 = fcn_DebugTools_debugPrintStringToNCharacters(T2,print_width);
            short_T3 = fcn_DebugTools_debugPrintStringToNCharacters(T3,print_width);
            fprintf(1,'%s %s %s\n',short_T1, short_T2, short_T3);
        end
    end
    fprintf(1,'Number of complete laps: %d\n',Nlaps);
end
%% Step 4
% save results out to arrays.

if flag_keep_going && Nlaps>0
    
    % Fill in the laps
    cell_array_of_lap_indices{Nlaps} = [];
    for ith_lap = 1:Nlaps
        cell_array_of_lap_indices{ith_lap} = (laps_array(ith_lap,1):laps_array(ith_lap,3))';
    end
    
    
    % Update the fragments?
    if flag_do_start_end
        % Initialize arrays
        cell_array_of_entry_indices{Nlaps} = [];
        cell_array_of_exit_indices{Nlaps} = [];
        
        for ith_lap = 1:Nlaps
            % First lap?
            if ith_lap > 1
                cell_array_of_entry_indices{ith_lap} = (laps_array(ith_lap-1,3):laps_array(ith_lap,1))';
            else  % It is the first lap
                cell_array_of_entry_indices{ith_lap} = (1:laps_array(ith_lap,1))';
            end
            % Last lap?
            if ith_lap<Nlaps
                cell_array_of_exit_indices{ith_lap} = (laps_array(ith_lap,3):laps_array(ith_lap+1,1))';
            else % Yes, it is the last lap
                cell_array_of_exit_indices{ith_lap} = (laps_array(ith_lap,3):length(input_path(:,1)))';
            end
        end
    end
    
end % Ends check to see if keep going

% Save outputs depending on which ones the user asks for
if nargout >= 1
    varargout{1} = cell_array_of_lap_indices;
end
if nargout >=2
    varargout{2} = cell_array_of_entry_indices;
end
if nargout >=3
    varargout{3} = cell_array_of_exit_indices;
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
    figure(fig_num);
    clf;
    
    % Everything put together
    subplot(1,2,1);
    hold on;
    grid on
    title('Results of breaking data into laps');
    
    
    
    % Plot the indices per lap
    all_ones = ones(length(input_path(:,1)),1);
    
    % fill in data
    start_of_lap_x = [];
    start_of_lap_y = [];
    lap_x = [];
    lap_y = [];
    end_of_lap_x = [];
    end_of_lap_y = [];
    for ith_lap = 1:Nlaps
        start_of_lap_x = [start_of_lap_x; cell_array_of_entry_indices{ith_lap}; NaN]; %#ok<AGROW>
        start_of_lap_y = [start_of_lap_y; all_ones(cell_array_of_entry_indices{ith_lap})*ith_lap; NaN]; %#ok<AGROW>;
        lap_x = [lap_x; cell_array_of_lap_indices{ith_lap}; NaN]; %#ok<AGROW>
        lap_y = [lap_y; all_ones(cell_array_of_lap_indices{ith_lap})*ith_lap; NaN]; %#ok<AGROW>;
        end_of_lap_x = [end_of_lap_x; cell_array_of_exit_indices{ith_lap}; NaN]; %#ok<AGROW>
        end_of_lap_y = [end_of_lap_y; all_ones(cell_array_of_exit_indices{ith_lap})*ith_lap; NaN]; %#ok<AGROW>;
    end
    
    % Plot results
    plot(start_of_lap_x,start_of_lap_y,'g-','Linewidth',3,'DisplayName','Prelap');
    plot(lap_x,lap_y,'b-','Linewidth',3,'DisplayName','Lap');
    plot(end_of_lap_x,end_of_lap_y,'r-','Linewidth',3,'DisplayName','Postlap');
    
    h_legend = legend;
    set(h_legend,'AutoUpdate','off');
    
    xlabel('Indices');
    ylabel('Lap number');
    axis([0 length(input_path(:,1)) 0 Nlaps+0.5]);
    
    
    subplot(1,2,2);
    % Plot the XY coordinates of the traversals
    hold on;
    grid on
    title('Results of breaking data into laps');
    axis equal
    
    cellArrayOfPathsToPlot = cell(Nlaps+1,1);
    cellArrayOfPathsToPlot{1,1}     = input_path;
    for ith_lap = 1:Nlaps
        temp_indices = cell_array_of_lap_indices{ith_lap};
        if length(temp_indices)>1
            dummy_path = input_path(temp_indices,:);
        else
            dummy_path = [];
        end
        cellArrayOfPathsToPlot{ith_lap+1,1} = dummy_path;
    end
    h = fcn_Laps_plotLapsXY(cellArrayOfPathsToPlot,fig_num);
    
    % Make input be thin line
    set(h(1),'Color',[0 0 0],'Marker','none','Linewidth', 0.75);
    
    % Make all the laps have thick lines
    for ith_plot = 2:(length(h))
        set(h(ith_plot),'Marker','none','Linewidth', 5);
    end
    
    % Add legend
    legend_text = {};
    legend_text = [legend_text, 'Input path'];
    for ith_lap = 1:Nlaps
        legend_text = [legend_text, sprintf('Lap %d',ith_lap)]; %#ok<AGROW>
    end
    
    h_legend = legend(legend_text);
    set(h_legend,'AutoUpdate','off');
    
    
    
    %     % Plot the start, excursion, and end conditions
    %     % Start point in green
    %     if flag_start_is_a_point_type==1
    %         Xcenter = start_zone_definition(1,1);
    %         Ycenter = start_zone_definition(1,2);
    %         radius  = start_zone_definition(1,3);
    %         INTERNAL_plot_circle(Xcenter, Ycenter, radius, [0 .7 0], 4);
    %     end
    %
    %     % End point in red
    %     if flag_end_is_a_point_type==1
    %         Xcenter = end_definition(1,1);
    %         Ycenter = end_definition(1,2);
    %         radius  = end_definition(1,3);
    %         INTERNAL_plot_circle(Xcenter, Ycenter, radius, [0.7 0 0], 2);
    %     end
    %     legend_text = [legend_text, 'Start condition'];
    %     legend_text = [legend_text, 'End condition'];
    %     h_legend = legend(legend_text);
    %     set(h_legend,'AutoUpdate','off');
    
    % Plot start zone
    h_start_zone = fcn_Laps_plotZoneDefinition(start_zone_definition,'g-',fig_num);

    % Plot end zone
    h_end_zone = fcn_Laps_plotZoneDefinition(end_zone_definition,'r-',fig_num);

    
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

% function INTERNAL_plot_circle(center_x, center_y, radius, color, linewidth)
% 
% % Plot the center point
% % plot(center_x,center_y,'ro','Markersize',22);
% 
% % Plot circle
% angles = 0:0.01:2*pi;
% x_circle = center_x + radius * cos(angles);
% y_circle = center_y + radius * sin(angles);
% plot(x_circle,y_circle,'-','color',color,'Linewidth',linewidth);
% end

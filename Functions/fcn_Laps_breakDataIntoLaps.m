function [lap_traversals, entry_traversal,exit_traversal] = fcn_Laps_breakDataIntoLaps(...
    input_traversal,...
    start_definition,...
    varargin)
% fcn_Laps_breakDataIntoLaps
% Given an input of "traversal" type, breaks data into laps using the XY
% data of the traversal by checking whether the data meet particular
% conditions to define the meaning of a lap. The function returns the laps
% as an array "traversals" type, with each traversal being one lap. Any
% entry and exit portions that are not full laps are also returned as
% traversal types. If no laps are detected, then the input traversl is
% assumed to be only an entry traversal and the lap_traversals is empty.
%
% The conditions to specify a lap can be given as either (1) points or (2)
% line segments. These conditions are used to define situations that start
% a lap, ends a lap, or defines an excursion as defined below. The end and
% excursion inputs are optional. If an optional end condition is not
% specified, then the start condition is used for both the start and end
% condition. If the excursion condition is not given, then no requirement
% for this is needed.
% 
% The start condition defines how a lap should start, namely the conditions
% wherein the given traversal is beginning the lap. The XY point of the
% traversal immediately prior to the start condition being met is
% considered the start of the lap. Note: this can cause station points to
% be repeated if laps are stacked onto each other after partitioning.
% 
% The end condition, an optional input, defines how a lap should end,
% namely the conditions wherein the given traversal is ending the lap. The
% XY point of the traversal immediately after to the end condition being
% met is considered the end of the lap. Note: this can cause station points
% to be repeated as noted in the start condition.
%
% The excursion condition, an optional input, defines a condition that must
% be met after the start condition and before the end condition. This
% specification allows one to define an area away from the start and end
% condition that must be reached in order for the lap to be allowed to end.
% The end condition immediately after the excursion is considered the end
% of the lap.
%
% Of the two types of conditions, the definitions are as follows:
% (1) For point conditions, the inputs are condition = [X Y radius] wherein
% X and Y specify the XY coordinates for the point, and radius specifies
% the radius from the point that the traversal must pass for the condition
% to be met. The minimum distance from the portion of the traversal within
% the radius to the XY point is considered the corresponding best
% condition. Because a minimum is used, at least 3 points of the traversal
% must be within the minimum radius, in sequence, for the condition to be
% met.
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
%      [lap_traversals, input_and_exit_traversals] = ...
%      fcn_Laps_breakDataIntoLaps(...
%            input_traversal,...
%            start_definition,...
%            (end_definition),...
%            (excursion_definition),...
%            (fig_num));
%
% INPUTS:
%
%      input_traversal: the traversal that is to be broken up into laps. It
%      is a traversals type consistent with the Paths library of functions.
%
%      start_definition: the condition, defined as a point/radius or line
%      segment, defining the start condition to break the data into laps.
% 
%      (OPTIONAL INPUTS)
%
%      end_definition: the condition, defined as a point/radius or line
%      segment, defining the end condition to break the data into laps.
% 
%      excursion_definition: the condition, defined as a point/radius or
%      line segment, defining a situation that must be met between the
%      start and end conditions
%
%      fig_num: a figure number to plot results.
%
% OUTPUTS:
%
%      lap_traversals: a structure containing the resulting laps, with each
%      lap being a traversal
%
%      entry_traversal: a structure containing the portion of the
%      traversal that is prior to the first staring condition.
%
%      exit_traversal: a structure containing the portion of the
%      traversal that is after the last ending condition. 

%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
%      fcn_Path_calcSingleTraversalStandardDeviation
%      fcn_Path_findOrthogonalTraversalVectorsAtStations
%      fcn_Path_convertPathToTraversalStructure
%      fcn_Path_plotTraversalsXY
%
% EXAMPLES:
%
%     See the script: script_test_fcn_Laps_breakDataIntoLaps
%     for a full test suite.
%
% This function was written on 2022_04_03 by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% Revision history:
%     
%     2022_04_03: 
%     -- wrote the code originally 

% TO DO
% 

flag_do_debug = 0; % Flag to show the results for debugging
flag_do_plots = 0; % % Flag to plot the final results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end


%% check input arguments
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


%% Set defaults


%% Check inputs?
if flag_check_inputs
    % Are there the right number of inputs?
    if nargin < 2 || nargin > 5
        error('Incorrect number of input arguments')
    end
        
    % Check the reference_traversal variables
    fcn_DebugTools_checkInputsToFunctions(input_traversal, 'traversal');
    
    % Check the start definition required input
    try
        fcn_DebugTools_checkInputsToFunctions(start_definition, '3column_of_numbers',[1 1]);
    catch
        try
            fcn_DebugTools_checkInputsToFunctions(start_definition, '2column_of_numbers',[2 2]);
        catch
            error('The start_definition input must be either a 3x1 variable, in the case of a point, or a 2x2 variable, in the case of a line segment.');
        end
    end

end

% Set the start values
if size(start_definition)==[1 3]
    flag_start_is_a_point_type = 1;
elseif size(start_definition)==[2 2]
    flag_start_is_a_point_type = 0;
else
    error('The start_definition input must be either a 3x1 variable, in the case of a point, or a 2x2 variable, in the case of a line segment.');    
end

        
% Check for variable argument inputs (varargin)
% Does the user want to specify the end_definition?
% Set defaults first:
end_definition = start_definition; % Default case
flag_end_is_a_point_type = flag_start_is_a_point_type; % Inheret the start case
% Check for user input
if 3 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        end_definition = temp;
        try
            fcn_DebugTools_checkInputsToFunctions(end_definition, '3column_of_numbers',[1 1]);
            flag_end_is_a_point_type = 1; %#ok<*NASGU>
        catch
            try
                fcn_DebugTools_checkInputsToFunctions(end_definition, '2column_of_numbers',[2 2]);
                flag_end_is_a_point_type = 0;
            catch
                error('The end_definition input must be either a 3x1 variable, in the case of a point, or a 2x2 variable, in the case of a line segment.');
            end
        end
        
    end
end


% Does the user want to specify excursion_definition?
flag_use_excursion_definition = 0; % Default case
flag_excursion_is_a_point_type = 1; % Default case
if 4 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        flag_use_excursion_definition = 1; 
        excursion_definition = temp;
        try
            fcn_DebugTools_checkInputsToFunctions(excursion_definition, '3column_of_numbers',[1 1]);
            flag_excursion_is_a_point_type = 1; %#ok<*NASGU>
        catch
            try
                fcn_DebugTools_checkInputsToFunctions(excursion_definition, '2column_of_numbers',[2 2]);
                flag_excursion_is_a_point_type = 0;
            catch
                error('The excursion_definition input must be either a 3x1 variable, in the case of a point, or a 2x2 variable, in the case of a line segment.');
            end
        end
        
    end
end

% Does user want to show the plots?
if 5 == nargin
    fig_num = varargin{end};
    figure(fig_num);
    flag_do_plots = 1;
else
    if flag_do_debug
        fig = figure;
        fig_num = fig.Number;
        flag_do_plots = 1;
    end
end

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
entry_traversal = input_traversal;
exit_traversal = [];
lap_traversals = [];

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
path_original = [input_traversal.X input_traversal.Y];
path_flag_array = zeros(length(input_traversal.X(:,1)),1);

%% Step 2
% find the start, excursion, and end possibilities and label them as 1,
% 2, and 3 respectively in the array. Keep track of the zones where start
% and end zones occur, as need to sometimes search backwards in next step

minimum_width = 3;

if flag_start_is_a_point_type==1
    % Define start zone and indices,
    % A zone is the location meeting the distance criteria, and where the path
    % has at least minimum_width points inside the given area. Among these points,
    % find the minimum distance index. The minimum cannot be the first or
    % last point.
    [start_zone, min_indices] = INTERNAL_fcn_Laps_findZoneStartStopAndMinimum(...
        path_original,...
        start_definition,...
        minimum_width);
    if isempty(min_indices) % No minimum detected, so no laps exist
        return
    end
    start_indices = min_indices -1;
    path_flag_array(start_indices,1) = 1;
else
end

if flag_use_excursion_definition
    if flag_excursion_is_a_point_type==1
        % Define excursion zone and indices,
        % A zone is the location meeting the distance criteria, and where the path
        % has at least 3 points inside the given area. Among these three points,
        % find the minimum distance index.
        [excursion_zone, min_indices] = INTERNAL_fcn_Laps_findZoneStartStopAndMinimum(...
            path_original,...
            excursion_definition,...
            minimum_width);
        if isempty(min_indices) % No minimum detected, so no laps exist
            return
        end
        excursion_indices = min_indices;
        path_flag_array(excursion_indices,1) = 2;
    else
    end
else
    
end


if flag_end_is_a_point_type==1
    % Define end zone and indices,
    % A zone is the location meeting the distance criteria, and where the path
    % has at least 3 points inside the given area. Among these three points,
    % find the minimum distance index.
    [end_zone, min_indices] = INTERNAL_fcn_Laps_findZoneStartStopAndMinimum(...
        path_original,...
        end_definition,...
        minimum_width);
    if isempty(min_indices) % No minimum detected, so no laps exist
        return
    end
    end_indices = min_indices + 1;
    path_flag_array(end_indices,1) = 3;
else
end

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
% end of start zone
% excursion index
% end of exursion zone (use end of start zone if excursions not used)
% end index
%
% Once a lap is found, the loop is rewound back to the start of the last
% end-index zone, in case the next start point is hiding in there

num_laps = 0;
last_lap_end_index = length(path_flag_array);
first_fragment_indicies.start = 1;
last_fragment_indicies.start = 1;
first_fragment_indicies.end = length(path_flag_array);
last_fragment_indicies.end = length(path_flag_array);

ith_index = 1; % Initialize result
while (ith_index<length(path_flag_array))
    ith_index = ith_index+1;
    
    % Find the next start index
    next_start_index = (ith_index-1) + find(path_flag_array(ith_index:end,1)==1,1,'first');
    if ~isempty(next_start_index)
        % Find where we leave the start zone
        startzone_end_point = (next_start_index-1) + find(start_zone(next_start_index:end,1)~=1,1,'first');
        if ~isempty(startzone_end_point)
            % Find the excursion point and zone?
            if flag_use_excursion_definition
                next_excursion_index = (startzone_end_point-1) + find(path_flag_array(startzone_end_point:end,1)==2,1,'first');
                if ~isempty(next_excursion_index)
                    % Find where we leave excursion zone
                    excursionzone_end_point = (next_excursion_index-1) + find(excursion_zone(next_excursion_index:end,1)~=1,1,'first');
                else                    
                    % No more laps to find since no more end indices - exit the loop
                    last_fragment_indicies.start = last_lap_end_index;
                    break;
                end            
            else
                excursionzone_end_point = startzone_end_point;
            end % Ends flag to check excursion zone
            % Find the next end index
            next_end_index = (excursionzone_end_point-1) + find(path_flag_array(excursionzone_end_point:end,1)==3,1,'first');
            if ~isempty(next_end_index)
                % A complete lap was found!
                if 0==num_laps
                    first_fragment_indicies.end = next_start_index-1;
                end
                
                num_laps = num_laps+1;
                lap_indices(num_laps).start = next_start_index; %#ok<AGROW>
                lap_indices(num_laps).end = next_end_index; %#ok<AGROW>
                last_lap_end_index = next_end_index;
                
                % Reset the loop to start of current end zone, just in case
                % next start point is INSIDE the current end zone. This is
                % such a weird way to program that have to tell MATLAB not
                % to throw an error.
                ith_index = (excursionzone_end_point-1) + find(end_zone(excursionzone_end_point:end,1)==1,1,'first'); %#ok<FXSET>
            else
                % No more laps to find since no more end indices - exit the loop
                last_fragment_indicies.start = last_lap_end_index;
                break;
            end  
        else
            % No more laps to find since no more end indices - exit the loop
            last_fragment_indicies.start = last_lap_end_index;
            break
        end % Ends check if start zone is empty
    else              
        % No more laps to find since no more start indices - exit the loop
        last_fragment_indicies.start = last_lap_end_index;
        break;
    end % Ends check if next start index is empty or not
end % Ends for loop

%% Step 4
% save results out to arrays.
start_path = path_original(first_fragment_indicies.start:first_fragment_indicies.end,:);
end_path = path_original(last_fragment_indicies.start:last_fragment_indicies.end,:);


entry_traversal = fcn_Path_convertPathToTraversalStructure(start_path);
if length(end_path(:,1))>1
    exit_traversal = fcn_Path_convertPathToTraversalStructure(end_path);
end

lap_traversals = [];
for ith_lap = 1:num_laps
    lap_path = path_original(lap_indices(ith_lap).start:lap_indices(ith_lap).end,:);
    lap_traversals.traversal{ith_lap} = fcn_Path_convertPathToTraversalStructure(lap_path);
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
    hold on;
    grid on
    axis equal
    
    % Plot the reference trajectory first
    data.traversal{1} = input_traversal;
    fcn_Laps_plotLapsXY(data,fig_num);

    % Plot the start, excursion, and end conditions
    % Start point in green
    if flag_start_is_a_point_type==1
        Xcenter = start_definition(1,1);
        Ycenter = start_definition(1,2);
        radius  = start_definition(1,3);
        % Plot the center point
        plot(Xcenter,Ycenter,'go','Markersize',20);
        
        % Plot circle
        angles = 0:0.01:2*pi;        
        x_circle = Xcenter + radius * cos(angles);
        y_circle = Ycenter + radius * sin(angles);
        plot(x_circle,y_circle,'color',[0 .7 0]);
                
    end
    
    % End point in red
    if flag_end_is_a_point_type==1
        Xcenter = end_definition(1,1);
        Ycenter = end_definition(1,2);
        radius  = end_definition(1,3);
        % Plot the center point
        plot(Xcenter,Ycenter,'ro','Markersize',22);
        
        % Plot circle
        angles = 0:0.01:2*pi;        
        x_circle = Xcenter + radius * cos(angles);
        y_circle = Ycenter + radius * sin(angles);
        plot(x_circle,y_circle,'--','color',[0.7 0 0]);
                
    end
    
    %
    %     % Plot the random results
    %     fcn_Path_plotTraversalsXY(random_traversals,fig_num);
    %     title('Reference traversal and random traversals');
    %     xlabel('X [m]');
    %     ylabel('Y [m]');
        
    
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

% Define lap zone and indices, used for point searches
function [zone_start_indices, zone_end_indices, zone_min_indices] = INTERNAL_fcn_Laps_findZoneStartStopAndMinimum(...
    path_original,...
    zone_definition,...
    minimum_width)
% A zone is the location meeting the distance criteria, and where the path
% has at least minimum_width points inside the given area. 

% Set default values

zone_min_indices = [];
zone_start_indices = [];
zone_end_indices = [];

% Among these points, find the minimum distance index. The minimum cannot
% be the first or last point.
distances_to_zone = sum((path_original - zone_definition(1,1:2)).^2,2).^0.5;
in_zone = distances_to_zone<zone_definition(1,3);

% For debugging:
fprintf('Index\tIn_zone\n');
for ith_index = 1:length(in_zone)
    fprintf(1,'%d\t %d\n',ith_index, in_zone(ith_index));
end


% Take the diff of the in_zone indices to find transitions in and out of
% zones. 
transitions_into_zone = find(diff([0; in_zone])>0);
transitions_outof_zone = find(diff([in_zone;0])<0);

% Check each of the zones to see if they are empty, and if not, whether
% they are of correct length
num_zones = length(transitions_into_zone);

% Are zones empty?
if num_zones ==0
    zone_start_stop_indices = [];
else % Are they the correct length?
    if length(transitions_into_zone)~=length(transitions_outof_zone)
        error('Unexpected mismatch in zone sizes!');
    else
        zone_widths = transitions_outof_zone - transitions_into_zone + 1;
        good_zones = find(zone_widths>=minimum_width);
                
        % For each good zone, fill in start and stop indices
        num_good_zones = length(good_zones);
        zone_start_stop_indices = zeros(num_good_zones,2);
        for ith_zone = 1:num_good_zones
            good_index = good_zones(ith_zone);
            zone_start_stop_indices(ith_zone,:) = [...
                transitions_into_zone(good_index,1) transitions_outof_zone(good_index,1)];            
        end
    end % Ends if check that the zone starts and ends match
end % Ends if check to see if zones are empty

% For debugging:
fprintf('Istart \tIend\n');
for ith_index = 1:num_good_zones
    fprintf(1,'%d\t %d\n',zone_start_stop_indices(ith_index,1), zone_start_stop_indices(ith_index,2));
end

% Find the minimum in the zones
zone_min_indices = zeros(num_good_zones,1);
for ith_zone = 1:num_good_zones
    distances_inside = distances_to_zone(zone_start_stop_indices(ith_zone,1):zone_start_stop_indices(ith_zone,2));
    [~,min_index] = min(distances_inside);

    % Check that it isn't on border
    if min_index==1 || min_index==length(distances_inside)
        % Not big enough, so set this entire zone to zero
        in_zone(start_subzone:end_subzone) = 0;
    else
        % Keep this minimum - be sure to shift it to correct indexing
        zone_min_indices(ith_zone,1) = min_index+(zone_start_stop_indices(ith_zone,1)-1); 
    end
end

% 
% 
% 
% min_indices = [];
% 
% % Check each in_zone area
% ith_index = 0; % Initialize result
% Nindices = length(in_zone);
% while (ith_index<Nindices)
%     ith_index = ith_index+1;
%     
%     % Exit?
%     if ith_index>Nindices
%         % No more points to search
%         break
%     end
%     
%     % Find the start point - first location where zone becomes 1 after
%     % present search point. Remember to shift indices based on current
%     % shift point! This is why there is the (ith_index-1) term at start.
%     start_subzone = (ith_index-1) + find(in_zone(ith_index:end,1)==1,1,'first');
% 
%     % Check if the start point was found?
%     if ~isempty(start_subzone) % Yes
%         % Find end point
%         end_subzone = (start_subzone-2) + find(in_zone(start_subzone:end,1)~=1,1,'first');
%         
%         % Is the end point zone empty? If so, it must have gone all way to
%         % the end of the data.
%         if isempty(end_subzone)
%             % Never exit the subzone at the end
%             end_subzone = Nindices;
%         end
%         % Find the minimum inside
%         distances_inside = distances_to_zone(start_subzone:end_subzone);
%         [~,min_index] = min(distances_inside);
%         
%         % Check that it isn't on border
%         if min_index==1 || min_index==length(distances_inside)
%             % Not big enough, so set this entire zone to zero
%             in_zone(start_subzone:end_subzone) = 0;
%         else
%             % Keep this minimum
%             min_indices = min_index+(start_subzone-1);
%         end
%         % Set the next search poing
%         ith_index = end_subzone;
%     else
%         % No more start points
%         ith_index = Nindices;
%     end
% end


end % ends INTERNAL_fcn_Laps_findZone

% 
% URHERE
% 
% 
% %% Find distances to start
% start_xeast = RouteStructure.start_xeast;
% start_ynorth = RouteStructure.start_ynorth;
% 

% 
% 
% indices_data = (1:length(distances_to_start_in_meters))';
% 
% % Positions close to the start line will be within the distance threshold
% distance_threshold = 5; % In meters
% 
% % Grab only the data that is close to the starting point
% closeToStartLineIndices = find(distances_to_start_in_meters<distance_threshold);  
% 
% % Fill in the distances to these indices
% close_locations = distances_to_start_in_meters*NaN;
% close_locations(closeToStartLineIndices) = distances_to_start_in_meters(closeToStartLineIndices);
% 
% % Find the inflection point by finding crossover point in the derivative
% changing_direction = diff(close_locations);
% crossing_points = find(changing_direction(1:end-1).*changing_direction(2:end)<0);
% 
% % Plot the crossing points result (for debugging)
% h_fig = figure(99947464);
% set(h_fig,'Name','Distance_to_startPoint');
% plot(indices_data,distances_to_start_in_meters,'b'); 
% hold on;
% plot(indices_data,close_locations,'r'); 
% plot(indices_data(crossing_points),distances_to_start_in_meters(crossing_points),'co'); 
% grid on
% ylim([-1 25]);
% hold on;
% ylabel('Distance to start point [m]');
% xlabel('Index of trip [unitless]');
% 
% %% Unpack the data into laps
% d = timeFilteredData.merged_gps;
% field_names = fieldnames(timeFilteredData.merged_gps); 
% numLaps = length(crossing_points) -1;
%  
% for i_Laps = 1:numLaps
%     
%     indices_for_lap = crossing_points(i_Laps):crossing_points(i_Laps+1);
%     
%     for i_subField = 1:length(field_names)
%         % Grab the name of the ith subfield
%         subFieldName = field_names{i_subField};
%         if length(d.(subFieldName))== 1
%             data_lap{i_Laps}.(subFieldName) = d.(subFieldName);
%         else
%             
%             data_lap{i_Laps}.(subFieldName) = d.(subFieldName)(indices_for_lap,:);
%         end
%         
%     end
% end
% 
% 
% %calculation station 
% for i_Laps = 1:numLaps
%     
%     
%     station = sqrt(diff(data_lap{i_Laps}.xeast).^2 + diff(data_lap{i_Laps}.ynorth).^2);
%     station = cumsum(station);
%     station = [0; station];
%     
%     data_lap{i_Laps}.station=  station;
%     
%     station = [];
%     
% end
% 
% 
% % calculate station 
% % for i_Laps = 1:numLaps
% %     lapData{i_Laps}.station(1) = 0; %sqrt((lapData{i_Laps}.clean_xeast(1))^2+ (lapData{i_Laps}.clean_ynorth(1) )^2); 
% %     lapData{i_Laps}.timeFilteredData.merged_gps.velMagnitude
% %     
% %     for i = 2:length(lapData{i_Laps}.GPS_Time)
% %         delta_station= sqrt((lapData{i_Laps}.xeast(i) - lapData{i_Laps}.xeast(i-1))^2+ (lapData{i_Laps}.ynorth(i) - lapData{i_Laps}.ynorth(i-1))^2); 
% %         lapData{i_Laps}.station(i) =  lapData{i_Laps}.station(i-1) + delta_station;
% % %         
% % %                     station = sqrt(diff(X).^2 + diff(Y).^2 + diff(Z).^2);
% % %             station = cumsum(station);
% % %             station = [0; station];
% %     end
% % end
% 
% end


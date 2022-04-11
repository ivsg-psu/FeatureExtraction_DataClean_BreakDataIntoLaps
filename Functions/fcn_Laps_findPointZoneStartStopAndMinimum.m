function [zone_start_indices, zone_end_indices, zone_min_indices] = ...
    fcn_Laps_findPointZoneStartStopAndMinimum(...
    query_path,...
    zone_definition,...
    varargin)

% fcn_Laps_findPointZoneStartStopAndMinimum
% Given a path and a point zone definition, finds the indices where the
% zone starts, where it ends, and the minimum index for the zone
% definition.  A zone is the region meeting a user-defined distance
% criteria, and a point zone is when the criteria are specified by a point
% and radius.
%
% For point zones, the zone definition is given in the form:
%       zone_definition = [X Y radius] 
% wherein X and Y specify the XY coordinates for the point, and radius
% specifies the radius from the point that the path must pass for the
% condition to be met. The minimum distance from the portion of the
% path within the radius to the XY point is considered the
% corresponding best condition. 
% 
% For each time a path goes through the zone definition, the start, end,
% and minimum-distance indices are determined and are returned by this
% function. 
% 
% has at least minimum_width points inside the given area.
%
% FORMAT:
%
%      [zone_start_indices, zone_end_indices, zone_min_indices] = ...
%      fcn_Laps_findPointZoneStartStopAndMinimum(...
%      query_path,...
%      zone_definition,...
%      (minimum_number_of_indices_in_zone),...
%      (fig_num))
%
% INPUTS:
%
%      query_path: the path, in format [X Y] where the matrix is [N by 2].
%      The path definition here is consistent with the Paths library of
%      functions.
%
%      zone_definition: the condition, defined as a point/radius defining
%      the zone. The format is zone_definition = [X Y radius], and is
%      expected to be a [1 x 3] matrix.
% 
%      (OPTIONAL INPUTS)
%
%      minimum_number_of_indices_in_zone: the miniimum required points of
%      the path that must meet the zone definition criteria in order for
%      that area to be considered a zone. The default is 3. The purpose of
%      this input is to prevent situations where noisy data, from GPS jumps
%      for example, causes a position to suddenly jump into and then out of
%      a zone definition. By requriing a minimum number of points, this
%      noise effect can be avoided.
% 
%      fig_num: a figure number to plot results.
%
% OUTPUTS:
%
%      zone_start_indices: an array of [M x 1] of the indices where each of
%      the M zones starts. If no zones are detected, the array is empty.
%
%      zone_end_indices: an array of [M x 1] of the indices where each of
%      the M zones ends. If no zones are detected, the array is empty.
%
%      zone_min_indices: an array of [M x 1] of the indices where each of
%      the M zones has a minimum distance to the point criteria. If no
%      zones are detected, the array is empty.
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
%     See the script: script_test_fcn_Laps_findPointZoneStartStopAndMinimum
%     for a full test suite.
%
% This function was written on 2022_04_08 by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% Revision history:
%     
%     2022_04_08: 
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

if flag_check_inputs
    % Are there the right number of inputs?
    if nargin < 2 || nargin > 4
        error('Incorrect number of input arguments')
    end
        
    % Check the query_path input
    fcn_DebugTools_checkInputsToFunctions(query_path, 'path');
    
    % Check the zone_definition input
    fcn_DebugTools_checkInputsToFunctions(zone_definition, '3column_of_numbers',[1 1]);

end
        
% Check for variable argument inputs (varargin)
minimum_number_of_indices_in_zone = 3; % Set default value
if 3 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        minimum_number_of_indices_in_zone = temp;
        if flag_check_inputs
            fcn_DebugTools_checkInputsToFunctions(minimum_number_of_indices_in_zone, '1column_of_numbers',[1 1]);
        end
    end
end

% Does user want to show the plots?
if 4 == nargin
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

% Set default values
zone_min_indices = [];
zone_start_indices = [];
zone_end_indices = [];

% Among these points, find the minimum distance index. The minimum cannot
% be the first or last point.
distances_to_zone = sum((query_path - zone_definition(1,1:2)).^2,2).^0.5;
in_zone = distances_to_zone<zone_definition(1,3);

% For debugging:
fprintf('Index\tIn_zone\n');
for ith_index = 1:length(in_zone)
    fprintf(1,' %d\t\t %d\n',ith_index, in_zone(ith_index));
end


% Take the diff of the in_zone indices to find transitions in and out of
% zones. 
transitions_into_zone = find(diff([0; in_zone])>0);
transitions_outof_zone = find(diff([in_zone;0])<0);

% Check each of the zones to see if they are empty, and if not, whether
% they are of correct length
num_zones = length(transitions_into_zone);

% Are zones empty?
if num_zones ~= 0  % empty
    % Due to the construciton of zones, we expect the number of entries
    % into the zones to match the number of exits. There shouldn't be any
    % situations where they don't match, but check for this just in case.
    if length(transitions_into_zone)~=length(transitions_outof_zone)
        error('Unexpected mismatch in zone sizes!');
    else
        zone_widths = transitions_outof_zone - transitions_into_zone + 1;
        good_zones = find(zone_widths>=minimum_number_of_indices_in_zone);
                
        % For each good zone, fill in start and stop indices
        num_good_zones = length(good_zones);
        zone_start_indices = zeros(num_good_zones,1);
        zone_end_indices   = zeros(num_good_zones,1);
        for ith_zone = 1:num_good_zones
            good_index = good_zones(ith_zone);
            zone_start_indices(ith_zone,:) = transitions_into_zone(good_index,1); 
            zone_end_indices(ith_zone,:) = transitions_outof_zone(good_index,1);            
        end
    end % Ends if check that the zone starts and ends match

    if num_good_zones~=0
        % For debugging:
        fprintf(1,'\nStart and end indices for good zones: \nIstart \t Iend \n');
        for ith_index = 1:num_good_zones
            fprintf(1,'%d\t\t %d\n',zone_start_indices(ith_index,1), zone_end_indices(ith_index,1));
        end
        
        % Find the minimum in the zones
        zone_min_indices = zeros(num_good_zones,1);
        for ith_zone = 1:num_good_zones
            distances_inside = distances_to_zone(zone_start_indices(ith_zone,1):zone_end_indices(ith_zone,1));
            [~,min_index] = min(distances_inside);
            zone_min_indices(ith_zone,1) = min_index+(zone_start_indices(ith_zone,1)-1);

            %             % Check that it isn't on border?
            %             if min_index==1 || min_index==length(distances_inside)
            %                 % Not big enough, so set this entire zone to zero
            %                 in_zone(start_subzone:end_subzone) = 0;
            %             else
            %                 % Keep this minimum - be sure to shift it to correct indexing
            %                 zone_min_indices(ith_zone,1) = min_index+(zone_start_indices(ith_zone,1)-1);
            %             end
        end
    end
end % Ends if check to see if zones are empty



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
    
    % Plot the query path in blue dots
    plot(query_path(:,1),query_path(:,2),'b.-','Markersize',10);
    
    % Plot the zone definition in green
    fcn_Laps_plotPointZoneDefinition(zone_definition,'g',fig_num);
    
    % Plot the results
    if num_zones ~= 0  % empty
        for ith_zone = 1:num_good_zones
            % Plot the zone
            data_to_plot = query_path(...
                zone_start_indices(ith_zone,1):zone_end_indices(ith_zone,1),:);
            h_fig = plot(data_to_plot(:,1),data_to_plot(:,2),'o-','Markersize',15,'Linewidth',3);
            color_value = get(h_fig,'Color');
            
            % Plot the minimum
            plot(...
                query_path(zone_min_indices(ith_zone,1),1),...
                query_path(zone_min_indices(ith_zone,1),1),...
                'x','Markersize',10,...            
                'Color',color_value,'Linewidth',3);
            
        end
    end
        
    
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

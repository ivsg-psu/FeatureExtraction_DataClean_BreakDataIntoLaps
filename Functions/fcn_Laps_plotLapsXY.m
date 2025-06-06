function h = fcn_Laps_plotLapsXY(traversals,varargin)
% fcn_Laps_plotLapsXY
% Plots the XY positions of all laps existing in a data structure. This is
% just a modified version of fcn_Path_plotTraversalsXY from the "Path"
% library of functions. The "laps" type and "tranversals" type are the same
% type, for consistency.
%
% FORMAT: 
%
%       h = fcn_Laps_plotLapsXY(traversals,{fig_num})
%
% INPUTS:
%
%      data: a structure containing subfields of station and Yaw in the
%      following form
%           data.traversal{ith_lap}.X
%           data.traversal{ith_lap}.Y
%      Note that ith_lap denotes an array of laps. Each lap will be
%      plotted separately.
%
%     (optional inputs)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed. 
%
% OUTPUTS:
%
%      h: a handle to the resulting figure
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

% Revision history:
% 2022_04_02
% -- wrote the code
% 2025_04_25 by Sean Brennan
% -- added global debugging options

% TO DO
% -- (add items here)

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==2 && isequal(varargin{end},-1))
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

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_fig_num = 999978; %#ok<NASGU>
else
    debug_fig_num = []; %#ok<NASGU>
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
if (0==flag_max_speed)
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(1,2);

        % Check the data input
        % fcn_Path_checkInputsToFunctions(traversals, 'traversals');

    end
end

% Does user want to show the plots?
flag_do_plot = 0; % Default is no plotting
if  2 == nargin && (0==flag_max_speed) % Only create a figure if NOT maximizing speed
    temp = varargin{end}; % Last argument is always figure number
    if ~isempty(temp) % Make sure the user is not giving empty input
        fig_num = temp;
        flag_do_plot = 1; % Set flag to do plotting
    end
else
    temp = gcf;
    fig_num = get(temp,'Number');
    if flag_do_debug % If in debug mode, do plotting but to an arbitrary figure number
        fig = figure;
        fig_for_debug = fig.Number; %#ok<NASGU>
        flag_do_plot = 1;
    end
end

temp_h = figure(fig_num);
flag_this_is_a_new_figure = 0;
if isempty(get(temp_h,'Children'))
    flag_this_is_a_new_figure = 1;
end

%% Solve for the circle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
figure(fig_num);
axis equal;

% Check to see if hold is already on. If it is not, set a flag to turn it
% off after this function is over so it doesn't affect future plotting
flag_shut_hold_off = 0;
if ~ishold
    flag_shut_hold_off = 1;
    hold on
end

NumTraversals = length(traversals.traversal);
h = zeros(NumTraversals,1);
for ith_lap= 1:NumTraversals
    if ~isempty(traversals.traversal{ith_lap})
        h(ith_lap) = plot(traversals.traversal{ith_lap}.X,traversals.traversal{ith_lap}.Y,'-o');
    else
        h(ith_lap) = plot(NaN,NaN,'-o');
    end
end

% Plot the start and end values as green and red respectively
for ith_lap= 1:NumTraversals
    if ~isempty(traversals.traversal{ith_lap})
        plot(...
            traversals.traversal{ith_lap}.X(1,1),traversals.traversal{ith_lap}.Y(1,1),'go',...
            traversals.traversal{ith_lap}.X(end,1),traversals.traversal{ith_lap}.Y(end,1),'ro');
    else
        plot(NaN,NaN,'go',NaN,NaN,'ro');
    end
end

% Shut the hold off?
if flag_shut_hold_off
    hold off;
end

% Add labels? 
if flag_this_is_a_new_figure == 1
    title('X vs Y')
    xlabel('X [m]')
    ylabel('Y [m]')

    % Make axis slightly larger?
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
if flag_do_plot
    % Nothing in here yet
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end


function h_plot = fcn_Laps_plotPointZoneDefinition(zone_center,zone_radius, varargin)
% fcn_Laps_plotPointZoneDefinition
% Plots the zone definition given by the input variable, zone_definition.
%
% Accepts as an optional second input standard plot style specifications,
% for example 'r-' for a red line.
%
% As optional third input, plots this in a user-specified figure. Returns
% the plot handle as the output. 
%
% FORMAT: 
%
%       h_plot = fcn_Laps_plotPointZoneDefinition(zone_definition,{fig_num})
%
% INPUTS:
%
%      zone_center: the condition, defined as a point/radius defining
%      the zone. The format is zone_center = [X Y] or [X Y Z], and is
%      expected to be a [1 x 2] or a [1 x 3] matrix, 
%
%      zone_radius: a scalar specifying the radius of the zone. 
%
%      (OPTIONAL INPUTS)
%   
%      plot_style: the standard plot pecification style allowing line and
%      color, for example 'r-'. Type "help plot" for a listing of options.
%
%      fig_num: a figure number to plot results.
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
%       See the script: script_test_fcn_Laps_plotPointZoneDefinition.m for
%       a full test suite.
%
% This function was written on 2022_04_10 by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% Revision history:
%     2022_04_10 
%     -- wrote the code
%     2022_04_12
%     -- fixed minor bug with showing the arrowhead

flag_do_debug = 0; % Flag to plot the results for debugging
flag_this_is_a_new_figure = 1; %#ok<NASGU> % Flag to check to see if this is a new figure
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

if flag_check_inputs == 1
    % Are there the right number of inputs?
    if nargin < 2 || nargin > 4
        error('Incorrect number of input arguments')
    end
          
    % Check the zone_center input, 2 or 3 columns, 1 row
    fcn_DebugTools_checkInputsToFunctions(zone_center, '2or3column_of_numbers',[1 1]);
    
    % Check the zone_radius input, 1 column, 1 row
    fcn_DebugTools_checkInputsToFunctions(zone_radius, 'positive_1column_of_numbers',[1 1]);

end

% Check for plot style input
flag_plot_style_is_specified = 0; % Set default flag value
if 3 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        plot_style = temp;
        flag_plot_style_is_specified = 1;
    end
end

% Does user want to show the plots?
if 4 == nargin
    temp = varargin{2};
    if ~isempty(temp)
        fig_num = temp;
        figure(fig_num);
        flag_this_is_a_new_figure = 0; %#ok<NASGU>
    end
else    
    fig = figure;
    fig_num = fig.Number;
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
grid on;

% Check to see if hold is already on. If it is not, set a flag to turn it
% off after this function is over so it doesn't affect future plotting
flag_shut_hold_off = 0;
if ~ishold
    flag_shut_hold_off = 1;
    hold on
end

% Do the plot
Xcenter = zone_center(1,1);
Ycenter = zone_center(1,2);
radius  = zone_radius;

% Plot the center point
if flag_plot_style_is_specified
    h_plot{1} = plot(Xcenter,Ycenter,plot_style,'Markersize',20);
    set(h_plot{1},'Marker','+');
else
    h_plot{1} = plot(Xcenter,Ycenter,'+','Markersize',20);
end

% Plot circle in green
angles = 0:0.01:2*pi;
x_circle = Xcenter + radius * cos(angles);
y_circle = Ycenter + radius * sin(angles);
if flag_plot_style_is_specified
    h_plot{2} = plot(x_circle,y_circle,plot_style,'Linewidth',2,'Markersize',20);    
else
    h_plot{2} = plot(x_circle,y_circle,'-','color',[0 1 0],'Linewidth',2);
end


% Plot the radius arrow
U = radius*cos(45*pi/180);
V = radius*sin(45*pi/180);
if flag_plot_style_is_specified
    h_plot{3} = quiver(Xcenter,Ycenter,U,V,0,plot_style,'Linewidth',2,'Markersize',20,'ShowArrowHead','on','MaxHeadSize',2);
else
    h_plot{3} = quiver(Xcenter,Ycenter,U,V,0,'color',[0 1 0],'Linewidth',2,'ShowArrowHead','on','MaxHeadSize',2);
end


% Shut the hold off?
if flag_shut_hold_off
    hold off;
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
    % Nothing in here yet
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end


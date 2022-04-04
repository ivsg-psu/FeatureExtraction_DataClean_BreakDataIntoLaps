% script_demo_Laps.m
% This is a script to exercise the functions within the Laps code
% library. The repo is typically located at:
%   https://github.com/ivsg-psu/FeatureExtraction_DataClean_BreakDataIntoLaps
% Questions or comments? sbrennan@psu.edu


% Revision history:
%      2022_03_27:
%      -- created a demo script of core debug utilities
%      2022_04_02
%      -- Added sample path creation
%      2022_04_04
%      -- Added minor edits

%% Set up workspace
if ~exist('flag_Laps_Folders_Initialized','var')
    
    % add necessary directories for function creation utility 
    %(special case because folders not added yet)
    debug_utility_folder = fullfile(pwd, 'Utilities', 'DebugTools');
    debug_utility_function_folder = fullfile(pwd, 'Utilities', 'DebugTools','Functions');
    debug_utility_folder_inclusion_script = fullfile(pwd, 'Utilities', 'DebugTools','Functions','fcn_DebugTools_addSubdirectoriesToPath.m');
    if(exist(debug_utility_folder_inclusion_script,'file'))
        current_location = pwd;
        cd(debug_utility_function_folder);
        fcn_DebugTools_addSubdirectoriesToPath(debug_utility_folder,{'Functions','Data'});
        cd(current_location);
    else % Throw an error?
        error('The necessary utilities are not found. Please add them (see README.md) and run again.');
    end
    
    % Now can add all the other utilities automatically
    utility_folder_PathClassLibrary = fullfile(pwd, 'Utilities', 'PathClassLibrary');
    fcn_DebugTools_addSubdirectoriesToPath(utility_folder_PathClassLibrary,{'Functions','Utilities'});
    
    % utility_folder_GetUserInputPath = fullfile(pwd, 'Utilities', 'GetUserInputPath');
    % fcn_DebugTools_addSubdirectoriesToPath(utility_folder_GetUserInputPath,{'Functions','Utilities'});

    % set a flag so we do not have to do this again
    flag_Laps_Folders_Initialized = 1;
end


%% Create sample paths? If so, use fcn_Path_fillPathViaUserInputs to fill

% Call the function to fill in an array of "path" type
laps_array = fcn_Laps_fillSampleLaps;

clear data
% Convert them all to "traversal" types
for i_Path = 1:length(laps_array)
    traversal = fcn_Path_convertPathToTraversalStructure(laps_array{i_Path});
    data.traversal{i_Path} = traversal;
end

% Plot the last one
fig_num = 1222;
single_lap.traversal{1} = data.traversal{end};
fcn_Laps_plotLapsXY(single_lap,fig_num);

%% Demonstration of codes related to fcn_DebugTools_debugPrintStringToNCharacters
clc; % Clear the console

% BASIC example 1 - string is too long
test_string = 'This is a really really really long string where I only want the first 10 characters';
fixed_length_string = fcn_DebugTools_debugPrintStringToNCharacters(test_string,10);
fprintf(1,'The string: %s\nwas converted to: "%s"\n',test_string,fixed_length_string);

% BASIC example 2 - string is too short
test_string = 'Short str that should be 40 chars';
fixed_length_string = fcn_DebugTools_debugPrintStringToNCharacters(test_string,40);
fprintf(1,'The string: %s\nwas converted to: "%s"\n',test_string,fixed_length_string);

% Advanced example
% This example shows why the function was written: to show information in a
% delimited format length

N_chars = 15;


% Create dummy data
Npoints = 10;
intersection_points = rand(Npoints,2);
s_coordinates_in_traversal_1 = rand(Npoints,1);
s_coordinates_in_traversal_2 = 1000*rand(Npoints,1);

% Print the header
header_1_str = sprintf('%s','Data ID');
fixed_header_1_str = fcn_DebugTools_debugPrintStringToNCharacters(header_1_str,N_chars);
header_2_str = sprintf('%s','Location X');
fixed_header_2_str = fcn_DebugTools_debugPrintStringToNCharacters(header_2_str,N_chars);
header_3_str = sprintf('%s','Location Y');
fixed_header_3_str = fcn_DebugTools_debugPrintStringToNCharacters(header_3_str,N_chars);
header_4_str = sprintf('%s','s-coord 1');
fixed_header_4_str = fcn_DebugTools_debugPrintStringToNCharacters(header_4_str,N_chars);
header_5_str = sprintf('%s','s-coord 2');
fixed_header_5_str = fcn_DebugTools_debugPrintStringToNCharacters(header_5_str,N_chars);

fprintf(1,'\n\n%s %s %s %s %s\n',...
    fixed_header_1_str,...
    fixed_header_2_str,...
    fixed_header_3_str,...
    fixed_header_4_str,...
    fixed_header_5_str);

% Print the results only if the array is not empty
if ~isempty(intersection_points)
    
    % Loop through all the points
    for ith_intersection =1:length(intersection_points(:,1))
        
        % Convert all the data to fixed-length format
        results_1_str = sprintf('%.0d',ith_intersection);
        fixed_results_1_str = fcn_DebugTools_debugPrintStringToNCharacters(results_1_str,N_chars);
        results_2_str = sprintf('%.12f',intersection_points(ith_intersection,1));
        fixed_results_2_str = fcn_DebugTools_debugPrintStringToNCharacters(results_2_str,N_chars);
        results_3_str = sprintf('%.12f',intersection_points(ith_intersection,2));
        fixed_results_3_str = fcn_DebugTools_debugPrintStringToNCharacters(results_3_str,N_chars);
        results_4_str = sprintf('%.12f',s_coordinates_in_traversal_1(ith_intersection));
        fixed_results_4_str = fcn_DebugTools_debugPrintStringToNCharacters(results_4_str,N_chars);
        results_5_str = sprintf('%.12f',s_coordinates_in_traversal_2(ith_intersection));
        fixed_results_5_str = fcn_DebugTools_debugPrintStringToNCharacters(results_5_str,N_chars);
        
        % Print the fixed results
        fprintf(1,'%s %s %s %s %s\n',...
            fixed_results_1_str,...
            fixed_results_2_str,...
            fixed_results_3_str,...
            fixed_results_4_str,...
            fixed_results_5_str);
        
    end % Ends for loop
end % Ends check to see if isempty

%% Demonstrate the checking of inputs to functions
% Maximum length is 5 or less
Twocolumn_of_integers_test = [4 1; 3 9; 2 7];
fcn_DebugTools_checkInputsToFunctions(Twocolumn_of_integers_test, '2column_of_integers',[5 4]);


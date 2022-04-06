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

    % Now can add all the other utilities automatically
    folder_LapsClassLibrary = fullfile(pwd);
    fcn_DebugTools_addSubdirectoriesToPath(folder_LapsClassLibrary,{'Functions'});

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




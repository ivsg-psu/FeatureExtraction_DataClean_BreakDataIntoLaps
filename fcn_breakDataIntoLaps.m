function [data_lap,numLaps] = fcn_breakDataIntoLaps(timeFilteredData,RouteStructure)
%fcn_break_data_into_laps Summary of this function goes here
%    break given data into laps and calculate station 
%   Detailed explanation goes here
%% Find distances to start
start_xeast = RouteStructure.start_xeast;
start_ynorth = RouteStructure.start_ynorth;

distances_to_start_in_meters = ((timeFilteredData.merged_gps.xeast - start_xeast).^2 + ...
    (timeFilteredData.merged_gps.ynorth - start_ynorth).^2).^0.5;


indices_data = (1:length(distances_to_start_in_meters))';

% Positions close to the start line will be within the distance threshold
distance_threshold = 5; % In meters

% Grab only the data that is close to the starting point
closeToStartLineIndices = find(distances_to_start_in_meters<distance_threshold);  

% Fill in the distances to these indices
close_locations = distances_to_start_in_meters*NaN;
close_locations(closeToStartLineIndices) = distances_to_start_in_meters(closeToStartLineIndices);

% Find the inflection point by finding crossover point in the derivative
changing_direction = diff(close_locations);
crossing_points = find(changing_direction(1:end-1).*changing_direction(2:end)<0);

% Plot the crossing points result (for debugging)
h_fig = figure(99947464);
set(h_fig,'Name','Distance_to_startPoint');
plot(indices_data,distances_to_start_in_meters,'b'); 
hold on;
plot(indices_data,close_locations,'r'); 
plot(indices_data(crossing_points),distances_to_start_in_meters(crossing_points),'co'); 
grid on
ylim([-1 25]);
hold on;
ylabel('Distance to start point [m]');
xlabel('Index of trip [unitless]');

%% Unpack the data into laps
d = timeFilteredData.merged_gps;
field_names = fieldnames(timeFilteredData.merged_gps); 
numLaps = length(crossing_points) -1;
 
for i_Laps = 1:numLaps
    
    indices_for_lap = crossing_points(i_Laps):crossing_points(i_Laps+1);
    
    for i_subField = 1:length(field_names)
        % Grab the name of the ith subfield
        subFieldName = field_names{i_subField};
        if length(d.(subFieldName))== 1
            data_lap{i_Laps}.(subFieldName) = d.(subFieldName);
        else
            
            data_lap{i_Laps}.(subFieldName) = d.(subFieldName)(indices_for_lap,:);
        end
        
    end
end


%calculation station 
for i_Laps = 1:numLaps
    
    
    station = sqrt(diff(data_lap{i_Laps}.xeast).^2 + diff(data_lap{i_Laps}.ynorth).^2);
    station = cumsum(station);
    station = [0; station];
    
    data_lap{i_Laps}.station=  station;
    
    station = [];
    
end


% calculate station 
% for i_Laps = 1:numLaps
%     lapData{i_Laps}.station(1) = 0; %sqrt((lapData{i_Laps}.clean_xeast(1))^2+ (lapData{i_Laps}.clean_ynorth(1) )^2); 
%     lapData{i_Laps}.timeFilteredData.merged_gps.velMagnitude
%     
%     for i = 2:length(lapData{i_Laps}.GPS_Time)
%         delta_station= sqrt((lapData{i_Laps}.xeast(i) - lapData{i_Laps}.xeast(i-1))^2+ (lapData{i_Laps}.ynorth(i) - lapData{i_Laps}.ynorth(i-1))^2); 
%         lapData{i_Laps}.station(i) =  lapData{i_Laps}.station(i-1) + delta_station;
% %         
% %                     station = sqrt(diff(X).^2 + diff(Y).^2 + diff(Z).^2);
% %             station = cumsum(station);
% %             station = [0; station];
%     end
% end

end


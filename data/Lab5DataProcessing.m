% EAS4810C Lab 5 Data Processing

clc; clear; close all;

% Load data
load('Lab5Data.mat');

%% Store each alpha in its own cell array
static = {static};

% Create list of variable names
alphas = {'a_14','a_12','a_11','a_10','a_8','a_7','a_5','a_2', ...
    'a0','a2','a5','a7','a8','a10','a11','a12','a14'};

var_names = {};
for alpha = 1:length(alphas)
    for pos = 1:1:9
        var = sprintf('%s_p%d',alphas{alpha},pos);
        var_names = [var_names; var];
    end
end

% Separate each alpha into its own cell array
result_cells = containers.Map();
for i = 1:length(var_names)
    name = var_names{i};
    parts = strsplit(name,'_');
    
    % Handle positive and negative alphas
    if length(parts) == 3
        prefix = strjoin(parts(1:2), '_');
    elseif length(parts) == 2
        prefix = parts{1};
    else
        continue;
    end
    
    % Create new cell array if it doesn't exist already
    if ~isKey(result_cells, prefix)
        result_cells(prefix) = {};
    end
    
    % Evaluate the current variable and append its value to the appropriate cell array
    result_cells(prefix) = [result_cells(prefix); eval(name)];
end

% Assign each cell array to a variable in the workspace
keys = result_cells.keys;
for i = 1:numel(keys)
    key = keys{i};
    assignin('base', key, result_cells(key));
end

% Clear all the matrices and extra variables
for i = 1:numel(var_names)
    var = var_names{i};
    clear(var);
end
clear alpha alphas i key keys name parts pos prefix result_cells var var_names;

%% FILTER DATA HERE


%% Compute mean and uncertainty for each run

% FORMAT:
% Column 1: Raw data
% Column 2: Mean
% Column 3: Standard deviation
% Column 4: Uncertainty

vars = who;
% Iterate through the variables in the workspace
for i = 1:numel(vars)
    var_name = vars{i};
    
    % Check if the variable is a cell array
    if iscell(evalin('base', var_name))
        data = evalin('base', var_name);  % Get the data from the cell array
        
        for j = 1:length(data)
            raw_data = data{j, 1};
            data{j, 2} = mean(raw_data);
            data{j, 3} = std(raw_data);
            data{j, 4} = 1.96*(data{j, 3}/sqrt(length(raw_data)));
        end

        % Update the cell array in the workspace
        assignin('base', var_name, data);
    end
end
clear i j raw_data vars var_name data;
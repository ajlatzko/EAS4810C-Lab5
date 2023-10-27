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
    a{i} = evalin('base', var_name);
end
clear i j raw_data vars var_name data;

%% Integrate over the surface of the airfoil to get lift and drag

% Get dx and dy between the ports. Estimate the line as the hypotenuse of
% dx and dy (Lstar = sqrt(dx^2 + dy^2)). Get angle between the port and the
% chord (theta = atan(dy/dx)). Get angle between pressure port and freestream
% velocity (gamma = theta - alpha).
%
% Calculate lift and drag at each port:
% L' = P*Lstar*cos(gamma)
% D' = P*Lstar*sin(gamma)
% STOP HERE
% Then sum all the lifts and drags across all ports at a given alpha
% Then combine the response of the positive and negative alpha

% Calculate x and y positions
t = 12/100; % Maximum thickness of 0012 airfoil
xpos = [0.1542; 0.3674; 0.7865; 1.2008; 1.6065; 2.0133; 2.4150; 2.8143; 3.2117; 4];
x_c = xpos/4;
y_c = 5*t*(0.2969*sqrt(x_c) - 0.1260*x_c - 0.3516*x_c.^2 + 0.2843*x_c.^3 - 0.1015*x_c.^4);
ypos = y_c*4;
dx = diff(xpos);
dy = diff(ypos);

alpha_pos = [0; 2; 5; 7; 8; 10; 11; 12; 14];
alpha_neg = [-14; -12; -11; -10; -9; -7; -5; -2; 0];
Lstar = sqrt(dx.^2 + dy.^2);
theta = atan(dy./dx);
for alpha = 1:length(alpha_pos)
    for i = 1:length(dx)
        gamma_pos(i,alpha) = theta(i) - alphas(alpha);
    end
end
for alpha = 1:length(alpha_neg)
    for i = 1:length(dx)
        gamma_neg(i,alpha) = theta(i) - alphas(alpha);
    end
end

for alpha = 1:length(alphas)
    for i = 1:length(dx)
        Lprime(i,alpha) = a{alpha}{i,2}*Lstar(i)*cos(gamma(i,alpha));
        Dprime(i,alpha) = a{alpha}{i,2}*Lstar(i)*sin(gamma(i,alpha));
    end
    L(alpha) = sum(Lprime(:,alpha), 1);
    D(alpha) = sum(Dprime(:,alpha), 1);
end

%% Calculate moments

% Mx: distance from port to quater chord point (distance will be positive and negative)
% My: interpolate y for each port

%% Calculate aerodynamic center

% iterate quarter chord point until M -> 0
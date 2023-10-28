% EAS4810C Lab 5 Data Processing

clc; clear; close all;

% Load data
load('Lab5Data.mat');

%% Convert inH2O to Pa
factor = 252.7;

% Get a list of workspace variables
vars = evalin('base', 'who');

% Loop through the variables and multiply them
for i = 1:length(vars)
    var_name = vars{i};
    var_val = evalin('base', var_name);
    
    if isnumeric(var_val)
        evalin('base', [var_name ' = ' var_name ' * factor;']);
    end
end
clear i factor var_val vars var_name;

%% Store each alpha in its own cell array
static = {static};

% Create list of variable names
alphas = {'a_13','a_12','a_11','a_10','a_9','a_8','a_7','a_5','a_3', ...
    'a0','a3','a5','a7','a8','a9','a10','a11','a12','a13'};

var_names = {};
for alpha = 1:length(alphas)
    for pos = 1:1:9 % Delete port 1
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

% DELETE PORT 1 FOR ALL ALPHAS
vars = who;
% Iterate through the variables in the workspace
for i = 1:numel(vars)
    var_name = vars{i};
    data = evalin('base', var_name);  % Get the data from the cell array
    
    if numel(evalin('base', var_name)) == 9
        data(1) = [];
    end
    assignin('base', var_name, data);
end
clear data i var_name vars;

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

%% Add atmospheric pressure to delta P data

P_atm = 411.31489; %767.7*133.322368;
alphas_neg = {'a0','a_3','a_5','a_7','a_8','a_9','a_10','a_11','a_12','a_13'};
alphas_pos = {'a0','a3','a5','a7','a8','a9','a10','a11','a12','a13'};
for i = 1:numel(alphas_neg)
    var_name = alphas_neg{i};
    data = evalin('base', var_name);
    for i=1:length(data)
        data{i,2} = data{i,2} + P_atm;
    end
    assignin('base', var_name, data);
end
for i = 1:numel(alphas_pos)
    var_name = alphas_pos{i};
    data = evalin('base', var_name);
    for i=1:length(data)
        data{i,2} = data{i,2} + P_atm;
    end
    assignin('base', var_name, data);
end

%% Separate alphas into positive and negative

a_neg = {};
a_pos = {};
for i = 1:numel(alphas_neg)
    var_name = alphas_neg{i};
    a_neg{i} = evalin('base', var_name);
end
for i = 1:numel(alphas_pos)
    var_name = alphas_pos{i};
    a_pos{i} = evalin('base', var_name);
end

clear i j raw_data vars var_name data alphas_neg alphas_pos P_atm;

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

% TOP
% Calculate x and y positions
t = 12/100; % Maximum thickness of 0012 airfoil
xpos = [0; 0.3674; 0.7865; 1.2008; 1.6065; 2.0133; 2.4150; 2.8143; 3.2117; 4];
x_c = xpos/4;
y_c = 5*t*(0.2969*sqrt(x_c) - 0.1260*x_c - 0.3516*x_c.^2 + 0.2843*x_c.^3 - 0.1015*x_c.^4);
ypos = y_c*4;
% Calculate dx and dy
for i = 1:length(xpos)-2
    dx(i,1) = xpos(i+2) - xpos(i);
    dy(i,1) = ypos(i+2) - ypos(i);
end

alpha_pos = [0, 3, 5, 7, 8, 9, 10, 11, 12, 13];
Lstar = sqrt(dx.^2 + dy.^2);
theta = atan(dy./dx);
for alpha = 1:length(alpha_pos)
    for i = 1:length(dx)
        gamma_pos(i,alpha) = theta(i) + deg2rad(alpha_pos(alpha));
    end
end

% Convert in to m
Lstar = Lstar*0.0254;

for alpha = 1:length(alpha_pos)
    for i = 1:length(dx)
        Lprime(i,alpha) = a_pos{alpha}{i,2}*Lstar(i)*cos(gamma_pos(i,alpha));
        Dprime(i,alpha) = a_pos{alpha}{i,2}*Lstar(i)*sin(gamma_pos(i,alpha));
    end
    Lp(1,alpha) = sum(Lprime(:,alpha));
    Dp(1,alpha) = sum(Dprime(:,alpha));
end

% BOTTOM
% Calculate x and y positions
t = 12/100; % Maximum thickness of 0012 airfoil
xpos = [0; 0.3674; 0.7865; 1.2008; 1.6065; 2.0133; 2.4150; 2.8143; 3.2117; 4];
x_c = xpos/4;
y_c = -5*t*(0.2969*sqrt(x_c) - 0.1260*x_c - 0.3516*x_c.^2 + 0.2843*x_c.^3 - 0.1015*x_c.^4);
ypos = y_c*4;
% Calculate dx and dy
for i = 1:length(xpos)-2
    dx(i,1) = xpos(i+2) - xpos(i);
    dy(i,1) = ypos(i+2) - ypos(i);
end

alpha_neg = 1*alpha_pos;
Lstar = sqrt(dx.^2 + dy.^2);
theta = atan(dy./dx);
for alpha = 1:length(alpha_neg)
    for i = 1:length(dx)
        gamma_neg(i,alpha) = theta(i) + deg2rad(alpha_neg(alpha));
    end
end

% Convert in to m
Lstar = Lstar*0.0254;

for alpha = 1:length(alpha_neg)
    for i = 1:length(dx)
        Lprime(i,alpha) = a_neg{alpha}{i,2}*Lstar(i)*cos(gamma_neg(i,alpha));
        Dprime(i,alpha) = a_neg{alpha}{i,2}*Lstar(i)*sin(gamma_neg(i,alpha));
    end
    Lp(2,alpha) = -sum(Lprime(:,alpha), 1);
    Dp(2,alpha) = -sum(Dprime(:,alpha), 1);
end

L = sum(Lp, 1);
D = sum(Dp, 1);

%% Calculate moments

% Mx: distance from port to quater chord point (distance will be positive and negative)
% My: interpolate y for each port

%% Calculate aerodynamic center

% iterate quarter chord point until M -> 0
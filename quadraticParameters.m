% Abhishek Balakrishnan
% Date: November 2014

%% PLO Parameters
% MATLAB Code based on algorithms described in paper by Steven Vitullo

% PLO
% Inputs: output estimate from TSR (y_bar)
%         dates
%         Ti - time intervals
%         Y - aggregate data

function [Q, p, A, b, Aeq, beq, y_bar_plo, t, Tind] = quadraticParameters

% Load data outputs from TSR Algorithm
load('Ti.mat');
t = dates;

% Objective Function Matrices
l = length(Ti);
Q = 2 * eye(l+1);
p = zeros(l+1,1);

% Constraint Function Matrices
% No inequalities
A = []; b =[];

% Equality constraints
Aeq = zeros(l, l+1);
    startIndex = 0;
for i=1:size(Aeq,1)
    startIndex = startIndex + 1;
    if i==1
        lowerBound = 0;
    else
        lowerBound = Ti(i-1);
    end
    upperBound = Ti(i);
    firstSum = 0;
    secondSum = 0;
    for k=lowerBound+1:upperBound
        firstSum = firstSum + (upperBound - k);
        secondSum = secondSum + (k - lowerBound);
    end
    Aeq(i, startIndex) = firstSum;
    Aeq(i, startIndex+1) = secondSum;
end

beq = zeros(1,l);
for i=1:length(beq)
    if i == 1
        t_start = 0;
    else
        t_start = Ti(i-1);
    end
    t_end = Ti(i);
    y_bar_sum = sum(y_bar(t_start+1:t_end));
    
    beq(i) = (t_end - t_start) * (Y(i) - y_bar_sum);
end

y_bar_plo = y_bar;
Tind = Ti;
end
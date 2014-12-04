% Author: Abhishek Balakrishnan
% Date: November 2014

%% TSR: Time Series Reconstruction
% MATLAB Code based on algorithms described in paper by Steven Vitullo

% TSR
% Inputs: File name for aggregate and correlation variables
% Aggregated data Y and underlying correlated variables X (from
% .CSV file)
%   Assuming aggregate data Y will come in format:
%       Date: date values
%       Dependent Variable: Value or NaN
%       Aggregated: 0 (part of interval), 1 (end of interval), or -1 (missing)
%   Assuming correlation variables data X will come in format:
%       Date: date values
%       Correlated Variable #: Value

% Outputs: Underlying estimate y_bar


function y_bar = TSR(aggregateFile, correlationFile)
% Reading data from CSV
Y = csvread(aggregateFile);
X = csvread(correlationFile);

dates = Y(1,:);
Y(1,:) = [];
X(1,:) = [];
numVars = size(X, 1);

% Find all the intervals
Ydata = Y(1,:);
Yaggregated = Y(2,:);
Yaggregatedvalues = [];
numIntervals = 0;
Ti = [];
for i=1:length(Yaggregated)
    if Yaggregated(i) == 1
        numIntervals = numIntervals+1;
        Ti(numIntervals) = i;
        Yaggregatedvalues(numIntervals) = Ydata(i);
    end
end
Yaggregatedvalues = Yaggregatedvalues';

% Plot the original aggregate data
figure(1)
Ydata(Ydata==0) = NaN;
plot(dates, Ydata, 'k.', ...
    'LineWidth', 10, ...
    'MarkerSize', 10);

% Aggregate each variable for a given interval
timeStartIndex = 1;
A = [];
for i=1:numVars
    varData = X(i,:);
    Ap = zeros(numIntervals,1);
    for j=1:numIntervals
        timeEndIndex = Ti(j);
        Ap(j) = sum(varData(timeStartIndex:timeEndIndex));
        timeStartIndex = timeEndIndex + 1;
    end
    A = horzcat(A, Ap);
end

% Solve vector of regression coefficients
% r - correlation coefficient
% m - slope value
% b - error
m = mvregress(A, Yaggregatedvalues);

% Output of model
x = X';
y_bar = x * m;
figure(2)
plot(dates, y_bar, 'b-', ...
    'LineWidth', 4);

% Save data
save('dates');
save('Ti');
save('Yaggregatedvalues');
save('y_bar');
end
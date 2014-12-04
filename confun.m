% Abhishek Balakrishnan
% November 2014

%% Constraint Function File for PLO

function [c, ceq] = confun(x)

times = load('dates.mat');
intervalIndices = load('Ti.mat');
Y = load('Yaggregatedvalues.mat');
y_bar = load('y_bar.mat');

l = length(intervalIndices) - 1;

c = [];
ceq = zeros(1,l);

% Calculate equality constraints
for j=1:l
    if j == 1
        time_next = times(j);
        time_now = 0;
    else
        time_next = times(intervalIndices(j));
        time_now = times(intervalIndices(j-1));
    end
    
    y_barSum = sum(y_bar(time_now+1:time_next));d
    for i=time_now+1:time_next
        unknownWeightSum = unknownWeightSum + ...
            x(j) * (time_next - i) + ...
            x(j+1) * (i - t_now);
    end
    ceq(j) = (time_next - time_now) * (Y(j) - y_barSum) - unknownWeightSum;
end
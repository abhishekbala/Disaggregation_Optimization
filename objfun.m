% Abhishek Balakrishnan
% November 2014

%% Objective Function File for PLO

function f = objfun(x)
x_sq = x.*x;
f = sum(x_sq);
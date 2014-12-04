% Abhishek Balakrishnan
% November 2014

%% QuadProg - MATLAB Optimization Tool
% Utilizing MATLAB quadratic programming solver
% Feeding inputs from TSR, which are computed/patched
% together in quadraticParameters.m
% Output is an array of e_values - the unknowns from
% the overall quadratic programming problem.

function e_values = quadraticProgrammingOpt
    [Q, p, A, b, Aeq, beq, y_bar_plo, t, Ti] = quadraticParameters;
    e_values = quadprog(Q,p,A,b,Aeq,beq);
    y_bar_fullshift = y_bar_plo;

    % Shifting each interval by the averaged out difference
    for j=1:length(Ti)
        if j==1
            y_bar_plo(j:Ti(j)) = y_bar_plo(j:Ti(j)) + e_values(j) / Ti(j);
        else
            y_bar_plo(Ti(j-1):Ti(j)) = ...
                y_bar_plo(Ti(j-1):Ti(j)) + e_values(j) / (Ti(j) - Ti(j-1));
        end
    end
    figure(1);
    plot(t, y_bar_fullshift, 'b-', ...
        'LineWidth', 4);
    
    % Shifting the entire interval by the overall difference
    for j=1:length(Ti)
        if j==1
            y_bar_fullshift(j:Ti(j)) = y_bar_fullshift(j:Ti(j)) + e_values(j);
        else
            y_bar_fullshift(Ti(j-1):Ti(j)) = ...
                y_bar_fullshift(Ti(j-1):Ti(j)) + e_values(j);
        end
    end
    figure(2);
    plot(t, y_bar_fullshift, 'g-', ...
    'LineWidth', 4);
end
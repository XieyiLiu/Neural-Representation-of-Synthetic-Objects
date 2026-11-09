% Shared figure helper: Map task codes to display names.
function out = switchTaskName(t)

    if strcmpi(t,'task1')
        out = 'Task 1';
    elseif strcmpi(t,'task2')
        out = 'Task 2';
    else
        out = 'PV';
    end
end

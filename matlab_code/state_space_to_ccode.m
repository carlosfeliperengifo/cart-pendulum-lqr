function state_space_to_ccode(gc,type)
switch lower(type)
    case 'controller'
        controller_to_ccode(gc);
    case 'process'    
        process_to_ccode(gc);
    otherwise
        error('Second argument must be either "controller" or "process"');
end
end

function controller_to_ccode(gc)
%% State equation
for row = 1:size(gc.A,1)
    fprintf('x%dnext\t= ',row);
    write_row(gc.A(row,:),'x');
    write_row(gc.B(row,1:fix(end/2)),'r');
    write_row(gc.B(row,fix(end/2)+1:end),'y');  
    fprintf(';\n');
end

%% Output equation
fprintf('\n\n');
for row = 1:size(gc.C,1)
    fprintf('u%d\t= ',row);
    write_row(gc.C(row,:),'x');
    write_row(gc.D(row,1:fix(end/2)),'r');
    write_row(gc.D(row,fix(end/2)+1:end),'y');  
    fprintf(';\n');
end    
end

function process_to_ccode(gc)
%% State equation
for row = 1:size(gc.A,1)
    fprintf('x%dnext\t= ',row);
    write_row(gc.A(row,:),'x');
    write_row(gc.B(row,:),'u');
    fprintf(';\n');
end

%% Output equation
fprintf('\n\n');
for row = 1:size(gc.C,1)
    fprintf('y%d\t= ',row);
    write_row(gc.C(row,:),'x');
    write_row(gc.D(row,:),'u');
    fprintf(';\n');
end    
end

function write_row(row,variable)
for k = 1:numel(row)
    %if row(k) ~= 0
    if abs(row(k)) > 1E-4
        switch row(k)
            case -1
                fprintf('-%c%d',variable,k);
            case +1
                fprintf('+%c%d',variable,k);
            otherwise    
                fprintf('%+.4f*%c%d',row(k),variable,k);
        end    
    end    
end
end

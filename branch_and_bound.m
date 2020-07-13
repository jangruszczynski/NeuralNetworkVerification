function flag = branch_and_bound(W,b,xmin,xmax)

% The following matrices have one column for each partition...
part_xmin= xmin' ;
part_xmax= xmax' ;

rv = branch_and_bound_getBounds(W,b,xmin,xmax);
if (rv(1)>0)
    flag = false;
else
    part_outBounds = rv' ;
    % The preceeding variable has 4 columns, and one row for each partition...
    %    [
    %        upperBound_min, upperBound_max, lowerBound_min, lowerBound_max ;
    %        upperBound_min, upperBound_max, lowerBound_min, lowerBound_max ;
    %    ]  

    small = 0.00001;
    diff = xmax-xmin;
    diff = max(diff, small);
    diff = 1 ./ diff';
    
    
    while true
        [val,i] = max(part_outBounds(4,:));
        
        if val <= 0
            flag = true;
            break;
        end
        s = (part_xmax(:,i) - part_xmin(:,i)) .* diff;
        [~,j] = max(s);
        sprintf("    split partition #%d, input #%d\n", i,j);
        
        % set up the vectors for the two devisions
        xmin1 = part_xmin(:,i);
        xmax1 = part_xmax(:,i);
        xmin2 = part_xmin(:,i);
        xmax2 = part_xmax(:,i);
        
        d = (xmax1(j) - xmin1(j));
        if (d <= small)
            printf("Gap of %f is too small \n", d);
            break;
        end
        mid = xmin1(j) + d*.5;
        
        % partition one of the elements of an input domain into two parts
        xmax1(j) = mid;
        xmin2(j) = mid;
        
        %review the output of the first section created
        rv1 = branch_and_bound_getBounds(W,b, xmin1', xmax1');
        part_outBounds(:,i) = rv1';
        part_xmin(:,i) = xmin1;
        part_xmax(:,i) = xmax1;
        if (rv1(3)>0)
            flag=false;
            break;
        end
        
        [~, columns] = size(part_outBounds);
        i = columns + 1;
        if i > 2000
            flag = 2;
            return
        end
        rv2 = branch_and_bound_getBounds(W,b, xmin2', xmax2');
        part_outBounds(:,i)=rv2';
        part_xmin(:,i)=xmin2;
        part_xmax(:,i)=xmax2;
        if (rv2(3)>0)
            flag=false;
            break;
        end
        
    end
    disp("xmin...");
    disp(part_xmin);
    disp("xmax...");
    disp(part_xmax);
    disp("bounds...");
    disp(part_outBounds);
    disp("");
    disp("");
end
disp("xmin...");
disp(part_xmin);
disp("xmax...");
disp(part_xmax);
disp("bounds...");
disp(part_outBounds);
disp("");
disp("");

end
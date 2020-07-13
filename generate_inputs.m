function X = generate_inputs(xmin,xmax,k)
    
    % input random values within given range
        for i = 1:k
        for j = 1:6
           %boundaries declaration
           X(i,j) = xmin(1,j) + rand()*(xmax(1,j)-xmin(1,j));
           
        end
    end
end
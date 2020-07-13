n = 500;
Bounds = zeros(2,n);
file = dir('*.mat');

for n1 = 1:n
        
        load(file(n1).name);
    
        [ymin,ymax] = interval_bound_propagation(W,b,xmin,xmax);
        
         Bounds(1,n1) = ymin;
         Bounds(2,n1) = ymax;
            
end


plot(Bounds(1,:),'bx')

hold on

plot(Bounds(2,:),'ro')

title('Lower bounds (blue) and upper bounds (red)')
xlabel('Property')
ylabel('Value')


average_upper = mean(Bounds(2,:))

average_lower = mean(Bounds(1,:))

No_proven_properties = nnz(min(Bounds(2,:),0))

function [ymin,ymax] = interval_bound_propagation(W,b,xmin,xmax)
    %positive & negative elements of W matrix
    
    x_max = transpose(xmax);
    x_min = transpose(xmin);
    
    ii = 1;
    size_nn = 5;
    
    while ii < size_nn
        
        W_positive = max(W{ii},0);
        W_negative = min(W{ii},0);

        %calculating positive & negative bounds for each neuron output

        z_max = W_positive*x_max + W_negative*x_min + b{ii};
        z_min = W_positive*x_min + W_negative*x_max + b{ii};
        
        %nonlinear operation
        
        x_max = max(0,z_max);
        x_min = max(0,z_min);
        
        ii = ii + 1;
        
    end
    
    W_positive = max(W{size_nn},0);
    W_negative = min(W{size_nn},0);
    
    ymax = W_positive*x_max+W_negative*x_min + b{size_nn};
    ymin = W_positive*x_min+W_negative*x_max + b{size_nn};
        
end
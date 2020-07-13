k_val = 50;
n = 500;
Time_elapsed  = zeros(n,k_val);
file = dir('*.mat');
Lower_bound = zeros(n,k_val);
No_counterexamples = zeros();

for k = 1:k_val
        
    
    for n1 = 1:n
        
        load(file(n1).name);
    
        %start measuring time
        tic

        A = generate_inputs(xmin,xmax,k);

        y = compute_nn_outputs(W,b,A);
        %matrix with time elapsed
        Time_elapsed(n1,k) = toc;
        
        %for each case find lower bound
        Lower_bound(n1,k) = min(y);
        
        if max(y) > 0
            
            %assuming that one or more counterexamples counts as one
            
            No_counterexamples(n1,k) = 1;
            
        end
    end
end

Time_elapsed = mean(Time_elapsed);
plot(Time_elapsed)
title('Average time elapsed vs no. of inputs')
xlabel('k')
ylabel('Time elapsed (s)')

figure

Lower_bound = mean(Lower_bound);
plot(Lower_bound, 'x')
title('Average lower bound vs no. of inputs')
xlabel('k')
ylabel('Average lower bound')

figure

No_counterexamples = sum(No_counterexamples);
bar(No_counterexamples)
title('No of properties with counterexamples')
xlabel('k')
ylabel('No of c-examples')

function X = generate_inputs(xmin,xmax,k)
    
    % input random values within given range
        for i = 1:k
        for j = 1:6
           %boundaries declaration
           X(i,j) = xmin(1,j) + rand()*(xmax(1,j)-xmin(1,j));
           
        end
    end
end

function y = compute_nn_outputs(W,b,X)
    
    X1 = transpose(X);
    ii = 1;
    size_nn = 5;
    
    while ii < size_nn
 
        %linear operation
        y1 = W{ii}*X1 + repmat(b{ii},1,size(W{ii}*X1,2));
        
        X1 = y1;
        %nonlinear operation
        X1 = max(X1,0);
        ii = ii+1;
        
    end
    
    y = W{size_nn}*X1 + repmat(b{size_nn},1,size(W{size_nn}*X1,2));
    %final result
    y = transpose(y);
    
end
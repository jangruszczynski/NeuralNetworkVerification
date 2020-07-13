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
function rv = branch_and_bound_getBounds(W, b, xmin, xmax)
%   k = 200;
%   X = generate_inputs(xmin,xmax,k);
%   y = compute_nn_outputs(W,b,X);
%   upperMin = max(y);
%   lowerMax = min(y);
% 
%   if true
%     [lowerMin,upperMax] = linear_programming_bound(W,b,xmin,xmax);
%   else
%     [lowerMin,upperMax] = interval_bound_propagation(W,b,xmin,xmax);
%   end
%   
%   rv = [upperMin, upperMax, lowerMin, lowerMax];
%   
  k = 200;
  X = generate_inputs(xmin,xmax,k);
  y = compute_nn_outputs(W,b,X);
  lowerMax = max(y);
  upperMin = min(y);
  
  if true
        [yminLower,ymaxUpper] = linear_programming_bound(W, b, xmin, xmax);
  else
      [yminLower,ymaxUpper] = interval_bound_propagation(W,b,xmin,xmax);
      ymaxLower = lowerMax;
      yminUpper = upperMin;
  end
  
  
  
  rv = [yminLower,upperMin, lowerMax, ymaxUpper];
   
end
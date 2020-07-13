function [ymin,ymax] = linear_programming_bound(W, b, xmin, xmax)
% For reference all the lineear constraints will be listed below...

%   xmin  <= z0 <= xmax
%   zk^ = Wk*zk + bk
%   zk        <= zkmax
%   -zk       <= -zkmin
%   -z(k+1)   <= 0     (1)
%   -z(k+1) + zk^ <= 0 (2)
%   z(k+1) -m*zk^ <=  - m * zk^min where m = zk^max/(zk^max-zk^min)  (3)

%% for layer 1
oldzmax = xmax';
oldzmin = xmin';
n1 = size(oldzmax,1); % number of nuerons in previous layer (nn)
n0 = size(b{1},1); % number of nuerons in layer (n0)
newzmax = zeros(1,n0);
newzmin = zeros(1,n0);
small = 0.000001;
A = [1, zeros(1,n1);... %    b muliplier
    -1, zeros(1,n1);... %     b multiplier
    zeros(n1,1),eye(n1);... %    zk             <= zkmax
    zeros(n1,1),-eye(n1)] ; %   -zk             <= -zkmin
B = [1+small, -1+small, oldzmax', -oldzmin'];   

for n = 1:n0     % current neuron number    
    f = [b{1}(n), W{1}(n,:)];
    x = linprog(f,A,B);
    newzmin(n) = W{1}(n,:)*x(2:1+n1)+b{1}(n);
    x = linprog(-f,A,B);
    newzmax(n) = W{1}(n,:)*x(2:1+n1)+b{1}(n);
end

%% for all the other layers
gap = 0;
for L = 2:5
    n0 = size(b{L},1); % number of nuerons in layer (n0)
    n1 = size(b{L-1},1); % number of neurons in previous layer (n1)
    nn = size(b{L},1);
    oldzmin = newzmin;
    oldzmax = newzmax;
    newzmax = zeros(1,n0);
    newzmin = zeros(1,n0);
    
    %calculate gradient and intercept
    m = oldzmax./(oldzmax-oldzmin);
    c = -m.*oldzmin;
    % for the sinario where the zmin is greater than zero
    ksmall = find(m>=1);
    if nnz(ksmall) >=1
        m(ksmall) = 1;
        c(ksmall) = small;
    end
    % for the sinario where zmax is less than zero
    kbig= find(oldzmax<=small);
    if nnz(kbig) >=1
        m(kbig) = 0;
        c(kbig) = small;
    end
    % find the current size of the A matrix
    [rows,columns] = size(A);
    % Add the new constraints into the A matrix
    if L<4
    A = [A,zeros(rows,n1);...
        b{L-1},zeros(n1,gap), W{L-1}, -eye(n1) ;... %         -z(k+1) + zk^   <= 0
        -m'.*b{L-1},zeros(n1,gap), -m'.*W{L-1}, eye(n1);...%     z(k+1) -m*zk^  <=  - m * zk^min
        zeros(n1,columns), -eye(n1)];        %     -z(k+1) <=0
    else % for the last layer
    A = [A,zeros(rows,n1);...
        b{L-1},zeros(n1,gap), W{L-1}, -eye(n1) ;... %         -z(k+1) + zk^   <= 0
        -m'.*b{L-1},zeros(n1,gap), -m'.*W{L-1}, eye(n1);...%     z(k+1) -m*zk^  <=  - m * zk^min
        zeros(n1,columns), -eye(n1)];        %     -z(k+1) <=0
    end
    B = [B, zeros(1,n1),c,zeros(1,n1)];
    [newrows,newcolumns] = size(A);
    for n = 1:nn     % current neuron number
        f = [b{L}(n), zeros(1,columns-1),W{L}(n,:)];
        
        x = linprog(f,A,B);
        newzmin(n) = W{L}(n,:)*x(newcolumns-n1+1:newcolumns)+b{L}(n);
        x = linprog(-f,A,B);
        newzmax(n) = W{L}(n,:)*x(newcolumns-n1+1:newcolumns)+b{L}(n);
    end
    gap = size(A,2)-1-n1;
end
ymin = newzmin;
ymax = newzmax;
  end


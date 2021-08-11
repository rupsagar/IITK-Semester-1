function x = GaussElimAlgorithm(A,b)

n = numel(b);
x = zeros(n,1);

% FORWARD ELIMINATION
for k = 1:n-1
    for i = k+1:n
        factor = A(i,k)/A(k,k);
        for j = k+1:n
            A(i,j) = A(i,j)-factor*A(k,j);
        end
        b(i) = b(i)-factor*b(k);
    end
end

% BACKWARD SUBSTITUTION
x(n) = b(n)/A(n,n);
for i = n-1:-1:1
    s = b(i);
    for j = i+1:n
        s = s-A(i,j)*x(j);
    end
    x(i) = s/A(i,i);
end
end
function K = StiffnessPoly(node,mem,E,A)

% calculating number of nodes and members
num_node = numel(node);
num_mem = size(mem,1);

% initialization
G = zeros(num_node);
K = zeros(num_node);
I = eye(num_node);

for i = 1:num_node
    for j = 1:num_node
        G(i,j) = node(i)^(j-1);
    end
end

for i = 1:num_node
    for j = i:num_node
        f = @(x)((i-1)*(j-1)*x.^(i+j-4));
        for k = 1:num_mem
        K(i,j) = K(i,j)+integral(f,node(k),node(k+1))*A(k)*E(k);
        end
        K(j,i) = K(i,j);
    end
end

K = (I/G)'*K*(I/G);

end
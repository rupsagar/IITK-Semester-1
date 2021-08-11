function K = StiffnessLag(node,mem,E,A)

% calculating number of nodes and members
num_node = numel(node);
num_mem = size(mem,1);

% initialization
K = zeros(num_node);
L = zeros(num_node-1);
sp1 = zeros(1,num_node-1);
sp2 = zeros(1,num_node-1);
xsp1 = zeros(1,num_node-1);
xsp2 = zeros(1,num_node-1);

for i = 1:num_node-1
    for j = 1:num_node-1
        f = @(x)((x.^(i+j-2)));
        for k = 1:num_mem    
            L(i,j) = L(i,j)+integral(f,node(k),node(k+1))*A(k)*E(k);
        end
    end
end

for i = 1:num_node
    for j = i:num_node
        p = 1; ii = 1; jj = 1;
        for k = 1:num_node
            if k~=i
                p = p*(node(i)-node(k));
                xsp1(ii) = node(k); ii = ii+1;
            end            
            if k~=j
                p = p*(node(j)-node(k));
                xsp2(jj) = node(k); jj = jj+1;
            end
        end
        for m = 1:num_node-1
            sp1(m) = m*(-1)^(num_node-m-1)*SumProdRecursion(xsp1,num_node-m-1);
            sp2(m) = m*(-1)^(num_node-m-1)*SumProdRecursion(xsp2,num_node-m-1);
        end
        K(i,j) = sp1*L*sp2'/p;
        K(j,i) = K(i,j);
    end
end

end
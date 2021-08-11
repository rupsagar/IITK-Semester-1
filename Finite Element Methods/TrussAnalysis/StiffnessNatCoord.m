function K = StiffnessNatCoord(node,mem,E,A)

% input data
% node = [0,0.25,.5,1];
% mem = [1,2;2,3;3,4];
% E = [1;1;1]*2;
% A = [1;1;1]*2;

% calculating number of nodes and members
n = numel(node);
num_mem = size(mem,1);

% initialization
G = zeros(n);
H = zeros(n);
alpha = zeros(n);

L = node(n)-node(1);
L1 = @(y)((node(n)-y)/L);
L2 = @(y)((y-node(1))/L);

for i = 1:n
    for j = 1:n      
        G(i,j) = L1(node(i))^(n-j)*L2(node(i))^(j-1);     
    end
end

for i = 1:n
    for j = i:n
        if i==1&&j==1
            f = @(y)((n-1)^2*((node(n)-y)/L).^(2*n-4));
        elseif i==1&&j~=1&&j<n
            f = @(y)(((node(n)-y)./L).^(2*n-j-3).*((y-node(1))/L).^(j-2)...
                .*(-(n-1)*(j-1)+((y-node(1))/L)*(n-1)^2));
        elseif i==1&&j==n
             f = @(y)(-(n-1)^2*((y-node(1))/L).^(n-2).*((node(n)-y)/L).^(n-2));
        elseif i~=1&&i<n&&j==n
            f = @(y)(((node(n)-y)/L).^(n-i-1).*((y-node(1))/L).^(n+i-4)...
                .*((n-1)*(i-1)-((y-node(1))/L)*(n-1)^2));
        elseif i==n&&j==n
            f = @(y)((n-1)^2*((y-node(1))/L).^(2*n-4));
        else
            f = @(y)(((node(n)-y)/L).^(2*n-(i+j)-2)...
                .*((y-node(1))/L).^(i+j-4)...
                .*((i-1)-(y-node(1))/L*(n-1))...
                .*((j-1)-(y-node(1))/L*(n-1)));
        end
        for k = 1:num_mem
            H(i,j) = H(i,j)+integral(f,node(k),node(k+1))*A(k)*E(k);
            H(j,i) = H(i,j);
        end
    end
    delta = zeros(n,1);
    delta(i) = 1;
    alpha(:,i) = G\delta;
end

K = alpha'*H*alpha/L^2;

end
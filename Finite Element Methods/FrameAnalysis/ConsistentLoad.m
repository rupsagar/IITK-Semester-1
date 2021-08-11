function GlobalConsistentNodalLoad = ConsistentLoad(L,T,MemberVerLoad,MemberHorLoad)

% INITIALIZING LOCAL NODAL LOAD VECTOR AND CELL FOR SHAPE FUNCTIONS
LocalNodalLoad = zeros(6,1);
N = cell(6,1);

% DEFINING SHAPE FUNCTIONS
N{2} = @(x)(2*x.^3-3*x.^2*L+L^3)/L^3;
N{3} = @(x)(x.^3*L-2*x.^2*L^2+x*L^3)/L^3;
N{5} = @(x)(-2*x.^3+3*x.^2*L)/L^3;
N{6} = @(x)(x.^3*L-x.^2*L^2)/L^3;

% CALCULATING CONSISTENT NODAL LOAD FOR MEMBER
% THE FUNCTION CAN HANDLE ONLY DISTRIBUTED AND POINT LOAD ACTING PERPENDICULAR TO THE MEMBER
for i  = [2,3,5,6]
    for j = 1:2:numel(MemberVerLoad)
        if isa(MemberVerLoad{j},'function_handle')
            N{i} = @(x)N{i}(x).*MemberVerLoad{j}(x);
            LocalNodalLoad(i) = LocalNodalLoad(i)+integral(N{i},MemberVerLoad{j+1}(1),MemberVerLoad{j+1}(2));
        elseif isa(MemberVerLoad{j},'double')
            LocalNodalLoad(i) = LocalNodalLoad(i)+MemberVerLoad{j}*N{i}(MemberVerLoad{j+1});
        end
    end
end

for i = [1,4]
    LocalNodalLoad(i) = LocalNodalLoad(i)+MemberHorLoad/2;
end

% TRANSFORMING THE LOCAL CONSISTENT LOAD TO GLOBAL COORDINATE SYSTEM
GlobalConsistentNodalLoad = T'*LocalNodalLoad;
    
end
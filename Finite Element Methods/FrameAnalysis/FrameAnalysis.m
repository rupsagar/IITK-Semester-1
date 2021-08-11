function [Kg,DOF,NodalForceVector,SupportReactionVector,MemberForceVector] = FrameAnalysis(Nodes,Members,E,I,A,NodalLoad,MemberVerLoad,MemberHorLoad,BC,Constraint)

% PROBLEM DETAILS
[NumNodes, DimOfProb] = size(Nodes); % number of nodes and dimension of problem
NumOfNodalDOF = DimOfProb+1; % totalnumber of DOF at each node
TotalNumDOF = NumNodes*NumOfNodalDOF; % total number of degree of freedoms
NumMembers = numel(Members); % number of members

% FORMATTING DATA
if size(BC,2)==NumOfNodalDOF, BC = BC'; end
if size(NodalLoad,2)==NumOfNodalDOF, NodalLoad = NodalLoad'; end
if size(Constraint,2)==NumOfNodalDOF, Constraint = Constraint'; end
BC = BC(:);
NodalLoad = NodalLoad(:);
Constraint = Constraint(:);

DOFMap1 = logical(~BC+logical(Constraint));
ConcernedDOF = Constraint(DOFMap1);
DOFMap2 = ~logical(ConcernedDOF);

% INITIALIZING
DOF = zeros(TotalNumDOF,1); % system DOF vector
L = zeros(NumMembers,1); % member length vector
CS = zeros(NumMembers,DimOfProb); % member cosine sine array
T = cell(NumMembers,1); % cell containing element transformation matrices
KElement = cell(NumMembers,1); % cell containing element stiffness matrices
DOFDef = cell(NumMembers,1); % cell containing definition of DOF of each member node
Kg = zeros(TotalNumDOF); % total system stiffness matrix
ConsistentGlobalLoad = zeros(TotalNumDOF,1); % global consistent nodal load vector
KBC1 = zeros(sum(DOFMap1)); % stiffness matrix for unknown DOF and constraint DOF
KBC2 = zeros(sum(DOFMap2)); % stiffness matrix after applying single point constraints
SupportReactionVector = cell(NumMembers,1); % support reaction vector
MemberForceVector = cell(NumMembers,1); % member force vector

for i = 1:NumMembers
    MemberNodes = Members{i};
    
    r = diff(Nodes(MemberNodes,:));
    L(i) = norm(r);
    CS(i,:) = r/L(i);
    t = [CS(i,1) CS(i,2);
        -CS(i,2) CS(i,1)];
    
    % LOCAL STIFFNESS MATRIX
    KAxial = E(i)*A(i)/L(i)*[1 -1;-1 1];
    KBending = E(i)*I(i)/L(i)^3*[12 6*L(i) -12 6*L(i);
                                6*L(i) 4*L(i)^2 -6*L(i) 2*L(i)^2;
                                -12 -6*L(i) 12 -6*L(i);
                                6*L(i) 2*L(i)^2 -6*L(i) 4*L(i)^2;];
    
    % INITIALIZING ELEMENT TRANSFORMATION MATRIX AND ELEMENT GLOBAL STIFFNESS MATRIX
    NumOfNodesOfMember = numel(MemberNodes);
    T{i} = eye(NumOfNodalDOF*NumOfNodesOfMember);
    KElement{i} = zeros(NumOfNodalDOF*NumOfNodesOfMember);
    
    % ELEMENT TRANSFORMATION MATRIX AND ELEMENT GLOBAL STIFFNESS MATRIX
    for j = 1:NumOfNodesOfMember
        T{i}(NumOfNodalDOF*j-[2 1],NumOfNodalDOF*j-[2 1]) = t;
        for k = 1:NumOfNodesOfMember
            KElement{i}(NumOfNodalDOF*j-2,NumOfNodalDOF*k-2) = KAxial(j,k);
            KElement{i}(NumOfNodalDOF*j-[1 0],NumOfNodalDOF*k-[1 0]) = KBending(2*j-[1 0],2*k-[1 0]);
        end
    end
    KElement{i} = T{i}'*KElement{i}*T{i};
    
    % DOF DEFINITION
    DOFDef{i} = [];
    for j = 1:NumOfNodesOfMember
        for k = NumOfNodalDOF:-1:1
            DOFDef{i} = [DOFDef{i},NumOfNodalDOF*MemberNodes(j)-k+1];
        end
    end
    
    % ASSEMBLING
    for j = 1:numel(DOFDef{i})
        for k = 1:numel(DOFDef{i})
            Kg(DOFDef{i}(k),DOFDef{i}(j)) = Kg(DOFDef{i}(k),DOFDef{i}(j))+KElement{i}(k,j);
        end
    end
    
    % CONSISTENT LOAD VECTOR FOR MEMBER LOADING
    ConsistentGlobalLoad(DOFDef{i}) = ConsistentGlobalLoad(DOFDef{i})+ConsistentLoad(L(i),T{i},MemberVerLoad{i},MemberHorLoad(i));
end

% IMPOSING HOMOGENEOUS BOUNDARY CONDITION
KDOFMap1 = logical(DOFMap1'.*DOFMap1);
KBC1(:) = Kg(KDOFMap1);
Load = NodalLoad+ConsistentGlobalLoad;
LoadBC1 = Load(DOFMap1);

% IMPOSING NON HOMOGENEOUS BOUNDARY CONDITION (SINGLE POINT CONSTRAINTS)
KDOFMap2 = logical((DOFMap2)'.*DOFMap2);
KBC2(:) = KBC1(KDOFMap2);
LoadBC2 = KBC1*ConcernedDOF;
LoadBC2 = LoadBC1(DOFMap2)-LoadBC2(DOFMap2);

% DISPLACEMENT IN UNRESTRAINED DOFs
if ~isempty(KBC2)
    UnknownDOF = GaussElimAlgorithm(KBC2,LoadBC2);
    ConcernedDOF(DOFMap2) = UnknownDOF;
end
DOF(DOFMap1) = ConcernedDOF;

% POST PROCESSING
% NODAL FORCE
NodalForceVector = Kg*DOF;

% MEMBER FORCE
for i = 1:NumMembers
    SupportReactionVector{i} = KElement{i}*DOF(DOFDef{i})-ConsistentLoad(L(i),T{i},MemberVerLoad{i},MemberHorLoad(i));
    MemberForceVector{i} = T{i}*SupportReactionVector{i};
end

end
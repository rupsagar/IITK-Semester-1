function [DOF,Kg,NodalForceVector,ResultantNodalForce,MemberForce] = TrussAnalysis(Nodes,Members,E,A,Load,BC,Constraint)

% PROBLEM DETAILS
[NumNodes, DimOfProb] = size(Nodes); % number of nodes and dimension of problem
NumOfNodalDOF = DimOfProb; % totalnumber of DOF at each node
TotalNumDOF = NumNodes*NumOfNodalDOF; % total number of degree of freedoms
NumMember = numel(Members); % number of members

% FORMATTING DATA
if size(BC,2)==NumOfNodalDOF, BC = BC'; end
if size(Load,2)==NumOfNodalDOF, Load = Load'; end
if size(Constraint,2)==NumOfNodalDOF, Constraint = Constraint'; end
BC = BC(:);
Load = Load(:);
Constraint = Constraint(:);

DOFMap1 = logical(~BC+logical(Constraint));
ConcernedDOF = Constraint(DOFMap1);
DOFMap2 = ~logical(ConcernedDOF);

% INITIALIZING
DOF = zeros(TotalNumDOF,1); % system DOF vector
L = zeros(NumMember,1); % member length vector
CS = zeros(NumMember,DimOfProb); % member cosine sine array
T = cell(NumMember,1); % cell containing element transformation matrices
Ke = cell(NumMember,1); % cell containing element stiffness matrices
DOFDef = cell(NumMember,1); % cell containing definition of DOF of each member node
Kg = zeros(TotalNumDOF); % total system stiffness matrix
KBC1 = zeros(sum(DOFMap1)); % stiffness matrix for unknown DOF and constraint DOF
ResultantNodalForce = zeros(NumNodes,1); % resultant nodal force vector
MemberForce = zeros(NumMember,1); % member force vector
KBC2 = zeros(sum(DOFMap2)); % stiffness matrix after applying single point constraints

for i = 1:NumMember
    MemberNodes = Members{i};
    
    r = diff(Nodes(MemberNodes,:));
    L(i) = norm(r);
    CS(i,:) = r/L(i);    
    t = [CS(i,1) CS(i,2);
        -CS(i,2) CS(i,1)];
    
    % LOCAL STIFFNESS MATRIX
    KElement = StiffnessPoly([0 L(i)],Members{i},E{i},A{i}); % Ke1ement = [1 -1;-1 1]*E{i}*Area{i}/L(i);
    
    % INITIALIZING ELEMENT TRANSFORMATION AND ELEMENT GLOBAL STIFFNESS MATRIX
    NumOfNodesOfMember = numel(MemberNodes); % future provision for developing algorithm for n noded element
    T{i} = zeros(2*NumOfNodesOfMember);
    Ke{i} = zeros(2*NumOfNodesOfMember);
    
    % ELEMENT TRANSFORMATION AND ELEMENT GLOBAL STIFFNESS MATRIX
    for j = 1:NumOfNodesOfMember
        T{i}(2*j-1:2*j,2*j-1:2*j) = t;
        for k = j:NumOfNodesOfMember
            Ke{i}(2*j-1,2*k-1) = KElement(j,k); 
            Ke{i}(2*k-1,2*j-1) = KElement(k,j);
        end
    end
    Ke{i} = T{i}'*Ke{i}*T{i};
    
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
            Kg(DOFDef{i}(k),DOFDef{i}(j)) = Kg(DOFDef{i}(k),DOFDef{i}(j))+Ke{i}(k,j);
        end
    end
end

% IMPOSING HOMOGENEOUS BOUNDARY CONDITION
KDOFMap1 = logical(DOFMap1'.*DOFMap1);
KBC1(:) = Kg(KDOFMap1);
LoadBC1 = Load(DOFMap1);

% IMPOSING NON HOMOGENEOUS BOUNDARY CONDITION (SINGLE POINT CONSTRAINTS)
KDOFMap2 = logical(DOFMap2'.*DOFMap2);
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
for i = 1:NumNodes
    sumsquare = 0;
    for j = 1:NumOfNodalDOF
        sumsquare = sumsquare+NodalForceVector(NumOfNodalDOF*(i-1)+j)^2;
    end
    ResultantNodalForce(i) = sqrt(sumsquare);
end

% MEMBER FORCE
for i = 1:NumMember
    MemberForceVector = T{i}*Ke{i}*DOF(DOFDef{i});
    MemberForce(i) = MemberForceVector(1);
end

end
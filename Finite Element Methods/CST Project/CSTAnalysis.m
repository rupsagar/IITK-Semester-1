function Output = CSTAnalysis(VerLine,HorLine)

% LOAD PROBLEM DATA
ProblemData

% DISCRETIZED GEOMETRY DATA
NumOfNodes = VerLine*HorLine; % total number of nodes of wall
NumOfElements = 2*(VerLine-1)*(HorLine-1); % total number of elements of wall

% CALCULATE ASPECT RATIO OF ELEMENT
H = WallWidth/(VerLine-1);
V = WallHeight/(HorLine-1);
AspectRatio = H/V;

% NODAL COORDINATES OF WALL ELEMENTS
X = 0:H:WallWidth;
Y = 0:V:WallHeight;
X = X'.*ones(VerLine,HorLine);
Y = Y.*ones(VerLine,HorLine);
NodeXY = [X(:),Y(:)];

% BOUNDARY CONDITIONS
BC = false(2*NumOfNodes,1);
BC(1:2*VerLine) = true; % fixity at junction of wall with slab
BCDOFMap = logical(~BC'.*~BC);

% INITIALIZATION
ElementNodes = zeros(NumOfElements,3); % array containing ID of element nodes
ElementDOF = zeros(NumOfElements,6); % array containing associated DOF of each member
A2 = zeros(NumOfElements,1); % vector containing twice of element areas
B = cell(NumOfElements,1); % cell containing element strain displacement matrices
Ke = cell(NumOfElements,1); % cell containing element stiffness matrices
Kg = zeros(2*NumOfNodes); % global system stiffnes matrix
Fb = zeros(2*NumOfNodes,1); % nodal body force vector
Ft = zeros(2*NumOfNodes,1); % nodal traction force vector
K = zeros(sum(~BC)); % system stiffness matrix in the unrestrained DOFs
Disp = zeros(2*NumOfNodes,1); % nodal displacment vector
Strain = zeros(3,NumOfElements); % array containing element shear and normal strain
Stress = zeros(3,NumOfElements); % array containing element shear and normal stress

% ELEMENT CONNECTIVITY MATRIX
index = 0;
for i = 1:NumOfElements
    if mod(i,2)~=0 % nodes for odd numbered element
        ElementNodes(i,:) = (i+1)/2+index+[0 1 VerLine];
    else % nodes for even numbered element
        ElementNodes(i,:) = i/2+index+[1 VerLine VerLine+1];
    end
    if mod(i,2*(VerLine-1))==0
        index = index+1;
    end
end

% ELEMENT LEVEL CALCULATION
for i = 1:NumOfElements
    % ELEMENT DOFs
    for k = 1:numel(ElementNodes(i,:))
        ElementDOF(i,2*k-[1 0]) = 2*ElementNodes(i,k)-[1 0]; % DOFs associated with each element
    end
    
    % TWICE OF ELEMENT AREA (POSITIVE VALUE IF NODES ARE TAKEN IN CLOCKWISE SENSE)
    A2(i) = det([ones(3,1),NodeXY(ElementNodes(i,:),:)]); % twice of element area
    
    % ELEMENT STRAIN DISPLACEMENT MATRIX
    B{i} = StrainDisp(NodeXY(ElementNodes(i,:),:),A2(i));
    
    % ELEMENT STIFFNESS MATRIX
    Ke{i} = B{i}'*D*B{i}*Thickness*abs(A2(i))/2;
    
    % ASSEMBLING ELEMENT STIFFNESS MATRIX INTO GLOBAL STIFFNESS MATRIX
    for j = 1:numel(ElementDOF(i,:))
        for k = 1:numel(ElementDOF(i,:))
            Kg(ElementDOF(i,k),ElementDOF(i,j)) = Kg(ElementDOF(i,k),ElementDOF(i,j))+Ke{i}(k,j);
        end
    end
    
    % CONTRIBUTION OF ELEMENT BODY FORCES AT EACH NODE
    Fb(ElementDOF(i,:)) = Fb(ElementDOF(i,:))+Thickness*abs(A2(i))/2/3*GammaConcrete*[0 -1 0 -1 0 -1]';
end

% CALCULATION OF TRACTION FORCE FROM RIGHT SIDE OF WALL
for i = 2*(VerLine-1):2*(VerLine-1):NumOfElements
    Limits = NodeXY(ElementNodes(i,[1 3]),2);
    TractionValue = arrayfun(TractionWallRight,Limits)*Thickness*(Limits(2)-Limits(1));
    RectLoad = TractionValue(2); % rectangular part of trapezoidal load
    TriLoad = (TractionValue(1)-TractionValue(2)); % traingular part of trapezoidal load
    Ft(ElementDOF(i,[1 5])) = Ft(ElementDOF(i,[1 5]))+RectLoad*[1/2 1/2]'+TriLoad*[2/3 1/3]';
end

% LOAD VECTOR
F = Fb+Ft;

% IMPOSING BOUNDARY CONDITIONS
K(:) = Kg(BCDOFMap);
Load = F(~BC);

% SOLVING FOR UNRESTRAINED DOFs
Disp(~BC) = K\Load;

% POST PROCESSING
for i = 1:NumOfElements
    Strain(:,i) = B{i}*Disp(ElementDOF(i,:));
    Stress(:,i) = D*Strain(:,i); % in N/m^2
end

% SHEAR FORCE AT SUPPORT
ShearForce = abs(sum(Stress(3,1:2*(VerLine-1))))*0.5*H*Thickness; % in N

% OUTPUT STRUCTURE
Output.NumOfNodes = NumOfNodes;
Output.NumOfElements = NumOfElements;
Output.AspectRatio = AspectRatio;
Output.NodeXY = NodeXY;
Output.BC = BC;
Output.ElementNodes = ElementNodes;
Output.B = B;
Output.Ke = Ke;
Output.Kg = Kg;
Output.F = F;
Output.Disp = Disp;
Output.Strain = Strain;
Output.Stress = Stress;
Output.ShearForce = ShearForce;

end
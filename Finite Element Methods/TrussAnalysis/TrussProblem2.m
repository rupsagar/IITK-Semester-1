% VALIDATION PROBLEM 2 DATA
Nodes = [0,0;3,4;0,4];
Members = {[1,2];[1,3]};
E = {210e9;210e9};
Area = {6e-4;6e-4};
Load = [0,1000000;0,0;0,0];
BC = logical([0,0;1,1;1,1]);
Constraint = [-0.0500000000000000,0;0,0;0,0];

% TRUSS ANALYSIS
[DOF,Kg,~,~,MemberForce] = TrussAnalysis(Nodes,Members,E,Area,Load,BC,Constraint);

% PRINT RESULT
[~] = PrintTrussResult(Kg,DOF,MemberForce);
% VALIDATION PROBLEM 1 DATA
Nodes = [0,0;0,120;120,120;120,0];
Members = {[1,2];[1,3];[1,4]};
E = {30e6;30e6;30e6};
Area = {2;2;2};
Load = [0,-10000;0,0;0,0;0,0];
BC = logical([0,0;1,1;1,1;1,1]);
Constraint = [0,0;0,0;0,0;0,0];

% TRUSS ANALYSIS
[DOF,Kg,~,~,MemberForce] = TrussAnalysis(Nodes,Members,E,Area,Load,BC,Constraint);

% PRINT RESULT
[~] = PrintTrussResult(Kg,DOF,MemberForce);
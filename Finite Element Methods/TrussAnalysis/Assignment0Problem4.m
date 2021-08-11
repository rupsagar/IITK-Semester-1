Nodes = [0,0;0,-6000;-8000*cos(30*pi/180),8000*sin(30*pi/180);5000*cos(45*pi/180),5000*sin(45*pi/180)];
Members = {[1,2];[1,3];[1,4]};
E = {200e3;200e3;200e3};
Area = {6000;5000;4000};
Load = [-72081.59492,-32235.49801;0,0;0,0;0,0];
BC = logical([0,0;1,1;1,1;1,1]);
Constraint = [0,0;0,0;0,0;0,0];

% TRUSS ANALYSIS
[DOF,Kg,~,~,MemberForce] = TrussAnalysis(Nodes,Members,E,Area,Load,BC,Constraint);

% PRINT RESULT
[~] = PrintTrussResult(Kg,DOF,MemberForce);
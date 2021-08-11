% VALIDATION PROBLEM 1 DATA
Nodes = [0 0;0 120;120 120;120 0];
Members = {[1,2];[2,3];[3,4]};
E = [30e6;30e6;30e6];
I = [200;100;200];
A = [10;10;10];
NodalLoad = [0,0,0;10000,0,0;0,0,5000;0,0,0];
MemberVerLoad = {{0,0},{0,0},{0,0}};

MemberHorLoad = [0,0];

BC = logical([1,1,1;0,0,0;0,0,0;1,1,1]);
Constraint = [0,0,0;0,0,0;0,0,0;0,0,0];

% FRAME ANALYSIS
[Kg,DOF,~,MemberForceVector] = FrameAnalysis(Nodes,Members,E,I,A,NodalLoad,MemberVerLoad,MemberHorLoad,BC,Constraint);

% PRINT RESULT
PrintFrameResult(Kg,DOF,MemberForceVector);
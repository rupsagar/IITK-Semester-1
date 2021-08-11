% VALIDATION PROBLEM 2 DATA
Nodes = [0,0;10,8;0,8];
Members = {[1,2];[2,3]};
E = [70e6;70e6];
I = [4.16e-5*2;4.16e-5];
A = [12.9e-3;6.45e-3];
NodalLoad = [0,0,0;0,-50,-5;0,0,0];
MemberVerLoad = {{0,0},{0,0}};

MemberHorLoad = [0,0];

BC = logical([1,1,1;0,0,0;1,1,1]);
Constraint = [0,0,0;0,0,0;0,-.005,0];

% FRAME ANALYSIS
[Kg,DOF,~,SupportReactionVector,MemberForceVector] = FrameAnalysis(Nodes,Members,E,I,A,NodalLoad,MemberVerLoad,MemberHorLoad,BC,Constraint);

% PRINT RESULT
PrintFrameResult(Kg,DOF,SupportReactionVector,MemberForceVector);
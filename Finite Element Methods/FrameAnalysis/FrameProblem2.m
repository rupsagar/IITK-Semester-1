% VALIDATION PROBLEM 2 DATA
Nodes = [0,0;360,360;840,360];
Members = {[1,2];[2,3]};
E = [30000;30000];
I = [1000;1000];
A = [100;100];
NodalLoad = [0,0,0;0,0,0;0,0,0];
MemberVerLoad = {{0,0},{@(x)(-1/12),[0 480]}};

MemberHorLoad = [0,0];

BC = logical([1,1,1;0,0,0;1,1,1]);
Constraint = [0,0,0;0,0,0;0,0,0];

% FRAME ANALYSIS
[Kg,DOF,~,MemberForceVector] = FrameAnalysis(Nodes,Members,E,I,A,NodalLoad,MemberVerLoad,MemberHorLoad,BC,Constraint);

% PRINT RESULT
PrintFrameResult(Kg,DOF,MemberForceVector);
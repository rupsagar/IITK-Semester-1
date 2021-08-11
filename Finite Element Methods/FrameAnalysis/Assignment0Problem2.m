% VALIDATION PROBLEM 2 DATA
Nodes = [0,0;10,0;13,-4];
Members = {[1,2];[2,3]};
E = [200e6;200e6];
I = [45.231e-5;8.604e-5];
A = [11.074e-3;5.626e-3];
NodalLoad = [0,0,0;0,0,50;0,0,0];
MemberVerLoad = {{-500*sin(atan(4/3)),6},{@(x)-10,[0 5]}};

MemberHorLoad = [500*cos(atan(4/3)),0];

BC = logical([1,1,1;0,0,0;1,1,0]);
Constraint = [0,0,0;0,0,0;0,-.01,0];

% FRAME ANALYSIS
[Kg,DOF,~,SupportReactionVector,MemberForceVector] = FrameAnalysis(Nodes,Members,E,I,A,NodalLoad,MemberVerLoad,MemberHorLoad,BC,Constraint);

% PRINT RESULT
PrintFrameResult(Kg,DOF,SupportReactionVector,MemberForceVector);
% Nodes = [0,0;480,0;840,480;240,480];
% Members = {[1,4];[2,4];[4,3]};
% E = [30e3;30e3;30e3];
% I = [800;800;800];
% A = [8;8;8];
% NodalLoad = [0,0,0;0,0,0;0,0,0;0,0,0];
% MemberVerLoad = {{13.42,268.3281573},{0,0},{0,0}};
% 
% MemberHorLoad = [-6.72,0,0];
% 
% BC = logical([1,1,1;1,1,1;1,1,1;0,0,0]);
% Constraint = [0,0,0;0,0,0;0,0,0;0,0,0];

Nodes = [0,0;480,0;840,480;240,480;120,240];
Members = {[1,5];[5,4];[2,4];[4,3]};
E = [30e3;30e3;30e3;30e3];
I = [800;800;800;800];
A = [8;8;8;8];
NodalLoad = [0,0,0;0,0,0;0,0,0;0,0,0;-15,0,0];
MemberVerLoad = {{0,0},{0,0},{0,0},{0,0}};

MemberHorLoad = [0,0,0,0];

BC = logical([1,1,1;1,1,1;1,1,1;0,0,0;0,0,0]);
Constraint = [0,0,0;0,0,0;0,0,0;0,0,0;0,0,0];

% FRAME ANALYSIS
[Kg,DOF,~,SupportReactionVector,MemberForceVector] = FrameAnalysis(Nodes,Members,E,I,A,NodalLoad,MemberVerLoad,MemberHorLoad,BC,Constraint);

% PRINT RESULT
PrintFrameResult(Kg,DOF,SupportReactionVector,MemberForceVector);
% MAXIMUM ALLOWABLE RELATIVE APPROXIMATE PERCENTAGE ERROR
EaMax = 0.5; % in percentage (%)

% DISCRETIZATION (USER INPUT - ALL VALUES MUST BE GREATER THAN ONE)
VerLine = [6 11 16 21 26 31 36 41 46 51 56]; % make divisions along width of slab
HorLine = [11 21 31 41 51 61 71 81 91 101 111]; % make divisions along height of slab

NumOfIter = numel(VerLine); % maximum number of iterations intended
MeshSensitivity = zeros(NumOfIter,3); % array containing mesh sensitivity details

for i = 1:NumOfIter
    % PERFORM PLANE STRAIN ANALYSIS WITH CST ELEMENTS
    Output = CSTAnalysis(VerLine(i),HorLine(i));
    
    % STORING CURRENT ITERATION MESH SIZE, TIP DEFLECTION, RELATIVE APPROXIMATE ERROR
    if i==1
        Ea = 100; % in percentage (%)
    else
        Ea = abs(1-MeshSensitivity(i-1,2)/abs(Output.Disp(end-1)))*100; % in percentage (%)
    end
    MeshSensitivity(i,:) = [Output.NumOfElements,abs(Output.Disp(end-1)),Ea];
    
    % PLOT MESH AND BOUNDARY CONDITIONS (COMMENT THIS TO SPEED UP CODE EXECUTION)
%     SavePlotMeshBC(VerLineWall(i),HorLineWall(i),Output,'on')
    
    % CHECK WHETHER RELATIVE APPROXIMATE ERROR IS LESS THAN MAXIMUM ALLOWABLE RELATIVE APPROXIMATE ERROR
    if Ea<=EaMax
        NumOfIter = i;
        break;
    end
end

% PLOT MESH SENSITIVITY
SavePlotMeshSensitivity(MeshSensitivity(1:NumOfIter,:),'on')
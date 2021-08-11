function SavePlotMeshBC(VerLineWall,HorLineWall,Output,DisplayPlot)

MeshFig = figure('visible','off','WindowState','maximized');
Axis1 = gca;
hold on

% PLOT MESH
for j = 1:Output.NumOfElements
    plot(Axis1,Output.NodeXY(Output.ElementNodes(j,[1 2 3 1]),1),Output.NodeXY(Output.ElementNodes(j,[1 2 3 1]),2),'-b')
end

% PLOT BOUNDARY CONDITION
for j = 1:Output.NumOfNodes
    if Output.BC(2*j-1)&&Output.BC(2*j)
        plot(Axis1,Output.NodeXY(j,1),Output.NodeXY(j,2),'.r','MarkerSize',15)
    end
end

title(['Discretized geometry with ',num2str(VerLineWall),' vertical lines and ',num2str(HorLineWall),' horizontal lines'])
xlabel('X (m)')
ylabel('Y (m)')
Axis1.XLim = [-1 1.5];
Axis1.YLim = [-1 6.5];
grid on
box on
saveas(MeshFig,['GeneratedMesh',num2str(Output.NumOfElements),'.jpg'])  
MeshFig.Visible = DisplayPlot;

end
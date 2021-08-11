function SavePlotMeshSensitivity(MeshSensitivity,DisplayPlot)

DeflectionFig = figure('visible','off','WindowState','maximized');
plot(MeshSensitivity(:,1),MeshSensitivity(:,2),'ob-','MarkerFaceColor','b')
title('Calculated tip deflection vs number of CST elements')
xlabel('Number of CST elements')
ylabel('Absolute value of tip deflection (m)')
grid on
box on
saveas(DeflectionFig,['DeflectionConvergenceFig ',num2str(MeshSensitivity(:,1)'),'.jpg'])

ErrorFig = figure('visible','off','WindowState','maximized');
plot(MeshSensitivity(:,1),MeshSensitivity(:,3),'ob-','MarkerFaceColor','b')
title('Relative approximate percentage error vs number of CST elements')
xlabel('Number of CST elements')
ylabel('Relative approximate error of tip deflection (%)')
grid on
box on
saveas(ErrorFig,['ErrorFig ',num2str(MeshSensitivity(:,1)'),'.jpg'])


DeflectionFig.Visible = DisplayPlot;
ErrorFig.Visible = DisplayPlot;

end
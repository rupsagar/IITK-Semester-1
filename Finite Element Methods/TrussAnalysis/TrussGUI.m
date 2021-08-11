function TrussGUI

NodeStatus = false;
MemberStatus = false;
DimOfProb = 2;

Nodes = [];
Members = {};
E = {};
Area = {};
Load = [];
BC = [];
Constraint = [];

Kg = [];
DOF = [];
% NodalForceVector = [];
% ResultantNodalForce = [];
MemberForce = [];

Fig = figure;
Fig.Name = 'TrussGUI';
Fig.WindowState = 'maximized';

    Axes = axes;
    Axes.Parent = Fig;
    Axes.Position = [0.55 0.10 0.40 0.80];
    Axes.XGrid = 'on';
    Axes.YGrid = 'on';
    Axes.XLabel.String = 'x';
    Axes.YLabel.String = 'y';

    TabGroup = uitabgroup;
    TabGroup.Parent = Fig;
    TabGroup.Position = [0.05 0.05 0.45 .90];

        NodeTab = uitab;
        NodeTab.Parent = TabGroup;
        NodeTab.Title = 'Node Details';
            NodeTable = uitable;
            NodeTable.Parent = NodeTab;
            NodeTable.Data = {[],[]};
            NodeTable.ColumnName = {'X Coordinate','Y Coordinate'};
            NodeTable.ColumnEditable = true;
            NodeTable.ColumnFormat = {'numeric','numeric'};
            NodeTable.FontUnits = 'normalized';
            NodeTable.FontSize = .05;
            NodeTable.RowStriping = 'off';
            NodeTable.Units = 'normalized';
            NodeTable.Position = [0.05 0.30 0.90 0.65];
            NodeTable.CellEditCallback = @CellEditCallback;
            
            AddNode = uicontrol;
            AddNode.Parent = NodeTab;
            AddNode.Style = 'pushbutton';
            AddNode.Units = 'normalized';
            AddNode.Position = [0.05 0.05 0.40 0.07];
            AddNode.FontUnits = 'normalized';
            AddNode.FontSize = 0.50;
            AddNode.String = 'Add Node';
            AddNode.Callback = @ButtonCallback;

        MemberTab = uitab;
        MemberTab.Parent = TabGroup;
        MemberTab.Title = 'Member Details';
            MemberTable = uitable;
            MemberTable.Parent = MemberTab;
            MemberTable.Data = {[],[],[],[]};
            MemberTable.ColumnName = {'Node i','Node j','Young''s Modulus','Area'};
            MemberTable.ColumnEditable = true;
            MemberTable.ColumnFormat = {'numeric','numeric','numeric','numeric'};
            MemberTable.FontUnits = 'normalized';
            MemberTable.FontSize = .05;
            MemberTable.RowStriping = 'off';
            MemberTable.Units = 'normalized';
            MemberTable.Position = [0.05 0.30 0.90 0.65];
            MemberTable.CellEditCallback = @CellEditCallback;
            
            AddMember = uicontrol;
            AddMember.Parent = MemberTab;
            AddMember.Style = 'pushbutton';
            AddMember.Units = 'normalized';
            AddMember.Position = [0.05 0.05 0.40 0.07];
            AddMember.FontUnits = 'normalized';
            AddMember.FontSize = 0.5;
            AddMember.String = 'Add Member';
            AddMember.Callback = @ButtonCallback;

        LoadTab = uitab;
        LoadTab.Parent = TabGroup;
        LoadTab.Title = 'Load Details';
            LoadTable = uitable;
            LoadTable.Parent = LoadTab;
            LoadTable.Data = {[],[]};
            LoadTable.ColumnName = {'X Direction Load','Y Direction Load'};
            LoadTable.ColumnEditable = true;
            LoadTable.ColumnFormat = {'numeric','numeric'};
            LoadTable.FontUnits = 'normalized';
            LoadTable.FontSize = .05;
            LoadTable.RowStriping = 'off';
            LoadTable.Units = 'normalized';
            LoadTable.Position = [0.05 0.30 0.90 0.65];
            LoadTable.CellEditCallback = @CellEditCallback;
            
        BCTab = uitab;
        BCTab.Parent = TabGroup;
        BCTab.Title = 'Boundary Conditions';
            BCTable = uitable;
            BCTable.Parent = BCTab;
            BCTable.Data = {[],[],[],[]};
            BCTable.ColumnName = {'X DOF Fixed','Y DOF Fixed','X DOF Constraint','Y DOF Constraint'};
            BCTable.ColumnEditable = true;
            BCTable.ColumnFormat = {'logical','logical','numeric','numeric'};
            BCTable.FontUnits = 'normalized';
            BCTable.FontSize = .05;
            BCTable.RowStriping = 'off';
            BCTable.Units = 'normalized';
            BCTable.Position = [0.05 0.30 0.90 0.65];
            BCTable.CellEditCallback = @CellEditCallback;
            

        AnalysisTab = uitab;
        AnalysisTab.Parent = TabGroup;
        AnalysisTab.Title = 'Analyse/Post Processing';
            AnalyzeTruss = uicontrol;
            AnalyzeTruss.Parent = AnalysisTab;
            AnalyzeTruss.Style = 'pushbutton';
            AnalyzeTruss.Units = 'normalized';
            AnalyzeTruss.Position = [0.10 0.60 0.60 0.07];
            AnalyzeTruss.FontUnits = 'normalized';
            AnalyzeTruss.FontSize = 0.5;
            AnalyzeTruss.String = 'Analyse Truss';
            AnalyzeTruss.Callback = @ButtonCallback;
            
            PrintResult = uicontrol;
            PrintResult.Parent = AnalysisTab;
            PrintResult.Style = 'pushbutton';
            PrintResult.Units = 'normalized';
            PrintResult.Position = [0.10 0.45 0.60 0.07];
            PrintResult.FontUnits = 'normalized';
            PrintResult.FontSize = 0.50;
            PrintResult.String = 'Print Results';
            PrintResult.Callback = @ButtonCallback;
            
    
    function CellEditCallback(hObject,EventData)
        PresentTab = TabGroup.SelectedTab;
        r = EventData.Indices(1);
        c = EventData.Indices(2);    
        switch PresentTab.Title
            case NodeTab.Title
                NodeStatus = false;
                if ~isempty(hObject.Data{r,1})&&~isempty(hObject.Data{r,2})&&...
                        ~isnan(hObject.Data{r,1})&&~isnan(hObject.Data{r,2})&&...
                        ~isinf(hObject.Data{r,1})&&~isinf(hObject.Data{r,2})
                    Nodes(r,:) = [hObject.Data{r,1} hObject.Data{r,2}];
                    NodeStatus = true;
                    BCTable.Data{r,1} = true; BCTable.Data{r,2} = true;
                    BCTable.Data{r,3} = 0; BCTable.Data{r,4} = 0;
                    LoadTable.Data{r,1} = 0; LoadTable.Data{r,2} = 0;
                    
                    BC(r,:) = [BCTable.Data{r,1},BCTable.Data{r,2}];
                    Constraint(r,:) = [BCTable.Data{r,3},BCTable.Data{r,4}];                  
                    Load(r,:) = [LoadTable.Data{r,1},LoadTable.Data{r,2}];
                    PlotUpdate
                end
            case MemberTab.Title
                MemberStatus = false;
                if ~isempty(hObject.Data{r,1})&&~isempty(hObject.Data{r,2})&&...
                        ~isempty(hObject.Data{r,3})&&~isempty(hObject.Data{r,4})&&...
                        ~isnan(hObject.Data{r,1})&&~isnan(hObject.Data{r,2})&&...
                        ~isnan(hObject.Data{r,3})&&~isnan(hObject.Data{r,4})&&...
                        ~isinf(hObject.Data{r,1})&&~isinf(hObject.Data{r,2})&&...
                        ~isinf(hObject.Data{r,3})&&~isinf(hObject.Data{r,4})&&...
                        hObject.Data{r,1}<=size(Nodes,1)&&hObject.Data{r,2}<=size(Nodes,1)
                    Members{r} = [hObject.Data{r,1} hObject.Data{r,2}];
                    E{r} = hObject.Data{r,3};
                    Area{r} = hObject.Data{r,4};
                    MemberStatus = true;
                    PlotUpdate
                end
            case LoadTab.Title
                Load(r,c) = hObject.Data{r,c};
                PlotUpdate
            case BCTab.Title
                if c<=DimOfProb
                    BC(r,c) = hObject.Data{r,c};
                else
                    Constraint(r,c-DimOfProb) = hObject.Data{r,c};
                end
                PlotUpdate
        end     
    end

    function ButtonCallback(hObject,~)
        PresentTab = TabGroup.SelectedTab;      
        switch PresentTab.Title
            case NodeTab.Title
                NodeTable.Data = [NodeTable.Data;{[],[]}];
                BCTable.Data = [BCTable.Data;{[],[],[],[]}];
                LoadTable.Data = [LoadTable.Data;{[],[]}];
            case MemberTab.Title
                MemberTable.Data = [MemberTable.Data;{[],[],[],[]}];
            case AnalysisTab.Title
                switch hObject.String
                    case AnalyzeTruss.String
                        if NodeStatus&&MemberStatus                            
                            [DOF,Kg,~,~,MemberForce] = TrussAnalysis(Nodes,Members,E,Area,Load,BC,Constraint);
                            PlotUpdate
                            msgbox('Analysis completed')
                        elseif NodeStatus
                            msgbox('Fill member details correctly')
                        else
                            msgbox('Fill node details correctly')
                        end
                    case PrintResult.String
                        filename = PrintTrussResult(Kg,DOF,MemberForce);
                        msgbox(['Results printed in ''',filename,''' file'])
                end
        end
    end

    function PlotUpdate
            XCenter = (max(Nodes(:,1))+min(Nodes(:,1)))/2;
            XRadius = (max(Nodes(:,1))-min(Nodes(:,1)))/2;
            XExtraFactor = 2;
            YCenter = (max(Nodes(:,2))+min(Nodes(:,2)))/2;
            YRadius = (max(Nodes(:,2))-min(Nodes(:,2)))/2;
            YExtraFactor = 2;

            for i = 1:size(Nodes,1)
                if BC(i,1)&&BC(i,2)
                    NodeMarker = '^';
                    NodeMarkerColor = 'r';
                elseif ~BC(i,1)&&~BC(i,2)&&~Constraint(i,1)&&~Constraint(i,2)
                    NodeMarker = 'o';
                    NodeMarkerColor = 'g';
                else
                    NodeMarker = 'o';
                    NodeMarkerColor = 'k';
                end
                plot(Nodes(i,1),Nodes(i,2),[NodeMarker,NodeMarkerColor],'MarkerFaceColor',NodeMarkerColor)
                hold on
                plot(Nodes(i,1)+Constraint(i,1),Nodes(i,2)+Constraint(i,2),[NodeMarker,NodeMarkerColor],'MarkerFaceColor',NodeMarkerColor)

                if Load(i,1)~=0
                    LoadLength = Load(i,1)/max(abs(Load(:,1)))*(XExtraFactor-1)*XRadius;
                    LoadMarkerColor = 'c';
                    if Load(i,1)>0
                        LoadMarker = '>';
                    end
                    if Load(i,1)<0
                        LoadMarker = '<';
                    end
                    plot(Nodes(i,1)+[0 LoadLength],[Nodes(i,2) Nodes(i,2)],['-',LoadMarkerColor])
                    plot(Nodes(i,1)+LoadLength,Nodes(i,2),[LoadMarker,LoadMarkerColor],'MarkerFaceColor',LoadMarkerColor)
                end

                if Load(i,2)~=0
                    LoadLength = Load(i,2)/max(abs(Load(:,2)))*(YExtraFactor-1)*YRadius;
                    LoadMarkerColor = 'c';
                    if Load(i,2)>0
                        LoadMarker = '^';
                    end
                    if Load(i,2)<0
                        LoadMarker = 'v';
                    end
                    plot([Nodes(i,1) Nodes(i,1)],Nodes(i,2)+[0 LoadLength],['-',LoadMarkerColor])
                    plot(Nodes(i,1),Nodes(i,2)+LoadLength,[LoadMarker,LoadMarkerColor],'MarkerFaceColor',LoadMarkerColor)
                end
            
            end
            
            for i = 1:numel(Members)
                plot(Nodes(Members{i},1),Nodes(Members{i},2),'-b')
                plot(Nodes(Members{i},1)+Constraint(Members{i},1),Nodes(Members{i},2)+Constraint(Members{i},2),'--b')
            end
            
            hold off
            if min(Nodes(:,1))~=max(Nodes(:,1))
                Axes.XLim = XCenter+XRadius*XExtraFactor*[-1 1];
            end
            if min(Nodes(:,2))~=max(Nodes(:,2))
                Axes.YLim = YCenter+YRadius*YExtraFactor*[-1 1];
            end
            Axes.XGrid = 'on';
            Axes.YGrid = 'on';
            Axes.XLabel.String = 'X';
            Axes.YLabel.String = 'Y';
    end

end
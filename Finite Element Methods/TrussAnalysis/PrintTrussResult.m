function filename = PrintTrussResult(Kg,DOF,MemberForce)

TotalNumDOF = size(Kg,1);
FormatSpec = repmat('% 10.6e    ',1,TotalNumDOF);
filename = 'TrussAnalysisResult.txt';
fid = fopen(filename,'w');

fprintf(fid,'System Stiffness Matrix [K_g]\n');
fprintf(fid,[FormatSpec,'\n'],Kg');

fprintf(fid,'\nNodal Displacement Vector {d}\n');
fprintf(fid,'% 10.6e\n',DOF);

fprintf(fid,'\nMember Forces\n');
for i = 1:numel(MemberForce)
    if MemberForce(i)<0
        ForceNature = 'Tensile';
    elseif MemberForce(i)>0
        ForceNature = 'Compressive';
    else
        ForceNature = 'Zero Force';
    end
    fprintf(fid,'% 10.6e    %s\n',MemberForce(i),ForceNature);
end   

fclose(fid);

end
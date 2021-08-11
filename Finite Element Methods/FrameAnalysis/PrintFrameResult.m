function PrintFrameResult(Kg,DOF,SupportReactionVector,MemberForceVector)

TotalNumDOF = size(Kg,1);
FormatSpec = repmat('% 10.6e    ',1,TotalNumDOF);

fid = fopen('FrameAnalysisResults.txt','w');

fprintf(fid,'System Stiffness Matrix [K_g]\n');
fprintf(fid,[FormatSpec,'\n'],Kg');

fprintf(fid,'\nNodal Displacement Vector {d}\n');
fprintf(fid,'% 10.6e\n',DOF);

fprintf(fid,'\nSupport Reaction Vector\n');
for i = 1:numel(SupportReactionVector)
    fprintf(fid,['Member',num2str(i),'\n']);
    fprintf(fid,'% 10.6e\n',SupportReactionVector{i});
end

fprintf(fid,'\nMember Force Vector\n');
for i = 1:numel(MemberForceVector)
    fprintf(fid,['Member',num2str(i),'\n']);
    fprintf(fid,'% 10.6e\n',MemberForceVector{i});
end

fclose(fid);

end
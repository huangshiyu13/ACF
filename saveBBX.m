function saveBBX( bbx,filename )
%SAVEBBX Summary of this function goes here
%   Detailed explanation goes here
fid=fopen(filename,'w');
fprintf(fid,'%% bbGt version=3\n');
lenlen = size(bbx,1);
for i = 1:lenlen,
    fprintf(fid,'person %g %g %g %g %g 0 0 0 0 0 0\n',bbx(i,1),bbx(i,2),bbx(i,3),bbx(i,4),bbx(i,5));
end
fclose(fid);

end

